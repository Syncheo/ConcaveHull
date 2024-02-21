#
# Be sure to run `pod lib lint ConcaveHull.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ConcaveHull'
  s.version          = '1.3.0'
  s.summary          = 'A Swift Library that builds concave or convexe hull by set of points'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Concave hull is a simple library that generate the hull of a set of points, the points can
be of any format, the concavity of the hull is defined by a parameter if the function. 
To create the Hull, just call Hull().hull(pointSet, Concavity, format or nil)
                       DESC
  s.homepage         = 'https://github.com/Syncheo/ConcaveHull'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Syncheo' => 'smaamari@syncheo.tech' }
  s.source           = { :git => 'https://github.com/Syncheo/ConcaveHull.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ConcaveHull/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ConcaveHull' => ['ConcaveHull/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
