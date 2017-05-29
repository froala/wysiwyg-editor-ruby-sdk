module FroalaEditorSDK

  # Image Validation class.
  # Checks if image is matching the allowed extensions and mime types.
  class Validation
    require "mime-types"

    def self.ext(ext, options)
      raise "Not allowed" unless options[:validation][:allowedExts].include?(ext)
    end

    def self.mime(mime, options)
      raise "Invalid mime type" unless options[:validation][:allowedMimeTypes].include?(mime)
    end

    # Checks an image with the options.
    # Params:
    # +file+:: The image that will be validated.
    # +options+:: The image options that contain allowed extensions and mime types.
    # Raises exception if the image has not passed the validation
    def self.check(file, options = nil)

      mime = file.content_type
      ext = ::File.extname(file.original_filename)
      if ext(ext, options) && mime(mime, options)
      end
    end

  end
end