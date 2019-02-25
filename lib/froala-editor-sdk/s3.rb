module FroalaEditorSDK

  # Uploads files to S3/AWS
  class S3

    # Builds a signature based on  the options.
    # Params:
    # +options+:: The configuration params that are needed to compute the signature.
    def self.signature (options = nil)
      OpenSSL::HMAC.hexdigest(
        "SHA256",
        self.sign(
          self.sign(
            self.sign(
              self.sign(
                ("AWS4" + options[:secretKey]).force_encoding(Encoding::UTF_8),
                options[:'date-string']
              ),
              options[:region]
            ),
            "s3"
          ),
          "aws4_request"
        ), 
        self.policy(options)
      )
    end

    # Builds a HMAC-SHA256 digest using key and data
    # Params:
    # +key+:: Key to use for creating the digest
    # +data+:: Data to be used for creating the digest
    def self.sign(key, data)
      OpenSSL::HMAC.digest(OpenSSL::Digest::SHA256.new, key, data.force_encoding(Encoding::UTF_8))
    end

    # Encodes to Base64 the policy data and replaces new lines chars.
    # Params:
    # +options+:: The configuration params that are needed to compute the signature.
    def self.policy (options = nil)
      Base64.encode64(self.policy_data(options).to_json).gsub("\n", "")
    end

    # Sets policy params, bucket that will be used max file size and other params.
    # Params:
    # +options+:: Configuration params that are needed to set the policy
    def self.policy_data (options = nil)
      {
          expiration: 10.hours.from_now.utc.iso8601,
          conditions: [
              ["starts-with", "$key", options[:keyStart]],       # Start key/folder
              ["starts-with", "$Content-type", ""],         # Content type
              {"x-requested-with": "xhr"},                  # Request type
              {"x-amz-algorithm": options[:'x-amz-algorithm']}, # Encrytion Algorithm
              {"x-amz-date": options[:'x-amz-date']},       # Current Date
              {"x-amz-credential": options[:'x-amz-credential']}, # Encrypted Credentials
              {bucket: options[:bucket]},                   # Bucket name
              {acl: options[:acl]},                         # ACL property
              {success_action_status: "201"}                # Response status 201 'file created'
          ]
      }
    end

    # Builds the amazon credential by appending access key, x-amz-date, region and 's3/aws4_request'
    # Params:
    # +options+:: Configuration params to generate the AWS response
    def self.getXamzCredential(options = nil)
      "#{options[:accessKey]}#{"/"}#{options[:'date-string']}#{"/"}#{options[:region]}#{"/"}#{"s3/aws4_request"}"
    end

    # Makes all the request in order and returns AWS hash response
    # Params:
    # +options+:: Configuration params to generate the AWS response.
    def self.data_hash (options = nil)
      options[:region] = 'us-east-1' if options[:region].nil? ||  options[:region] == 's3'
      options[:'date-string'] = Time.now.strftime("%Y%m%d")
      options[:'x-amz-algorithm'] = "AWS4-HMAC-SHA256"
      options[:'x-amz-credential'] = self.getXamzCredential(options)
      options[:'x-amz-date'] = options[:'date-string'] + "T000000Z"

      {
        :bucket => options[:bucket],           # Upload bucket
        :region =>  options[:region] != 'us-east-1' ? "s3-#{options[:region]}" : 's3', # Upload region
        :keyStart => options[:keyStart],       # Start key/folder
        :params => {
          :acl => options[:acl],                 # ACL property 'public-read'
          :policy => self.policy(options),       # Defined policy
          :'x-amz-algorithm' => options[:'x-amz-algorithm'], # Encrytion Algorithm
          :'x-amz-credential' => options[:'x-amz-credential'],     # Encrypted Credentials
          :'x-amz-date' => options[:'x-amz-date'],  # Current Date
          :'x-amz-signature' => self.signature(options), # Defined signature
        }
      }
    end
  end
end