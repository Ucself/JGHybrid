Pod::Spec.new do |s|
  s.name             = 'JGHybrid'
  s.version          = '3.6.0'
  s.summary          = 'A short description of JGHybrid.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Ucself/JGHybrid'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lbj147123@163.com' => 'lbj147123@163.com' }
  s.source           = { :git => 'https://github.com/Ucself/JGHybrid.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'JGHybrid/Classes/**/*'
  s.frameworks = 'UIKit', 'WebKit'
  s.dependency 'JGWebKitURLProtocol'
  s.dependency 'SSZipArchive'

end
