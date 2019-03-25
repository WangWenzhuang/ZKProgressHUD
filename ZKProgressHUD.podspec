Pod::Spec.new do |s|
  s.name = 'ZKProgressHUD'
  s.version = '3.3'
  s.ios.deployment_target = '8.0'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.summary = 'iOS App 上极易于使用的 HUD。'
  s.homepage = 'https://github.com/WangWenzhuang/ZKProgressHUD'
  s.authors = { 'WangWenzhuang' => '1020304029@qq.com' }
  s.source = { :git => 'https://github.com/WangWenzhuang/ZKProgressHUD.git', :tag => s.version }
  s.description = 'ZKProgressHUD 是一个在 iOS App 上极易于使用的 HUD。主要用于显示加载、进度、情景信息、Toast。'
  s.source_files = 'ZKProgressHUD/*.swift'
  s.resources = 'ZKProgressHUD/ZKProgressHUD.bundle'
  s.requires_arc = true
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }
  s.dependency 'Then'
end