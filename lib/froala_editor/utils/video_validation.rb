module FroalaEditor

  # Video Validation class.
  # Checks if video is matching the allowed extensions and mime types.
  class VideoValidation
    require "mime-types"

    def self.ext_validation(ext, options)
      raise "Not allowed" unless options[:validation][:allowedExts].include?(ext)
    end

    def self.mime_validation(mime, options)
      raise "Invalid mime type" unless options[:validation][:allowedMimeTypes].include?(mime)
    end

    # Checks a video with the options.
    # Params:
    # +file+:: The video that will be validated.
    # +options+:: The video options that contain allowed extensions and mime types.
    # Raises exception if the video has not passed the validation
    def self.check(file, options = nil)

      mime = file.content_type
      ext = ::File.extname(file.original_filename)

      if ext_validation(ext, options) && mime_validation(mime, options)
      end
    end

  end
end