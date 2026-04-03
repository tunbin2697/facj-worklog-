---
title: "2.7 Cognito and Secrets Manager"
weight: 27
---

# 2.7 Cognito and Secrets Manager

The stack reuses an existing Cognito user pool and client, and optionally injects a Bedrock API key from Secrets Manager.

## Content

1. Confirm Cognito values
2. Confirm or create the Bedrock secret
3. Map the values back to the stack
4. What the application receives

## 2.7.1 Confirm Cognito values

1. Open the Cognito console.
2. Find the existing user pool.
3. Copy the user pool ID.
4. Open the app client and copy the web client ID.
5. Confirm that the callback and logout URLs match the frontend domain.
6. Use descriptive notes for the pool and client so the console search is easier during the workshop.

## 2.7.2 Confirm or create the Bedrock secret

1. Open the Secrets Manager console.
2. Create or select the secret used for the Bedrock API key.
3. Store the key as a single secret value.
4. Copy the secret ARN.
5. Add a description such as `MyFit Bedrock API key`.

## 2.7.3 Map the values back to the stack

- `existingUserPoolId` maps to the Cognito user pool ID.
- `existingWebClientId` maps to the web client ID.
- `bedrockApiKeySecretArn` maps to the optional Bedrock secret ARN.

## 2.7.4 What the application receives

- `COGNITO_USER_POOL_ID`
- `COGNITO_ISSUER_URI`
- `BEDROCK_API_KEY` when the secret ARN is provided
