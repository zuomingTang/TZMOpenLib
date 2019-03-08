#
# Be sure to run `pod lib lint TZMOpenLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TZMOpenLib'
  s.version          = '0.4.1'
  s.summary          = 'TZMOpenLib'
  
  s.subspec 'Manager' do |cs|
      cs.source_files = 'TZMOpenLib/Classes/Manager/**/*'
      cs.public_header_files = 'TZMOpenLib/Classes/Manager/**/*.h'
      cs.frameworks = 'UIKit', 'Foundation', 'Photos'
      # s.dependency 'AFNetworking', '~> 2.3'
  end
  
  s.subspec 'Category' do |sc|
      sc.source_files = 'TZMOpenLib/Classes/Category/**/*'
      sc.public_header_files = 'TZMOpenLib/Classes/Category/**/*.h'
      sc.frameworks = 'UIKit', 'Foundation'
      sc.dependency 'YYCategories', '1.0.3'
      sc.dependency 'ObjcAssociatedObjectHelpers', '2.0.1'
      sc.dependency 'SVProgressHUD', '2.0.1'
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
  s.source           = { :git => 'https://github.com/zuomingTang/TZMOpenLib.git', :tag => '0.4.1' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.ios.deployment_target = '8.0'
  
  # s.resource_bundles = {
  #   'TZMOpenLib' => ['TZMOpenLib/Assets/*.png']
  # }

  s.source_files = 'TZMOpenLib/Classes/*'
  s.public_header_files = 'TZMOpenLib/Classes/*.h'
end
