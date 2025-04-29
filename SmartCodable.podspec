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
  s.version          = '4.4.0-beta.2'
  s.summary          = 'Swift数据解析库'
  
  s.homepage         = 'https://github.com/intsig171'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mccc' => '562863544@qq.com' }
  s.source           = { :git => 'https://github.com/intsig171/SmartCodable.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '13.0'

  s.source_files = 'Sources/SmartCodable/**/*{.swift}'
  s.preserve_paths = ["Package.swift", "Sources/SmartCodableMacros", "Tests", "Bin"]
  
  s.pod_target_xcconfig = {
    "OTHER_SWIFT_FLAGS" => "-Xfrontend -load-plugin-executable -Xfrontend $(PODS_BUILD_DIR)/SmartCodable/release/SmartCodableMacros-tool#SmartCodableMacros"
  }
  
  s.user_target_xcconfig = {
    "OTHER_SWIFT_FLAGS" => "-Xfrontend -load-plugin-executable -Xfrontend $(PODS_BUILD_DIR)/SmartCodable/release/SmartCodableMacros-tool#SmartCodableMacros"
  }

  script = <<-SCRIPT
    env -i PATH="$PATH" "$SHELL" -l -c "swift build -c release --package-path \\"$PODS_TARGET_SRCROOT\\" --build-path \\"${PODS_BUILD_DIR}/SmartCodable\\""
    SCRIPT
  
  s.script_phase = {
      :name => 'Build SmartCodable macro plugin',
      :script => script,
      :execution_position => :before_compile
  }
end


