Paperclip.interpolates :tenant do |attachment, style|
  Apartment::Tenant.current
end

Paperclip::Attachment.default_options[:path] = ':class/:attachment/:tenant/:id_partition/:style/:filename'

Rails.logger.warn "NOTE rails env is: #{Rails.env}"
Rails.logger.warn "#{Rails.env.inspect}"

if ['production', 'staging', 'public'].include?(Rails.env)
  Paperclip::Attachment.default_options[:storage] = :s3
  Paperclip::Attachment.default_options[:s3_credentials] = {
    :bucket => ENV['S3_BUCKET_NAME'],
    :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  }
end
