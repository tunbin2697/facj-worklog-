---
title: "Phase 7 - Bedrock API and Model Configuration"
date: 2026-04-03
weight: 7
chapter: false
pre: " <b> 5.3.7. </b> "
---

## 1. Generate long-term Bedrock API key

- Open `Amazon Bedrock` in region `us-west-2` (Oregon).
- In left navigation, open `API keys`.
- In tab `Long-term API keys`, click `Generate long-term API keys`.
![Navigate to Bedrock API key screen](/images/workshop/Phase%207%20-%20bedrock/1_Navigate_to_Generate_Api_key.jpg)

- In `Generate long-term API key`, set key name.
- Set key expiry days in `Specify API key expiry in days`.
- Click `Generate`.
- Copy the generated key immediately (value is shown once).
![Configure and generate API key](/images/workshop/Phase%207%20-%20bedrock/2_configure_and_Generate_Api_key.jpg)

## 2. Select model and copy model ID

- Open `Model catalog`.
- Select `Claude 3.5 Haiku` from Anthropic.
![Select Bedrock model from catalog](/images/workshop/Phase%207%20-%20bedrock/3_Select_Model_From_Catalog.jpg)

- Open model details and copy `Model ID`.
- Use model ID `anthropic.claude-3-5-haiku-20241022-v1:0`.
![Copy model ID](/images/workshop/Phase%207%20-%20bedrock/4_Copy_Model_ID.jpg)

## 3. Configure backend Bedrock settings

- Store API key in Secrets Manager secret `myfit/bedrock-api-key`.
- Ensure ECS task definition secret mapping contains `BEDROCK_API_KEY`.
- Set Bedrock app configuration values:

```dotenv
BEDROCK_MODEL=anthropic.claude-3-5-haiku-20241022-v1:0
BEDROCK_REGION=us-west-2
BEDROCK_TEMPERATURE=0.7
BEDROCK_MAX_TOKENS=1024
```

- Redeploy ECS service after updating secret or environment settings.
![Set up Bedrock variables in backend](/images/workshop/Phase%207%20-%20bedrock/5_Set_up_Bedrock.jpg)

## 4. Validate Bedrock wiring with AWS CLI

```bash
aws bedrock list-foundation-models \
  --region us-west-2 \
  --by-provider anthropic \
  --query "modelSummaries[?contains(modelId, 'claude-3-5-haiku')].[modelId,providerName,modelLifecycle.status]" \
  --output json

aws secretsmanager describe-secret \
  --secret-id arn:aws:secretsmanager:us-east-1:294568841239:secret:myfit/bedrock-api-key-cJiujb \
  --region us-east-1

aws ecs describe-task-definition \
  --task-definition MyfitInfraStackBackendTaskDef528F590D \
  --region us-east-1 \
  --query "taskDefinition.containerDefinitions[?name=='web'].secrets[?name=='BEDROCK_API_KEY']" \
  --output json
```

## 5. Phase completion checklist

1. Confirm Bedrock API key is generated in `Long-term API keys`.
2. Confirm Bedrock model ID is `anthropic.claude-3-5-haiku-20241022-v1:0`.
3. Confirm `BEDROCK_API_KEY` is stored in Secrets Manager.
4. Confirm secret ARN is `arn:aws:secretsmanager:us-east-1:294568841239:secret:myfit/bedrock-api-key-cJiujb`.
5. Confirm ECS task definition maps `BEDROCK_API_KEY` from secret.
6. Confirm backend Bedrock settings include `BEDROCK_MODEL`, `BEDROCK_REGION`, `BEDROCK_TEMPERATURE`, and `BEDROCK_MAX_TOKENS`.
7. Confirm Bedrock model lookup command returns `anthropic.claude-3-5-haiku-20241022-v1:0`.
