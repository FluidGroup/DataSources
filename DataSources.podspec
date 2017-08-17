Pod::Spec.new do |s|
  s.name = 'DataSources'
  s.version = '0.2.0'
  s.summary = '💾 🔜📱 Type-safe data-driven List-UI Framework'
  s.homepage = 'https://github.com/muukii/DataSources'
  s.description = '💾 🔜📱 Type-safe data-driven List-UI Framework. (We can also use ASCollectionNode)'

  s.license =  { :type => 'MIT' }
  s.author = { 'muukii' => 'm@muukii.me' }
  s.social_media_url = 'https://twitter.com/muukii0803'
  s.source = { :git => 'https://github.com/muukii/DataSources.git', :tag => s.version.to_s }

  s.subspec 'Default' do |cs|
    # cs.frameworks = 'DataSources/Diff'
    # cs.dependency 'DataSources/Diff'
    cs.source_files = ['Sources/Diff/**/*.swift', 'Sources/DataSources/**/*.swift']
  end

  s.module_name = s.name
  s.default_subspec = 'Default'
  s.requires_arc = true
  s.ios.deployment_target = '9.0'
  s.ios.frameworks = 'UIKit'
end
