Pod::Spec.new do |s|

  s.name         = "RBVolumeButtons"
  s.version      = "0.1.0"
  s.summary      = "This lets you steal the volume up and volume down buttons on iOS."
  s.homepage     = "https://github.com/blladnar/RBVolumeButtons"
  s.license      = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author       = { "Randall Brown" => "" }

  s.platform     = :ios
  s.requires_arc = false

  s.source       = { :git => "https://github.com/blladnar/RBVolumeButtons.git" }
  s.source_files  = 'VolumeSnap/RBVolumeButtons.{h,m}'

  s.frameworks = 'AudioToolbox', 'MediaPlayer'

end