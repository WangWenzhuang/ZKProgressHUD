Pod::Spec.new do |s|
  s.name = 'ZKProgressHUD'
  s.version = '1.2'
  s.ios.deployment_target = '8.0'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.summary = 'A easy-to-use HUD for your iOS app.'
  s.homepage = 'https://github.com/WangWenzhuang/ZKProgressHUD'
  s.authors = { 'WangWenzhuang' => '1020304029@qq.com' }
  s.source = { :git => 'https://github.com/WangWenzhuang/ZKProgressHUD.git', :tag => s.version }
  s.description = 'ZKProgressHUD is a easy-to-use HUD meant to display the progress of an ongoing task on iOS.'
  s.source_files = 'ZKProgressHUD/*.swift'
  s.resources = 'ZKProgressHUD/ZKProgressHUD.bundle'
  s.requires_arc = true
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }
end
