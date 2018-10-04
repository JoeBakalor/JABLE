#
# Be sure to run `pod lib lint JABLE.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JABLE'
  s.version          = '0.3.0'
  s.summary          = 'JABLE is a full feature BLE Central mode library'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: JBLE is a BLE central mode library that provides automation for GATT discovery and interaction
                       DESC

  s.homepage         = 'https://github.com/jmb2k6/JABLE'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jmbakalor@gmail.com' => 'jmbakalor@gmail.com' }
  s.source           = { :git => 'https://github.com/jmb2k6/JABLE.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'JABLE/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JABLE' => ['JABLE/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'CoreBluetooth'
  # s.dependency 'AFNetworking', '~> 2.3'
end
