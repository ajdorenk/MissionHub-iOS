platform :ios, "6.0"

xcodeproj "MissionHub"
workspace "MissionHub"
link_with "MissionHub"

target :MissionHub do

	pod 'Facebook-iOS-SDK', '3.5'
	pod 'AFNetworking', '~> 1.3.1'
	pod 'DWTagList', :git => 'https://github.com/michaelharro/DWTagList.git'
	pod 'ECSlidingViewController', '~> 1.0.1'
	pod 'M6ParallaxController', :git => 'https://github.com/michaelharro/M6ParallaxController.git'
	pod 'ODRefreshControl', '~> 1.1.0'
	pod 'SDSegmentedControl', '~> 1.0.1'
	pod 'SIAlertView', '1.2'
	pod 'TTTAttributedLabel', '~> 1.7.1'

	target :tests, :exclusive => true do
		pod 'Kiwi/XCTest', '2.2.2'
		pod 'KIF', '~> 2.0'
		pod 'OCHamcrest', '~> 3.0'
		pod 'Nocilla', '~> 0.7'
	end

end

