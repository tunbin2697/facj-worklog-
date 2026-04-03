---
title: "2.5 S3 and CloudFront"
weight: 25
---

# 2.5 S3 and CloudFront

The stack uses one S3 bucket for the frontend bundle and one CloudFront distribution for the public site and API routing.

## Content

1. Create the frontend bucket
2. Create the CloudFront distribution
3. Add SPA rewrite behavior
4. Add API path behaviors
5. Validate frontend delivery

## 2.5.1 Create the frontend bucket

1. Open the S3 console.
2. Create a bucket for the frontend build output.
3. The live stack bucket is `myfitinfrastack-frontendbucketefe2e19c-qjcbf75eyxbx`.
4. If you create a manual equivalent, use a descriptive name and a bucket description in your notes because S3 itself does not store a description field.
5. Keep versioning enabled.
6. Keep Block Public Access turned on.
7. Keep ACLs disabled.
8. Enable default encryption.
9. Create the bucket.

## 2.5.2 Create the CloudFront distribution

1. Open the CloudFront console.
2. Choose Create distribution.
3. Set the default origin to the frontend S3 bucket.
4. Use an origin access identity for S3 access.
5. Set the viewer protocol policy to redirect HTTP to HTTPS.
6. Set the default root object to `index.html`.
7. Add a description in your deployment notes so the distribution is easy to distinguish from any test distributions.

## 2.5.3 Add SPA rewrite behavior

Create a CloudFront Function for viewer requests with the following logic:

```javascript
function handler(event) {
  var request = event.request;
  var uri = request.uri;

  if (uri === '/' || uri.endsWith('.html') || uri.includes('.')) {
    return request;
  }

  request.uri = '/index.html';
  return request;
}
```

## 2.5.4 Add API path behaviors

Add additional behaviors for the ALB origin:

- `/api/*`
- `/auth/*`
- `/user/*`
- `/test/*`

Use these settings for the API behaviors:

- Allowed methods: all
- Cache policy: disabled
- Origin request policy: all viewer
- Protocol policy: HTTP only

## 2.5.5 Validate frontend delivery

1. Upload the built web assets to the bucket.
2. Invalidate the CloudFront distribution after each frontend deploy.
3. Open the site in a browser and confirm the app loads from the CloudFront domain.
4. Confirm `/index.html` and SPA routes resolve correctly.
