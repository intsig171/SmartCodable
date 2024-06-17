#
# Be sure to run `pod lib lint SmartCodable.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#
## pod trunk register 邮箱名 'intsig171' --verbose
## pod me
## pod trunk push SmartCodable.podspec --allow-warnings


Pod::Spec.new do |s|
  s.name             = 'SmartCodable'
  s.version          = '4.0.3'
  s.summary          = '数据解析库'
  
  s.homepage         = 'https://github.com/intsig171'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mccc' => 'mancong@bertadata.com' }
  s.source           = { :git => 'https://github.com/intsig171/SmartCodable.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '11.0'
  s.tvos.deployment_target = "12.0"
  s.osx.deployment_target = '10.13'
  s.watchos.deployment_target = '5.0'
  s.visionos.deployment_target = "1.0"

  s.swift_version         = '5.0'
  
  
  s.source_files = 'SmartCodable/Classes/**/*'

end


