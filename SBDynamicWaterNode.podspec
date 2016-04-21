Pod::Spec.new do |s|
  s.name             = "SBDynamicWaterNode"
  s.version          = "0.1.1"
  s.summary          = "Physical water simulation for SpriteKit"

  s.description      = <<-DESC
Physical water simulation for SpriteKit with demo application
                       DESC

  s.homepage         = "https://github.com/SteveBarnegren/DynamicWaterNode"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Steve Barnegren" => "steve.barnegren@gmail.com" }
  s.source           = { :git => "https://github.com/SteveBarnegren/SBDynamicWaterNode.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/stevebarnegren'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'SBDynamicWaterNode/**/*.{h,m}'
  s.resources = 'SBDynamicWaterNode/**/*.{png,fsh}'
  #s.resource_bundles = {
  #  'SBDynamicWaterNode' => ['SBDynamicWaterNode/*.{png,fsh}']
  #}

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'SpriteKit'
end
