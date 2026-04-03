---
title: "CloudFormation Deploy with CDK and Script"
date: 2026-04-03
weight: 5
chapter: false
pre: " <b> 5.5. </b> "
---

## 5.5 CloudFormation Deploy with CDK and Script

This section describes how to deploy the infrastructure stack using AWS CDK and the PowerShell automation script.

## 1. Prerequisites

1. AWS CLI is configured and logged in.
2. Node.js and npm are installed.
3. CDK dependencies are available in the myfit-infra project.
4. You have access to Route 53 hosted zone and ACM certificate (if custom domain is used).

## 2. Included implementation files

### 2.1 CDK stack file (`myfit-infra/lib/myfit-infra-stack.ts`)

This stack defines VPC, RDS, ECS Fargate, S3, CloudFront, Route 53 aliases, IAM roles, and outputs.

Full file:

```ts
import * as cdk from 'aws-cdk-lib';
import * as ec2 from 'aws-cdk-lib/aws-ec2';
import * as ecs from 'aws-cdk-lib/aws-ecs';
import * as ecsPatterns from 'aws-cdk-lib/aws-ecs-patterns';
import * as rds from 'aws-cdk-lib/aws-rds';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as cloudfront from 'aws-cdk-lib/aws-cloudfront';
import * as origins from 'aws-cdk-lib/aws-cloudfront-origins';
import * as acm from 'aws-cdk-lib/aws-certificatemanager';
import * as route53 from 'aws-cdk-lib/aws-route53';
import * as targets from 'aws-cdk-lib/aws-route53-targets';
import * as logs from 'aws-cdk-lib/aws-logs';
import * as ecr from 'aws-cdk-lib/aws-ecr';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as secretsmanager from 'aws-cdk-lib/aws-secretsmanager';

function createAliasRecord(
  scope: cdk.Stack,
  id: string,
  domain: string,
  zone: route53.IHostedZone,
  target: route53.RecordTarget
): void {
  const recordName =
    domain === zone.zoneName ? undefined : domain.replace(`.${zone.zoneName}`, '');

  new route53.ARecord(scope, id, {
    zone,
    recordName,
    target,
  });
}

export class MyfitInfraStack extends cdk.Stack {
  constructor(scope: cdk.App, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const domainName: string = this.node.tryGetContext('domainName') || 'myfit.click';
    const hostedZoneId: string | undefined = this.node.tryGetContext('hostedZoneId');
    const hostedZoneName: string = this.node.tryGetContext('hostedZoneName') || domainName;

    const backendDomain = `api.${domainName}`;
    const frontendDomain = domainName;
    const appBaseUrl = `https://${frontendDomain}`;
    const mediaBucketName: string = this.node.tryGetContext('appS3BucketName') || 'crawl.fitness';
    const cognitoUserPoolId: string = this.node.tryGetContext('existingUserPoolId') || 'us-east-1_9AoKPqZO1';
    const bedrockApiKeySecretArn: string | undefined = this.node.tryGetContext('bedrockApiKeySecretArn');

    const hostedZone: route53.IHostedZone = hostedZoneId
      ? route53.HostedZone.fromHostedZoneAttributes(this, 'HostedZone', {
          hostedZoneId,
          zoneName: hostedZoneName,
        })
      : new route53.PublicHostedZone(this, 'HostedZone', {
          zoneName: hostedZoneName,
        });

    const publicHostedZone = hostedZone instanceof route53.PublicHostedZone ? hostedZone : undefined;

    const certificate = new acm.Certificate(this, 'Certificate', {
      domainName: frontendDomain,
      subjectAlternativeNames: [backendDomain],
      validation: acm.CertificateValidation.fromDns(hostedZone),
    });

    // VPC
    const vpc = new ec2.Vpc(this, 'VPC', {
      maxAzs: 2,
      natGateways: 0,
      subnetConfiguration: [
        {
          name: 'public',
          subnetType: ec2.SubnetType.PUBLIC,
        },
        {
          name: 'private-isolated',
          subnetType: ec2.SubnetType.PRIVATE_ISOLATED,
        },
      ],
    });

    // RDS PostgreSQL
    const dbSecurityGroup = new ec2.SecurityGroup(this, 'DBSecurityGroup', {
      vpc,
      description: 'Security group for RDS PostgreSQL',
    });

    const db = new rds.DatabaseInstance(this, 'Database', {
      engine: rds.DatabaseInstanceEngine.postgres({ version: rds.PostgresEngineVersion.VER_15 }),
      vpc,
      vpcSubnets: { subnetType: ec2.SubnetType.PRIVATE_ISOLATED },
      databaseName: 'myfit',
      credentials: rds.Credentials.fromGeneratedSecret('postgres'),
      instanceType: ec2.InstanceType.of(ec2.InstanceClass.T4G, ec2.InstanceSize.MICRO),
      allocatedStorage: 20,
      maxAllocatedStorage: 50,
      storageType: rds.StorageType.GP3,
      securityGroups: [dbSecurityGroup],
      multiAz: true,
      backupRetention: cdk.Duration.days(7),
      removalPolicy: cdk.RemovalPolicy.SNAPSHOT,
      cloudwatchLogsExports: ['postgresql'],
      cloudwatchLogsRetention: logs.RetentionDays.ONE_WEEK,
      publiclyAccessible: false,
    });

    // ECR Repository (import existing to avoid name collision on redeploy)
    const backendRepoName = this.node.tryGetContext('backendRepoName') || 'myfit-backend';
    const backendRepo = ecr.Repository.fromRepositoryName(this, 'BackendRepo', backendRepoName);

    const taskSecrets: Record<string, ecs.Secret> = {
      DB_USERNAME: ecs.Secret.fromSecretsManager(db.secret!, 'username'),
      DB_PASSWORD: ecs.Secret.fromSecretsManager(db.secret!, 'password'),
    };
    let bedrockApiKeySecret: secretsmanager.ISecret | undefined;

    if (bedrockApiKeySecretArn) {
      bedrockApiKeySecret = secretsmanager.Secret.fromSecretCompleteArn(
        this,
        'BedrockApiKeySecret',
        bedrockApiKeySecretArn
      );
      taskSecrets.BEDROCK_API_KEY = ecs.Secret.fromSecretsManager(bedrockApiKeySecret);
    }

    // ECS Cluster
    const cluster = new ecs.Cluster(this, 'Cluster', {
      vpc,
      containerInsights: true,
    });

    // IAM Roles - explicit least-privilege per architecture guide
    const taskExecutionRole = new iam.Role(this, 'TaskExecutionRole', {
      assumedBy: new iam.ServicePrincipal('ecs-tasks.amazonaws.com'),
      managedPolicies: [
        iam.ManagedPolicy.fromAwsManagedPolicyName('service-role/AmazonECSTaskExecutionRolePolicy'),
      ],
    });

    const taskRole = new iam.Role(this, 'TaskRole', {
      assumedBy: new iam.ServicePrincipal('ecs-tasks.amazonaws.com'),
    });

    // Backend Service
    const backendServiceProps: ecsPatterns.ApplicationLoadBalancedFargateServiceProps = {
      cluster,
      cpu: 256,
      memoryLimitMiB: 512,
      desiredCount: 2,
      healthCheckGracePeriod: cdk.Duration.seconds(180),
      taskSubnets: { subnetType: ec2.SubnetType.PUBLIC },
      assignPublicIp: true,
      taskImageOptions: {
        image: ecs.ContainerImage.fromEcrRepository(backendRepo, 'latest'),
        containerPort: 8080,
        executionRole: taskExecutionRole,
        taskRole: taskRole,
        environment: {
          DB_URL: `jdbc:postgresql://${db.dbInstanceEndpointAddress}:5432/myfit?ssl=true&sslmode=require`,
          SPRING_PROFILES_ACTIVE: 'prod',
          CORS_ALLOWED_ORIGINS: [
            appBaseUrl,
            'https://*.cloudfront.net',
            'http://localhost:8081',
            'http://localhost:19006',
          ]
            .join(','),
          AWS_REGION: cdk.Stack.of(this).region,
          S3_BUCKET_NAME: mediaBucketName,
          COGNITO_USER_POOL_ID: cognitoUserPoolId,
          COGNITO_ISSUER_URI: `https://cognito-idp.us-east-1.amazonaws.com/${cognitoUserPoolId}`,
        },
        secrets: taskSecrets,
        logDriver: ecs.LogDrivers.awsLogs({
          streamPrefix: 'backend',
          logRetention: logs.RetentionDays.ONE_WEEK,
        }),
      },
      openListener: false, // Prevent CDK adding 0.0.0.0/0; we restrict to CloudFront below
    };

    const backend = new ecsPatterns.ApplicationLoadBalancedFargateService(this, 'Backend', backendServiceProps);

    // ECS agent resolves secrets at task startup, so execution role needs secret read.
    db.secret!.grantRead(taskExecutionRole);
    if (bedrockApiKeySecret) {
      bedrockApiKeySecret.grantRead(taskExecutionRole);
    }

    // Restrict ALB to accept traffic from CloudFront IPs only (managed prefix list, auto-updated by AWS)
    backend.loadBalancer.connections.allowFrom(
      ec2.Peer.prefixList('pl-3b927c52'),
      ec2.Port.tcp(80),
      'Allow inbound from CloudFront only'
    );

    dbSecurityGroup.addIngressRule(backend.service.connections.securityGroups[0], ec2.Port.tcp(5432));

    backend.targetGroup.configureHealthCheck({
      path: '/test/health',
      interval: cdk.Duration.seconds(30),
      healthyHttpCodes: '200-399',
    });

    // ECS Auto-scaling per architecture guide (2..10 tasks)
    const scaling = backend.service.autoScaleTaskCount({ minCapacity: 2, maxCapacity: 4 });
    scaling.scaleOnCpuUtilization('CpuScaling', {
      targetUtilizationPercent: 70,
      scaleInCooldown: cdk.Duration.seconds(60),
      scaleOutCooldown: cdk.Duration.seconds(60),
    });

    // S3 + CloudFront
    const frontendBucket = new s3.Bucket(this, 'FrontendBucket', {
      removalPolicy: cdk.RemovalPolicy.RETAIN,
      versioned: true,
    });

    const oai = new cloudfront.OriginAccessIdentity(this, 'OAI');
    frontendBucket.grantRead(oai);
    const mediaBucket = s3.Bucket.fromBucketName(this, 'MediaBucket', mediaBucketName);
    // Existing permanent media bucket access for backend read/write operations.
    mediaBucket.grantReadWrite(taskRole);

    const spaRewriteFunction = new cloudfront.Function(this, 'SpaRewriteFunction', {
      code: cloudfront.FunctionCode.fromInline(`
function handler(event) {
  var request = event.request;
  var uri = request.uri;

  if (uri === '/' || uri.endsWith('.html') || uri.includes('.')) {
    return request;
  }

  request.uri = '/index.html';
  return request;
}
`),
    });

    // Single shared ALB origin - all API path behaviors reuse this one origin,
    // so CloudFront creates only one origin pool instead of three.
    const albOrigin = new origins.HttpOrigin(backend.loadBalancer.loadBalancerDnsName, {
      protocolPolicy: cloudfront.OriginProtocolPolicy.HTTP_ONLY,
    });

    const backendBehavior: cloudfront.AddBehaviorOptions = {
      viewerProtocolPolicy: cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
      allowedMethods: cloudfront.AllowedMethods.ALLOW_ALL,
      cachePolicy: cloudfront.CachePolicy.CACHING_DISABLED,
      originRequestPolicy: cloudfront.OriginRequestPolicy.ALL_VIEWER,
    };

    const distributionProps: cloudfront.DistributionProps = {
      defaultBehavior: {
        origin: new origins.S3Origin(frontendBucket, { originAccessIdentity: oai }),
        viewerProtocolPolicy: cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
        functionAssociations: [
          {
            eventType: cloudfront.FunctionEventType.VIEWER_REQUEST,
            function: spaRewriteFunction,
          },
        ],
      },
      additionalBehaviors: {
        '/api/*':  { origin: albOrigin, ...backendBehavior },
        '/auth/*': { origin: albOrigin, ...backendBehavior },
        '/user/*': { origin: albOrigin, ...backendBehavior },
        '/test/*': { origin: albOrigin, ...backendBehavior },
      },
      defaultRootObject: 'index.html',
      domainNames: [frontendDomain],
      certificate,
    };

    const distribution = new cloudfront.Distribution(this, 'Distribution', distributionProps);

    createAliasRecord(
      this,
      'FrontendAliasRecord',
      frontendDomain,
      hostedZone,
      route53.RecordTarget.fromAlias(new targets.CloudFrontTarget(distribution))
    );

    createAliasRecord(
      this,
      'BackendAliasRecord',
      backendDomain,
      hostedZone,
      route53.RecordTarget.fromAlias(new targets.LoadBalancerTarget(backend.loadBalancer))
    );

    // Cognito (reuse existing pool/client to avoid creating retained orphan pools)
    const cognitoWebClientId: string = this.node.tryGetContext('existingWebClientId') || '661fm3mj7s5qcmoldri1mem9sr';

    // Outputs
    new cdk.CfnOutput(this, 'BackendEcrRepositoryUri', { value: backendRepo.repositoryUri });
    new cdk.CfnOutput(this, 'BackendLoadBalancerDnsName', { value: backend.loadBalancer.loadBalancerDnsName });
    new cdk.CfnOutput(this, 'FrontendBucketName', { value: frontendBucket.bucketName });
    new cdk.CfnOutput(this, 'MediaBucketName', { value: mediaBucketName });
    new cdk.CfnOutput(this, 'CloudFrontDomainName', { value: distribution.distributionDomainName });
    new cdk.CfnOutput(this, 'CloudFrontDistributionId', { value: distribution.distributionId });
    new cdk.CfnOutput(this, 'FrontendBaseUrl', { value: appBaseUrl });
    new cdk.CfnOutput(this, 'BackendApiBaseUrl', { value: appBaseUrl });
    new cdk.CfnOutput(this, 'CertificateArn', { value: certificate.certificateArn });
    new cdk.CfnOutput(this, 'HostedZoneId', { value: hostedZone.hostedZoneId });
    new cdk.CfnOutput(this, 'HostedZoneName', { value: hostedZone.zoneName });
    if (publicHostedZone?.hostedZoneNameServers) {
      new cdk.CfnOutput(this, 'HostedZoneNameServers', {
        value: cdk.Fn.join(',', publicHostedZone.hostedZoneNameServers),
      });
    }
    new cdk.CfnOutput(this, 'CognitoUserPoolId', { value: cognitoUserPoolId });
    new cdk.CfnOutput(this, 'CognitoWebClientId', { value: cognitoWebClientId });
    new cdk.CfnOutput(this, 'DatabaseSecretArn', { value: db.secret!.secretArn });
    new cdk.CfnOutput(this, 'DatabaseEndpointAddress', { value: db.dbInstanceEndpointAddress });
    new cdk.CfnOutput(this, 'EcsClusterName', { value: cluster.clusterName });
    new cdk.CfnOutput(this, 'EcsServiceName', { value: backend.service.serviceName });
  }
}
```

### 2.2 Deploy script (`myfit-infra/scripts/deploy-infra.ps1`)

This script installs dependencies, builds the CDK app, bootstraps, synthesizes, and deploys the stack.

Key excerpt:

```powershell
param(
  [string]$Region = "us-east-1",
  [string]$StackName = "MyfitInfraStack",
  [string]$DomainName = "",
  [string]$HostedZoneId = "",
  [string]$HostedZoneName = "myfit.click",
  [string]$CertificateArn = "",
  [switch]$RunCleanup,
  [switch]$ConfirmCleanupDelete
)

$ErrorActionPreference = "Stop"

# Single source of truth for Bedrock API key secret used by ECS task definition.
$BedrockApiKeySecretArn = "arn:aws:secretsmanager:us-east-1:294568841239:secret:myfit/bedrock-api-key-cJiujb"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoDir = Split-Path -Parent $scriptDir
Set-Location $repoDir

if ($RunCleanup) {
  $cleanupArgs = @("-Region", $Region)
  if ($ConfirmCleanupDelete) {
    $cleanupArgs += "-ConfirmDelete"
  }

  & "$scriptDir\cleanup-failed-cloudformation.ps1" @cleanupArgs
}

Write-Host "Installing dependencies..." -ForegroundColor Cyan
npm ci

Write-Host "Building CDK app..." -ForegroundColor Cyan
npm run build

Write-Host "Bootstrapping CDK environment..." -ForegroundColor Cyan
npx cdk bootstrap --region $Region

$contextArgs = @()
if ($DomainName) { $contextArgs += @("-c", "domainName=$DomainName") }
if ($HostedZoneId) { $contextArgs += @("-c", "hostedZoneId=$HostedZoneId") }
if ($HostedZoneName) { $contextArgs += @("-c", "hostedZoneName=$HostedZoneName") }
if ($CertificateArn) { $contextArgs += @("-c", "certificateArn=$CertificateArn") }
if ($BedrockApiKeySecretArn) { $contextArgs += @("-c", "bedrockApiKeySecretArn=$BedrockApiKeySecretArn") }

Write-Host "Synthesizing stack..." -ForegroundColor Cyan
npx cdk synth $StackName --region $Region @contextArgs

Write-Host "Deploying stack $StackName..." -ForegroundColor Cyan
npx cdk deploy $StackName --region $Region --require-approval never @contextArgs

Write-Host "Infra deployment completed." -ForegroundColor Green
```

## 3. Run deployment script

From myfit-infra root folder, run:

```powershell
./scripts/deploy-infra.ps1 \
  -Region us-east-1 \
  -StackName MyfitInfraStack \
  -DomainName myfit.click \
  -HostedZoneName myfit.click
```

Optional parameters:

```powershell
./scripts/deploy-infra.ps1 \
  -Region us-east-1 \
  -StackName MyfitInfraStack \
  -DomainName <your-domain> \
  -HostedZoneId <your-hosted-zone-id> \
  -HostedZoneName <your-hosted-zone-name> \
  -CertificateArn arn:aws:acm:us-east-1:<account-id>:certificate/<certificate-id>
```

## 4. What the script does

1. Install dependencies using npm ci.
2. Build CDK application.
3. Bootstrap CDK environment.
4. Synthesize CloudFormation template.
5. Deploy CloudFormation stack with cdk deploy.
6. Pass context values such as domain, hosted zone, certificate, and Bedrock secret.

## 5. Validate deployment

1. Confirm CloudFormation stack status is CREATE_COMPLETE or UPDATE_COMPLETE.
2. Confirm outputs exist for:
   - CloudFront domain
   - ALB DNS name
   - ECS cluster/service
   - Database endpoint and secret ARN
3. Confirm frontend and API routes are reachable from browser.

## 6. Troubleshooting quick checks

1. If deploy fails due to rollback, clear failed stack states in CloudFormation and redeploy.
2. If certificate errors appear, verify certificate region is us-east-1 for CloudFront.
3. If DNS alias fails, verify hosted zone and domain context values.
4. If ECS task fails at startup, verify secret permissions and secret ARN format.
