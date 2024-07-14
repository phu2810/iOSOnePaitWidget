Pod::Spec.new do |s|
  s.name         = 'iOSOnePaitWidget'
  s.version      = '0.1.0'
  s.summary      = 'A short description of MyLocalPod.'
  s.description  = <<-DESC
                    A longer description of MyLocalPod.
                   DESC
  s.homepage     = 'https://example.com/MyLocalPod'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Your Name' => 'your.email@example.com' }
  s.source = { :git => "https://github.com/phu2810/iOSOnePaitWidget.git", :tag => "#{s.version}"}
  s.source       = { :path => '.' }
  s.platform     = :ios, '15.0'
  s.source_files  = 'Sources/**/*.{swift,h,m}'
  s.resources    = 'Sources/Assets/**/*'
  s.swift_version = '5.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end