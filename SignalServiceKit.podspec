#
# Be sure to run `pod lib lint SignalServiceKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SignalServiceKit"
  s.version          = "0.9.0"
  s.summary          = "An Objective-C library for communicating with the Signal messaging service."

  s.description      = <<-DESC
An Objective-C library for communicating with the Signal messaging service.
  DESC

  s.homepage         = "https://github.com/WhisperSystems/SignalServiceKit"
  s.license          = 'GPLv3'
  s.author           = { "Whisper Systems" => "ios@whispersystems.com" }
  s.source           = { :git => "https://github.com/WhisperSystems/SignalServiceKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/WhipserSystems'

  deprecation_message = <<EOS
installing SignalServiceKit via the Signal-iOS repository.

To get future updates, point your Podfile at the new location. Simply change this:

    pod 'SignalServiceKit', git: 'https://github.com/WhisperSystems/SignalServiceKit.git'

To this:

    pod 'SignalServiceKit', git: 'https://github.com/WhisperSystems/Signal-iOS.git'

Sorry for the disruption!

EOS

  s.deprecated_in_favor_of = deprecation_message

  s.platform     = :ios, '8.0'
  #s.ios.deployment_target = '8.0'
  #s.osx.deployment_target = '10.9'
  s.requires_arc = true

  # By not including any actual files, upgrading users will see
  # that they need to point upgrades to the new source at
  # https://github.com/WhisperSystems/Signal-iOS
  # Details in README.md
  s.source_files = 'README.md'

  s.resources = ['src/Security/PinningCertificate/textsecure.cer',
                 'src/Security/PinningCertificate/GIAG2.crt']
  s.prefix_header_file = 'src/TSPrefix.h'
  s.xcconfig = { 'OTHER_CFLAGS' => '$(inherited) -DSQLITE_HAS_CODEC' }

  s.dependency '25519'
  s.dependency 'CocoaLumberjack'
  s.dependency 'AFNetworking'
  s.dependency 'AxolotlKit'
  s.dependency 'Mantle'
  s.dependency 'YapDatabase/SQLCipher', '~> 2.9.3'
  s.dependency 'SocketRocket'
  s.dependency 'libPhoneNumber-iOS'
  s.dependency 'SAMKeychain'
  s.dependency 'TwistedOakCollapsingFutures'
end
