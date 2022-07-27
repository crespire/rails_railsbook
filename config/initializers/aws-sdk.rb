# config/initializers/aws-sdk.rb

Aws.config.update(
  credentials: Aws::Credentials.new('access-key-id', 'secret-access-key'),
  region: 'ca-central-1'
)