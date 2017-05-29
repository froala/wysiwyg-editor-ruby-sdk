module FroalaEditor

  # Video functionality.
  class Video < File

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
      super
    end
  end
end