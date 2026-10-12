Pod::Spec.new do |s|
    s.name         = "FinvuSDK"
    s.version      = "2.0.0"
    s.summary      = "FinvuSDK Client library"
    s.description  = "Client Library to access Finvu SDK"
    s.homepage     = "github.com/Cookiejar-technologies/finvu_ios_sdk"
    s.license = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "Finvu" => "manoja@cookiejar.co.in" }
    s.source       = { :git => "https://github.com/Cookiejar-technologies/finvu_ios_sdk", :branch => "main", :tag => "#{s.version}" }
    s.vendored_frameworks = "FinvuSDK.xcframework", "FinvuAuthenticationSDK.xcframework", "Starscream.xcframework", "TrustKit.xcframework"
    s.platform = :ios
    s.swift_version = "5.7"
    s.ios.deployment_target  = '16.0'
end
