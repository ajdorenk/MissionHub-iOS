platform :ios, "5.0"

# ignore all warnings from all pods
inhibit_all_warnings!

xcodeproj "MissionHub"
workspace "MissionHub"
link_with "MissionHub"

target :MissionHub do

	pod 'Facebook-iOS-SDK', '3.5'
	pod 'AFNetworking', '~> 1.3.1'
	pod 'DWTagList', :git => 'https://github.com/CruGlobal/DWTagList.git'
	pod 'ECSlidingViewController', '~> 1.0.1'
	pod 'M6ParallaxController', :git => 'https://github.com/CruGlobal/M6ParallaxController.git'
	pod 'ODRefreshControl', '~> 1.1.0'
	pod 'SDSegmentedControl', '~> 1.0.1'
	pod 'SIAlertView', '1.2'
	pod 'TTTAttributedLabel', '~> 1.7.1'
	pod 'NewRelicAgent', '~> 1.376'
	pod 'GoogleAnalytics-iOS-SDK', '~> 3.0.1'
	#pod 'Airbrake-iOS', :git => 'https://github.com/CruGlobal/airbrake-ios.git'
	pod 'MYBlurIntroductionView', :git => 'https://github.com/CruGlobal/MYBlurIntroductionView.git'

	target :tests, :exclusive => true do
		pod 'Kiwi/XCTest', '2.2.2'
		pod 'KIF', '~> 2.0'
		pod 'OCHamcrest', '~> 3.0'
		pod 'Nocilla', '~> 0.7'
	end

end

