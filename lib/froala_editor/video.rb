module FroalaEditor

  # Video functionality.
  class Video

    # Default options that are used if no options are passed to the upload function
    @@default_options = {
        fieldname: 'file',
        validation: {
            allowedExts: [".mp4", ".webm", ".ogg"],
            allowedMimeTypes: [ "video/mp4", "video/webm", "video/ogg" ]
        },
        resize: nil
    }

    # Uploads a video to the server.
    # Params:
    # +params+:: File upload parameter mostly is "file".
    # +upload_path+:: Server upload path, a storage path where the video will be stored.
    # +options+:: Hash object that contains configuration parameters for uploading a video.
    # Returns json object
    def self.upload(params, upload_path = "public/uploads/videos", options = nil)

      if options == nil
        options = @@default_options
      else
        options = @@default_options.merge(options)
      end
      file = params[options[:fieldname]]

      if file

        # Validates the video extension and mime type.
        validation = VideoValidation.check(file, options)

        # Uses the Utlis name function to generate a random name for the video.
        file_name = Utils.name(file)
        path = Rails.root.join(upload_path, file_name)

        # Saves the video on the server and returns the path.
        serve_url = save(file, path)

        return {:link => serve_url}.to_json
      end

    end

    # Saves a video on the server.
    # Params:
    # +file+:: The uploaded video that will be saved on the server.
    # +path+:: The path where the video will be saved.
    def self.save(file, path)
      if ::File.open(path, "wb") {|f| f.write(file.read)}
        # Returns a public accessible server path.
        return "#{"/uploads/"}#{Utils.get_file_name(path)}"
      else
        return "error"
      end
    end

  end
end