require 'aws-sdk-core'

Aws.config.update(
  region: 'can-central-1',
  credentials: Aws::Credentials.new(Rails.application.credentials.dig(:aws, :access_key_id), Rails.application.credentials.dig(:aws, :secret_access_key))
)