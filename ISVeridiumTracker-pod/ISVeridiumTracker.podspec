Pod::Spec.new do |s|
  s.name             = 'ISVeridiumTracker'
  s.version          = '1.1.0'
  s.summary          = 'ISVeridiumTracker.'
  s.swift_version = '5.0'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/oswaldo.leon9@gmail.com/ISVeridiumTracker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'oswaldo.leon9@gmail.com' => 'oswaldo.leon9@gmail.com' }
  s.source           = { :git => 'https://github.com/oswaldo.leon9@gmail.com/ISVeridiumTracker.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.public_header_files = 'ISVeridiumTracker/**/*.h'
  s.vendored_frameworks = 'ISVeridiumTracker/**/*.xcframework'


end
