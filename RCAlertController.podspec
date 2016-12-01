Pod::Spec.new do |s|
  s.name             = 'RCAlertController'
  s.version          = '0.1.1'
  s.summary          = 'A custom alert controller for iOS9+ applications.'

  s.description      = <<-DESC
A custom alert controller for iOS9+ applications. Highly customizible with simple API similar to Apple's UIAlertController. With an easy and powerful customization mechanism you can create beautiful alerts that fits into your app design. You can customize almost everything and even insert a custom view made by you for the alert.
DESC

  s.homepage         = 'https://github.com/rcarvalhosilva/RCAlertController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rodrigo Carvalho' => 'rcarvalho.dev@gmail.com' }
  s.source           = { :git => 'https://github.com/rcarvalhosilva/RCAlertController.git', :tag => '0.1.1'}
  s.social_media_url = 'https://twitter.com/rcarvalho_94'

  s.ios.deployment_target = '9.0'

  s.source_files = 'RCAlertController/Classes/**/*'
  s.frameworks = 'UIKit'
end
