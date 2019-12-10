#
# Be sure to run `pod lib lint TZMOpenLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TZMOpenLib'
  s.version          = '0.4.19.1'
  s.summary          = 'TZMOpenLib'
  
  s.subspec 'Manager' do |sm|
      sm.source_files = 'TZMOpenLib/Classes/Manager/**/*'
      sm.public_header_files = 'TZMOpenLib/Classes/Manager/**/*.h'
      sm.frameworks = 'UIKit', 'Foundation', 'Photos'
      # s.dependency 'AFNetworking', '~> 2.3'
  end
  
  s.subspec 'Category' do |sc|
      sc.source_files = 'TZMOpenLib/Classes/Category/**/*'
      sc.public_header_files = 'TZMOpenLib/Classes/Category/**/*.h'
      sc.frameworks = 'UIKit', 'Foundation'
      sc.dependency 'YYCategories', '1.0.3'
      sc.dependency 'ObjcAssociatedObjectHelpers', '2.0.1'
  end
  
  s.subspec 'StatusView' do |ss|
      ss.source_files = 'TZMOpenLib/Classes/StatusView/**/*'
      ss.public_header_files = 'TZMOpenLib/Classes/StatusView/**/*.h'
      ss.resource_bundles = {
        'StatusView' => ['TZMOpenLib/Assets/StatusView/*']
      }
      ss.frameworks = 'UIKit', 'Foundation'
      ss.dependency 'Masonry', '1.1.0'
  end
  
  s.subspec 'RefreshAndLoadMore' do |sr|
      sr.source_files = 'TZMOpenLib/Classes/RefreshAndLoadMore/**/*'
      sr.public_header_files = 'TZMOpenLib/Classes/RefreshAndLoadMore/**/*.h'
      sr.frameworks = 'UIKit', 'Foundation'
      sr.dependency 'YYCategories', '1.0.3'
      sr.dependency 'ObjcAssociatedObjectHelpers', '2.0.1'
  end
  
  s.subspec 'ViewController' do |svc|
      svc.source_files = 'TZMOpenLib/Classes/ViewController/**/*'
      svc.public_header_files = 'TZMOpenLib/Classes/ViewController/**/*.h'
      svc.frameworks = 'UIKit'
      svc.dependency 'Masonry', '1.1.0'
  end
  
  s.subspec 'View' do |sv|
      sv.source_files = 'TZMOpenLib/Classes/View/**/*'
      sv.public_header_files = 'TZMOpenLib/Classes/View/**/*.h'
      sv.resource_bundles = {
          'View' => ['TZMOpenLib/Assets/View/*']
      }
      sv.frameworks = 'UIKit'
      sv.dependency 'XXNibBridge', '2.3.1'
  end


# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: TZMOpenLib.
                       DESC

  s.homepage         = 'https://github.com/zuomingTang/TZMOpenLib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zuomingTang' => '414933949@qq.com' }
  s.source           = { :git => 'https://github.com/zuomingTang/TZMOpenLib.git', :tag => '0.4.19.1' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.ios.deployment_target = '8.0'
  
  # s.resource_bundles = {
  #   'TZMOpenLib' => ['TZMOpenLib/Assets/*.png']
  # }

  s.source_files = 'TZMOpenLib/Classes/*'
  s.public_header_files = 'TZMOpenLib/Classes/*.h'
end
