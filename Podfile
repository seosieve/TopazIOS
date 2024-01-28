platform :ios, '14.0'

target 'topaz' do
  use_frameworks!
  
  # Pods for topaz
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'lottie-ios'
  pod 'Kingfisher', '~> 7.0'
  pod 'SwiftySound'
  
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end
