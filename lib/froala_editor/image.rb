module FroalaEditor
  # Image functionality.
  class Image

    # Default options that are used if no options are passed to the upload function
    @@default_options = {
        fieldname: 'file',
        validation: {
            allowedExts: [".gif", ".jpeg", ".jpg", ".png", ".svg", ".blob"],
            allowedMimeTypes: [ "image/gif", "image/jpeg", "image/pjpeg", "image/x-png", "image/png", "image/svg+xml" ]
        },
        resize: nil
    }

    # Uploads an image to the server.
    # Params:
    # +params+:: File upload parameter mostly is "file".
    # +upload_path+:: Server upload path, a storage path where the image will be stored.
    # +options+:: Hash object that contains configuration parameters for uploading a image.
    # Returns json object
    def self.upload(params, upload_path = "public/uploads/images", options = nil)

      if options == nil
        options = @@default_options
      else
        options = @@default_options.merge(options)
      end

      file = params[options[:fieldname]]


      if file
        # Validates the image extension and mime type.
        validation = ImageValidation.check(file, options)
        # Uses the Utlis name function to generate a random name for the image.
        file_name = Utils.name(file)
        path = Rails.root.join(upload_path, file_name)
        # Saves the image on the server and returns the path.
        serve_url = save(file, path)
        # Check the option param, if resize is not needed it will use default options constant.
        if !options[:resize].nil?
          resize = image_resize(options, path)

          return {:link => serve_url}.to_json
        else
          return {:link => serve_url}.to_json
        end

      end
    end

    # Saves an image on the server.
    # Params:
    # +file+:: The uploaded image that will be saved on the server.
    # +path+:: The path where the image will be saved.
    def self.save(file, path)
      if ::File.open(path, "wb") {|f| f.write(file.read)}
        # Returns a public accessible server path.
        return "#{"/uploads/"}#{Utils.get_file_name(path)}"
      else
        return "error"
      end
    end

    # Resizes an image based on the options provided.
    # The function resizes the original file,
    # Params:
    # +options+:: The options that contain the resize hash
    # +path+:: The path where the image is stored
    def self.image_resize(options, path)

      image = MiniMagick::Image.new(path)
      image.path
      image.resize("#{options[:resize][:height]}x#{options[:resize][:width]}")
    end

    # Deletes an image found on the server.
    # Params:
    # +file+:: The image that will be deleted from the server.
    # +path+:: The server path where the image resides.
    # Returns true or false.
    def self.delete(file = params[:file], path)

      file_path = Rails.root.join(path, ::File.basename(file))

      if ::File.delete(file_path)
        return true
      else
        return false
      end
    end

    # Loads the images from a specific path
    # Params:
    # +path+:: The server path where the images are saved
    # Returns Json object
    def self.load_images(path)

      images = Dir["#{path}*"]
      all_images = []

      images.each do |img|
        all_images.push({url: "#{"/uploads/"}#{Utils.get_file_name(img)}"})
      end

      return all_images.to_json
    end
  end
end