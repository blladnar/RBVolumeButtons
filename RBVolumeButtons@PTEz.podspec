
Pod::Spec.new do |s|

  s.name         = "RBVolumeButtons@PTEz"
  s.version      = "0.1.1"
  s.summary      = "This lets you steal the volume up and volume down buttons on iOS."
  s.homepage     = "https://github.com/PTEz/RBVolumeButtons"

  s.license      = { :type => 'Apache License, Version 2.0', :text => <<-LICENSE
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
    http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    LICENSE
  }
  s.author       = { "Ernesto Rivera" => "rivera.ernesto@gmail.com", "Randall Brown" => "" }

  s.platform     = :ios
  s.requires_arc = true

  s.source       = { :git => "https://github.com/PTEz/RBVolumeButtons.git", :tag => "#{s.version}" }
  s.source_files = 'VolumeSnap/RBVolumeButtons.{h,m}'

  s.frameworks   = 'AudioToolbox', 'MediaPlayer'

end
