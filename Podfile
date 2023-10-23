#source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '15.0'
use_frameworks!

target "SSR-Pro" do
    pod 'ExpyTableView'
    pod 'ReachabilitySwift'
    pod 'Connectivity'
    pod 'Alamofire'
    pod 'lottie-ios'
    pod 'KissXML'
    pod 'Cartography', '~> 3.0.4'
    pod 'AsyncSwift'
    pod 'MBProgressHUD'
    pod 'ICDMaterialActivityIndicatorView', '~> 0.1.0'
    pod 'MMWormhole'
    pod 'Eureka'
    pod 'RealmSwift'
    pod 'CallbackURLKit'
    pod 'CocoaAsyncSocket'
    pod 'CocoaLumberjack/Swift'
end

target "PacketTunnel" do
  pod 'CocoaLumberjack/Swift'
  pod 'MMWormhole'
  pod 'CocoaAsyncSocket'
end

target "PacketProcessor" do
  pod 'CocoaAsyncSocket'
end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
            end
        end
    end
end
