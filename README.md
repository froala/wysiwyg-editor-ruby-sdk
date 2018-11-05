# Froala WYSIWYG Editor Ruby SDK

Easing the [Froala WYSIWYG HTML Editor](https://github.com/froala/wysiwyg-editor) server side integration in Ruby projects.


## Setup Instructions

Add this to your Gemfile:

```ruby
gem "froala-editor-sdk"
```

and run `bundle install`.



## Quick start - Image Upload

1. Define upload route in `routes.rb` file.

   ```ruby
   post '/upload_image' => 'upload#upload_image', :as => :upload_image
   ```

2. Tell editor to upload to the specified route in your JS.

   ```javascript
   $('selector').froalaEditor({
     imageUploadURL: '/upload_image'
   });
   ```

3. In your controller define an action to store the uploaded file.

   ```ruby
   def upload_image
     render :json => FroalaEditorSDK::Image.upload(params, "public/uploads/images/")
   end
   ```

## Example App
https://github.com/froala/editor-ruby-sdk-example 

## Dependencies

The following Ruby gems are used:

- mime-types
- mini_magick
- wysiwyg-rails


## Documentation

- [Official documentation](https://www.froala.com/wysiwyg-editor/docs/sdks/ruby)


## Help

- Found a bug or have some suggestions? Just submit an issue.
- Having trouble with your integration? [Contact Froala Support team](http://froala.dev/wysiwyg-editor/contact).


## License

The Froala WYSIWYG Editor Ruby SDK is licensed under MIT license. However, in order to use Froala WYSIWYG HTML Editor plugin you should purchase a license for it.

Froala Editor has [3 different licenses](http://froala.com/wysiwyg-editor/pricing) for commercial use. For details please see [License Agreement](http://froala.com/wysiwyg-editor/terms).
