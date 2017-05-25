module FroalaEditor

  # File functionality.
  class File

    # Default options that are used if no options are passed to the upload function
    @@default_options = {
        fieldname: 'file',
        validation: {
            allowedExts: [".txt", ".pdf", ".doc", ".json", ".html"],
            allowedMimeTypes: [ "text/plain", "application/msword", "application/x-pdf", "application/pdf", "application/json","text/html" ]
        },
        resize: nil
    }

    # Uploads a file to the server.
    # Params:
    # +params+:: File upload parameter mostly is "file".
    # +upload_path+:: Server upload path, a storage path where the file will be stored.
    # +options+:: Hash object that contains configuration parameters for uploading a file.
    # Returns json object
    def self.upload(params, upload_path = "public/uploads/files", options = nil)

      if options == nil
        options = @@default_options
      else
        options = @@default_options.merge(options)
      end
      file = params[options[:fieldname]]

      if file
        # Validates the file extension and mime type.
        validation = FileValidation.check(file, options)
        # Uses the Utlis name function to generate a random name for the file.
        file_name = Utils.name(file)
        path = Rails.root.join(upload_path, file_name)
        # Saves the file on the server and returns the path.
        serve_url = save(file, path)

        return {:link => serve_url}.to_json
      else
        return nil
      end
    end

    # Saves a file on the server.
    # Params:
    # +file+:: The uploaded file that will be saved on the server.
    # +path+:: The path where the file will be saved.
    def self.save (file, path)
      if ::File.open(path, "wb") {|f| f.write(file.read)}
        # Returns a public accessible server path.
        return "#{"/uploads/"}#{Utils.get_file_name(path)}"
      else
        return "error"
      end
    end

    # Deletes a file found on the server.
    # Params:
    # +file+:: The file that will be deleted from the server.
    # +path+:: The server path where the file resides.
    # Returns true or false.
    def self.delete(file = params[:file], path)

      file_path = Rails.root.join(path, ::File.basename(file))
      if ::File.delete(file_path)
        return true
      else
        return false
      end
    end
  end
end