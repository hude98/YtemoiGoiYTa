# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
source "https://gitlab.linphone.org/BC/public/podspec.git"
source "https://github.com/CocoaPods/Specs.git"

def linphone_pods
  if ENV['PODFILE_PATH'].nil?
    pod 'linphone-sdk', '~> 5.0.0'
  else
    pod 'linphone-sdk', :path => ENV['PODFILE_PATH']  # local sdk
  end
  crashlytics
end

def crashlytics
  if not ENV['USE_CRASHLYTICS'].nil?
    pod 'Firebase/Analytics'
    pod 'Firebase/Crashlytics'
  end
end

target 'YtemoiGoiYTa' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for YtemoiGoiYTa
  
 pod 'SVProgressHUD'
 linphone_pods
 
end
