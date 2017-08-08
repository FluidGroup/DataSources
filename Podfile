# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'DataSourcesDemo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  swift_version = '3.1'

  pod 'Texture'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'EasyPeasy'

  # Pods for DataSourcesDemo

  target 'DataSourcesDemoUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'DataSourcesDemo'
      target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '3.1'
      end
    end
  end
end
