#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint file_pickerz.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'file_pickerz'
  s.version          = '0.0.1'
  s.summary          = 'A flutter plugin to show native file picker dialogs'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'https://github.com/Yadav-Sunil/plugins_flutter_file_picker'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'Sunil Yadav'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  
  preprocess_definitions=[]
  if !Pod.const_defined?(:PICKER_MEDIA) || PICKER_MEDIA
    preprocess_definitions << "PICKER_MEDIA=1"
    s.dependency 'DKImagePickerController/PhotoGallery'
  end
  if !Pod.const_defined?(:PICKER_AUDIO) || PICKER_AUDIO
    preprocess_definitions << "PICKER_AUDIO=1"
  end
  if !Pod.const_defined?(:PICKER_DOCUMENT) || PICKER_DOCUMENT
    preprocess_definitions << "PICKER_DOCUMENT=1"
  end
  s.pod_target_xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => preprocess_definitions.join(' ') }

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
