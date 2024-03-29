#
# Be sure to run `pod lib lint Daigo.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Daigo'
  s.version          = '0.2.0'
  s.summary          = 'Daigo is vertical viewer'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/yuuki-noda/Daigo'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yuuki-noda' => 'yuuki.noda@link-u.co.jp' }
  s.source           = { :git => 'https://github.com/yuuki-noda/Daigo.git', :tag => s.version.to_s }
  s.swift_version = '4.0'
  s.ios.deployment_target = '13.0'

  s.source_files = 'Daigo/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Daigo' => ['Daigo/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
