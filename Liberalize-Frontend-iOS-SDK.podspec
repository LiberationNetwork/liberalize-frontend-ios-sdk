#
# Be sure to run `pod lib lint Liberalize-Frontend-iOS-SDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Liberalize-Frontend-iOS-SDK'
  s.version          = '0.0.2'
  s.summary          = 'Liberalize Frontend iOS mobile SDK'
  s.swift_versions   = '5.0'

  s.homepage         = 'https://www.liberalize.io/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Liberalize' => 'Liberalize' }
  s.source           = { :git => 'https://github.com/LiberationNetwork/liberalize-frontend-ios-sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.source_files = 'Liberalize-Frontend-iOS-SDK/Classes/**/*'

end
