# Finvu iOS Mobile SDK Integration Guide

## Table of Contents
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Installation](#installation)
4. [Accessing Finvu SDK APIs](#accessing-finvu-sdk-apis)
5. [Initialization](#initialization)
6. [Usage](#usage)
7. [APIs](#apis)
8. [Frequently Asked Questions](#frequently-asked-questions)

## Introduction
Welcome to the integration guide for Finvu iOS SDK! This document provides detailed instructions on integrating our SDK into your iOS application.

## Prerequisites
    1. Min iOS version supported is iOS 13

## Installation

Add the following to your `Podfile`
```ruby
target 'Runner' do
  use_frameworks!
  use_modular_headers!

  ## Add these lines
  platform :ios, '16.0'
  pod 'FinvuSDK' , :git => 'https://github.com/Cookiejar-technologies/finvu_ios_sdk.git'
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    // Add these lines
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
    end
  end
end

```

## Accessing Finvu SDK APIs
`FinvuManager` class that should be used to access the APIs on the SDK. `FinvuManager` class is a singleton, and can be access as follows:
```swift
    let finvuManager = FinvuManager.shared
```

## Initialization
Initialize the SDK in your application's entry point (eg. splash screen). SDK can be initialized using the the following method.
```swift
        let finvuUrl = URL(string: "wss://webvwdev.finvu.in/api")!
        finvuClientConfig = FinvuClientConfig(
            finvuEndpoint: finvuUrl
        )

        finvuManager.initializeWith(config: finvuClientConfig)
```

## Usage
Refer to the SDK documentation for detailed instructions on using various features and functionalities provided by the SDK. Below is the sequence diagram which includes SDK initialization, account linking and data fetch flows.
![sequence-diagram](docs/Sequence-diagram.png)

## APIs

1. Initialize with config
Initialize API allows you to configure the finvuEndpoint. This is a way to configure the SDK to point to specific environments. 
```swift
        let finvuUrl = URL(string: "wss://webvwdev.finvu.in/api")!
        finvuClientConfig = FinvuClientConfig(
            finvuEndpoint: finvuUrl
        )

        finvuManager.initializeWith(config: finvuClientConfig)
```

2. Connect 
Finvu exposes websocket APIs that the sdk interacts with. Before making any other calls, connect method should be called. This is an async method, so await should be used to ensure its completion.
```swift
    FinvuManager.shared.connect { error in
        if let error = error {
            print("Your connection is not secure, disconnected. err=\(error)")
            return
        }
        print("connected")
    }
```

3. Login with Consent Handle
Once the consent handle has been retrieved from the FIU server and we want to initiate the login flow for the user, it can be done in the following manner
```swift
FinvuManager.shared.loginWith(
      username : "HANDLE_IF_ANY",
      mobileNumber : "MOBILE_NUMBER_IF_ANY",
      consentHandleId: "CONSENT_HANDLE_ID",
    ) { response, error in
        
    }
```

4. Verify login otp
The login response contains the otp reference. Once user enters the otp, verification can be triggered in the following way - 
```swift
    FinvuManager.shared.verifyLoginOtp(otp: otp, otpReference: otpReference) { handleInfo, error in
    
    }
```
Post login success, sdk will keep this session authenticated for the user and the rest of the methods can be triggered.

5. Fetch all FIP options
Use this method to get all FIP details where discovery flows can be triggered
```swift
    FinvuManager.shared.fipsAllFIPOptions { fipSearchResponse, error in
    
    }
```

6. Account discovery
In order to initiate discovery flow, you will need to get FIP details first. Get them for the selected FIP in the following way
```swift
    FinvuManager.shared.fetchFIPDetails(fipId: fipId) { fipDetails, error in
    }
```
Once FIPDetails are available, discovery can be made with the following step - 

```swift
    FinvuManager.shared.discoverAccounts(fipId: fipId, 
                                            fiTypes: fiTypes, 
                                        identifiers: identifiers) { response, error in
    
    }
```
FITypes describe the type of accounts that we want to discover, typeIdentifiers provides the identifiers to discover them with. Here's an example of what thay may look like - 
```json
    {
        "category": "STRONG",
        "type": "MOBILE",
        "value": "9309107496"
    }
```

7. Initiate account linking
Once accounts have been discovered, linking flow may be initiated. Multiple accounts can be linked at once. 
```swift
    FinvuManager.shared.linkAccounts(fipDetails: fipDetails, accounts: accounts) { requestReference, error in
        if (error != nil) {
            // handle error
        }
        
        
    }
```

8. Confirm account linking
On initiating account linking flow, an otp will be triggered by the FIP to the user. SDK will return a reference for this linking. Once user enters the top, linking can be confirmed by doing the following -

```swift
      FinvuManager.shared.confirmAccountLinking(linkingReference: AccountLinkingRequestReference(referenceNumber: referenceNumber), otp: otp) { confirmAccountLinkingInfo, error in
            if (error != nil) {
                // handle error
                return
            }
        }
```

9. Fetch all linked accounts
All existing linked accounts for the user can be fetched in the following manner -
```swift
      FinvuManager.shared.fetchLinkedAccounts { response, error in
            if (error != nil) {
                // handle error
                return
            }
        }
```

10. Consent flow
Once consent info is displayed to the user and user approves it, you can call the following method to convey the approval - 
```swift
FinvuManager.shared.approveAccountConsentRequest(consentDetail: consentDetail, linkedAccounts: linkedAccountsInfo) { response, error in
            if (error != nil) {
                // handle error
                return
            }
        }
```

In case user denies the consent, call this method instead - 
```swift
    FinvuManager.shared.denyAccountConsentRequest;
```
