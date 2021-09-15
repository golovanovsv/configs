# aws s3

## https://docs.aws.amazon.com/cli/latest/reference/s3/cp.html
aws s3 cp
  --acl [private|public-read|public-read-write|authenticated-read|aws-exec-read|bucket-owner-read|bucket-owner-full-control]
  --content-type "application/javascript;charset=utf-8"
  --metadata-directive [COPY|REPLACE]
  # Metadata переданная таким способом перекладывается в заголовок x-amz-meta-content-type
  --metadata '{"Content-Type":"application/javascript;charset=utf-8"}'
