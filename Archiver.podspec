#
# Be sure to run `pod lib lint Archiver.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Archiver"
  s.version          = "1.0.6"
  s.summary          = "Allows to dump Object into persistance."
  s.homepage         = "http://www.timesinternet.in"
  s.license          = { :type => "Times Internet Limited", :file => "LICENSE" }
  s.author           = { "Ravi Prakash Sahu" => "ravi.sahu@timesinternet.in" }
  s.source           = { :git => "https://github.com/ET-IOS/NSObject-NSCoding.git" }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.frameworks = 'Foundation'
end
