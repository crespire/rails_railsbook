# config/initializers/aws-sdk.rb

S3Client = Aws::S3::Client.new(
  access_key_id: 'ACCESS_KEY_ID',
  secret_access_key: 'SECRET_ACCESS_KEY',
  region: 'ca-central-1'
)