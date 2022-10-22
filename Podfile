# Uncomment the next line to define a global platform for your project
 platform :ios, '14.0'

# ignore all warnings from all pods
inhibit_all_warnings!

def pods
  pod 'AWSCore'
  pod 'AWSS3'
  pod 'Bugsee'
  pod 'Firebase/Core'
  pod 'IQKeyboardManagerSwift', '~> 6.5'
  pod 'Kingfisher'
  pod 'LiveChat'
  pod 'lottie-ios'
  pod 'Mixpanel-swift'
  pod 'SwiftEntryKit', '1.2.3'
  pod 'SwiftLint'
  pod 'SwiftyMarkdown'
  pod 'ZendeskAnswerBotSDK' # AnswerBot-only on the Unified SDK
  pod 'ZendeskChatSDK'      # Chat-only on the Unified SDK
  pod 'ZendeskSupportSDK'   # Support-only on the Unified SDK
end

target 'Vessel' do
  project 'Vessel'
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pods
	
  target 'VesselTests' do
    inherit! :search_paths
  end

  #target 'VesselUITests' do
    # Pods for testing
 # end

end

#Set deployment target for all pods to be the project deployment target
post_install do |installer|
  fix_deployment_target(installer)
end

def fix_deployment_target(installer)
  return if !installer
  project = installer.pods_project
  project_deployment_target = project.build_configurations.first.build_settings['IPHONEOS_DEPLOYMENT_TARGET']

  puts "Make sure all pods deployment target is #{project_deployment_target.green}"
  project.targets.each do |target|
    puts "  #{target.name}".blue
    target.build_configurations.each do |config|
      old_target = config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']
      new_target = project_deployment_target
      next if old_target == new_target
      puts "    #{config.name}: #{old_target.yellow} -> #{new_target.green}"
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = new_target
    end
  end
end
