Pod::Spec.new do |s|
  s.name = 'DataSources'
  s.version = '2.0.0'
  s.summary = '💾 🔜📱 Type-safe data-driven List-UI Framework'
  s.homepage = 'https://github.com/muukii/DataSources'
  s.description = '💾 🔜📱 Type-safe data-driven List-UI Framework. (We can also use ASCollectionNode)'

  s.license =  { :type => 'MIT' }
  s.author = { 'muukii' => 'muukii.app@gmail.com' }
  s.social_media_url = 'https://twitter.com/muukii_app'
  s.source = { :git => 'https://github.com/muukii/DataSources.git', :tag => s.version.to_s }

  s.subspec 'Default' do |cs|
    cs.source_files = ['Sources/DataSources/**/*.swift']
  end

  s.dependency 'DifferenceKit/Core'
  s.module_name = s.name
  s.default_subspec = 'Default'
  s.requires_arc = true
  s.ios.deployment_target = '9.0'
  s.ios.frameworks = 'UIKit'
end
