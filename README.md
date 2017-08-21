## About this project

Gigya’s iOS SDK provides an Objective-C interface for the Gigya API, allowing user login in their iOS devices. This project integrates Gigya's native SDK and show how Gigya Registration as a Service (RaaS) features can be implemented natively or by using the plugin view with screensets.<br/>
The following social providers are available for native Login:<br/>
Facebook, Google SignIn, Twitter<br/>
And uses oAuth flows, REST and web login for other providers such as LinkedIn, Microsoft, Yahoo, etc..

## Demo features<br/>
-> RaaS Login via Plugin View<br/>
-> RaaS Login via Web-View/Web-bridge<br/>
-> RaaS Login via Native<br/>
-> Gigya Login with Touch ID integration<br/>
-> RaaS Screenset and update profile<br/>
-> Comments via Plugin View<br/>
-> Reactions Bar via Plugin View<br/>
-> Account Delegate events<br/>
-> Web-bridge Delegate events<br/>
-> Pluginview delegate events<br/>

## Installation

A pod file is included in this project, which configures Gigya, Facebook and Google native SDKs. For the purpose of this demo, a test Gigya API key, Facebook and Google application keys are being used from a test account. Please do not use in Production codes - as this project is for demo purposes only.<br/>
From Terminal, run
```
pod install
```
Depending on your xcode configuration, you may get a message from cocoa pods indicating to use '$inherited' in 'Other Linker Flags' in Build Settings. This is important in order to avoide compilation linking issues.

## Gigya References

[Gigya iOS SDK installation](https://developers.gigya.com/display/GD/iOS)
[Gigya iOS Reference Documentation](https://developers.gigya.com/display/GD/iOS+SDK+Reference)
[Gigya iOS SDK change log](https://developers.gigya.com/display/GD/iOS+SDK+Change+Log)

## Native Social Login

The info.plist file contains all necessary LSApplicationQueriesSchemes and URLSchemes in order for Google and Facebook to make use of their own native sdk for login. 
The following link describes in more details on configuration present in this project: [Native Login for social providers](https://developers.gigya.com/display/GD/iOS#iOS-ConfiguringNativeLogin)
