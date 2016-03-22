Pod::Spec.new do |s|

  s.name         = "Sparrow"
  s.version      = "2.1.56988637"
  s.summary      = "The Open Source Game Engine for iOS"
  s.description  =
    <<-DESC
    Sparrow is a pure Objective-C library for game developers, built from ground up
    for iOS. If you have already worked with Adobe™ Flash or Starling, you will feel
    right at home: Sparrow uses the same concepts and naming schemes.
    DESC
  s.homepage     = "http://gamua.com/sparrow/"
  s.license      = "Simplified BSD"
  s.authors      = {
    "Gamua" => "http://gamua.com",
    "Daniel Sperl"  => "https://twitter.com/PrimaryFeather",
    "Robert Carone" => "https://twitter.com/robcarone"
  }
  s.social_media_url = "http://twitter.com/Gamua"
  s.platform         = :ios, "5.0"
  s.source           = {
    :git => "https://github.com/joytunes/Sparrow-Framework.git",
    :branch => "joytunes"
  }
  s.source_files  = "sparrow/src/Classes/*.{h,m}"
  s.frameworks =
    "GLKit",
    "OpenGLES",
    "OpenAL",
    "QuartzCore",
    "AudioToolbox",
    "AVFoundation"
  s.libraries = "z"
  s.requires_arc = false

end
