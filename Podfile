# Uncomment the next line to define a global platform for your project
 platform :ios, '14.0'

# ignore all warnings from all pods
inhibit_all_warnings!

def pods
  pod 'AWSCore', '~> 2.13'
  pod 'AWSS3', '~> 2.13.0'
  pod 'Firebase/Core'
  pod 'IQKeyboardManagerSwift', '~> 6.5'
  pod 'Mixpanel-swift'
  pod 'SwiftEntryKit', '1.2.3'
  pod 'SwiftLint'
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
