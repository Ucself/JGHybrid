Pod::Spec.new do |s|
  s.name             = 'JGHybrid'
  s.version          = '5.1.3'
  s.summary          = 'A short description of JGHybrid.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Ucself/JGHybrid'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lbj147123@163.com' => 'lbj147123@163.com' }
  s.source           = { :git => 'https://github.com/Ucself/JGHybrid.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'JGHybrid/Classes/Hybrid.swift', 'JGHybrid/Classes/HybridConfiguration.swift', 'JGHybrid/Classes/GTANavigationBar.swift'
  s.frameworks = 'UIKit', 'WebKit'
  s.dependency 'JGWebKitURLProtocol'
  s.dependency 'SSZipArchive'

  s.subspec 'Command' do |command|
    command.source_files = 'JGHybrid/Classes/Content/Command/*.swift'
  end

  s.subspec 'Core' do |core|
    core.source_files = 'JGHybrid/Classes/Content/Core/*.swift'
  end

  s.subspec 'Params' do |params|
    params.source_files = 'JGHybrid/Classes/Content/Params/*.swift'
  end
  
  s.subspec 'Common' do |common|
      
      common.source_files = 'JGHybrid/Classes/Content/Common/*.swift'
      
      common.subspec 'Protocol' do |protocol|
          protocol.source_files = 'JGHybrid/Classes/Content/Common/Protocol/*.swift'
      end
      
      common.subspec 'Tool' do |tool|
          tool.source_files = 'JGHybrid/Classes/Content/Common/Tool/*.swift'
      end
  end

end
