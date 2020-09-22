# Uncomment the next line to define a global platform for your project
platform :ios, '13.5'

target 'o-fish-ios' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'RealmSwift', '= 10.0.0-beta.3'
  pod 'SwiftLint'
end

target 'O-FISHTests' do
   use_frameworks!

   pod 'RealmSwift', '= 10.0.0-beta.3'
   pod 'SwiftLint'
end

# TODO: Remove this once CocoaPods no longer needs it.
# It's here to fix the `The iOS Simulator deployment target 'IPHONEOS_DEPLOYMENT_TARGET' is set to 8.0, but the range of supported deployment target versions is 9.0 to 14.0.99.`
# error
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
