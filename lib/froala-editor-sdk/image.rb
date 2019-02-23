module FroalaEditorSDK
  # Image functionality.
  class Image < File

    # Default options that are used if no options are passed to the upload function.
    @default_options = {
        fieldname: 'file',
        validation: {
            allowedExts: [".gif", ".jpeg", ".jpg", ".png", ".svg", ".blob"],
            allowedMimeTypes: [ "image/gif", "image/jpeg", "image/pjpeg", "image/x-png", "image/png", "image/svg+xml" ]
        },
        resize: nil,
        file_upload_path: 'public/uploads/images',
        file_access_path: '/uploads/'
    }

    # Loads the images from a specific path
    # Params:
    # +path+:: The server path where the images are saved
    # Returns Json object
    def self.load_images(options = {})

      # Merge options.
      options = @default_options.merge(options)

      images = Dir["#{options[:file_upload_path]}*"]
      all_images = []

      images.each do |img|
        all_images.push({url: "#{options[:file_access_path]}#{Utils.get_file_name(img)}"})
      end

      return all_images.to_json
    end
  end
end