require 'aws-sdk-core'

Aws.config.update(
  region: 'can-central-1',
  credentials: Aws::Credentials.new(ENV['AWS_ID'], ENV['AWS_SECRET'])
)