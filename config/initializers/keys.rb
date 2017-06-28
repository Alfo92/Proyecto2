KEYS = YAML.load_file("#{Rails.root}/config/keys.yml").with_indifferent_access

def storage_s3_credentials
  {:region => 's3-sa-east-1',:bucket => "miterra", :access_key_id => KEYS[:amazon][:key], :secret_access_key => KEYS[:amazon][:secret]}
end
