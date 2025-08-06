Pod::Spec.new do |s|
    s.name         = "FinvuSDK"
    s.version      = "1.0.5"
    s.summary      = "FinvuSDK Client library"
    s.description  = "Client Library to access Finvu SDK"
    s.homepage     = "github.com/Cookiejar-technologies/finvu_ios_sdk"
    s.license = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "Finvu" => "manoja@cookiejar.co.in" }
    s.source       = { :git => "https://github.com/Cookiejar-technologies/finvu_ios_sdk", :branch => "test", :tag => "#{s.version}" }
    s.vendored_frameworks = "FinvuSDK.xcframework", "Starscream.xcframework", "TrustKit.xcframework"
    s.platform = :ios
    s.swift_version = "5.7"
    s.ios.deployment_target  = '13.0'
end
