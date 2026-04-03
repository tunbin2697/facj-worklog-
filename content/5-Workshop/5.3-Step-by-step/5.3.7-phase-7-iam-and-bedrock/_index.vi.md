---
title: "Phase 7 - Bedrock API và Model Configuration"
date: 2026-04-03
weight: 7
chapter: false
pre: " <b> 5.3.7. </b> "
---

## 1. Tạo long-term Bedrock API key

- Mở `Amazon Bedrock` tại region `us-west-2` (Oregon).
- Trong menu trái, mở `API keys`.
- Tại tab `Long-term API keys`, bấm `Generate long-term API keys`.
![Navigate to Bedrock API key screen](/images/workshop/Phase%207%20-%20bedrock/1_Navigate_to_Generate_Api_key.jpg)

- Trong màn hình `Generate long-term API key`, đặt key name.
- Đặt số ngày hết hạn tại `Specify API key expiry in days`.
- Bấm `Generate`.
- Sao chép key ngay sau khi tạo (value chỉ hiển thị một lần).
![Configure and generate API key](/images/workshop/Phase%207%20-%20bedrock/2_configure_and_Generate_Api_key.jpg)

## 2. Chọn model và sao chép model ID

- Mở `Model catalog`.
- Chọn `Claude 3.5 Haiku` của Anthropic.
![Select Bedrock model from catalog](/images/workshop/Phase%207%20-%20bedrock/3_Select_Model_From_Catalog.jpg)

- Mở chi tiết model và sao chép `Model ID`.
- Dùng model ID `anthropic.claude-3-5-haiku-20241022-v1:0`.
![Copy model ID](/images/workshop/Phase%207%20-%20bedrock/4_Copy_Model_ID.jpg)

## 3. Cấu hình backend cho Bedrock

- Lưu API key vào Secrets Manager secret `myfit/bedrock-api-key`.
- Đảm bảo ECS task definition có secret mapping `BEDROCK_API_KEY`.
- Đặt các biến cấu hình Bedrock trong backend:

```dotenv
BEDROCK_MODEL=anthropic.claude-3-5-haiku-20241022-v1:0
BEDROCK_REGION=us-west-2
BEDROCK_TEMPERATURE=0.7
BEDROCK_MAX_TOKENS=1024
```

- Deploy lại ECS service sau khi cập nhật secret hoặc environment.
![Set up Bedrock variables in backend](/images/workshop/Phase%207%20-%20bedrock/5_Set_up_Bedrock.jpg)

## 4. Validate Bedrock wiring bằng AWS CLI

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

## 5. Checklist hoàn tất phase

1. Xác nhận Bedrock API key được tạo trong `Long-term API keys`.
2. Xác nhận Bedrock model ID là `anthropic.claude-3-5-haiku-20241022-v1:0`.
3. Xác nhận `BEDROCK_API_KEY` được lưu trong Secrets Manager.
4. Xác nhận secret ARN đúng định dạng `arn:aws:secretsmanager:us-east-1:<account-id>:secret:myfit/bedrock-api-key-***`.
5. Xác nhận ECS task definition map `BEDROCK_API_KEY` từ secret.
6. Xác nhận backend có đầy đủ `BEDROCK_MODEL`, `BEDROCK_REGION`, `BEDROCK_TEMPERATURE`, và `BEDROCK_MAX_TOKENS`.
7. Xác nhận lệnh model lookup trả về `anthropic.claude-3-5-haiku-20241022-v1:0`.
