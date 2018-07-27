Pod::Spec.new do |s|
  s.name             = 'JGHybrid'
  s.version          = '4.0.6'
  s.summary          = 'A short description of JGHybrid.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Ucself/JGHybrid'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lbj147123@163.com' => 'lbj147123@163.com' }
  s.source           = { :git => 'https://github.com/Ucself/JGHybrid.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'JGHybrid/Classes/Hybrid.swift', 'JGHybrid/Classes/HybridConfiguration.swift'
  s.frameworks = 'UIKit', 'WebKit'
  s.dependency 'JGWebKitURLProtocol'
  s.dependency 'SSZipArchive'

  s.subspec 'Command' do |ss|
    ss.source_files = 'JGHybrid/Classes/Content/Command/*.swift'
  end

  s.subspec 'Core' do |ss|
    ss.source_files = 'JGHybrid/Classes/Content/Core/*.swift'
  end

  s.subspec 'Core' do |ss|
    ss.source_files = 'JGHybrid/Classes/Content/Core/*.swift'
  end

  s.subspec 'Model' do |ss|
    ss.source_files = 'JGHybrid/Classes/Content/Model/*.swift'
  end

  s.subspec 'Protocol' do |ss|
    ss.source_files = 'JGHybrid/Classes/Content/Protocol/*.swift'
  end

  s.subspec 'Tool' do |ss|
    ss.source_files = 'JGHybrid/Classes/Content/Tool/*.swift'
  end

end
