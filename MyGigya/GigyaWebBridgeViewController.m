//
//  GigyaWebBridgeViewController.m
//  MyGigya
//
//  Created by Gheerish Bansoodeb on 06/11/2016.
//  Copyright © 2016 Gheerish Bansoodeb. All rights reserved.
//

#import "GigyaWebBridgeViewController.h"
#import <GigyaSDK/Gigya.h>

@interface GigyaWebBridgeViewController ()

@end

@implementation GigyaWebBridgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self webBridgeView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)webBridgeView{
    
    UIWebView *webView=[[UIWebView alloc]initWithFrame:self.view.frame];
   
    
    [GSWebBridge registerWebView:webView delegate:self];
    [webView setDelegate:self];
    
    [NSHTTPCookieStorage sharedHTTPCookieStorage].cookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
    
    NSString *url=@"https://gheerish.gigya-cs.com/raasDemo/test.html";
    
    NSURL *nsurl=[NSURL URLWithString:url];
    
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webView loadRequest:nsrequest];
    [self.view addSubview:webView];
    
    
}

// GIGYA Web View/Web bridge Delegate functionality
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
   // NSLog(@"WebView load URL: %@ \n\n\n",[request URL]);
    
    if ([GSWebBridge handleRequest:request webView:webView]) {
     //    NSLog(@"GSWebBridge URL Request: %@ \n\n\n",[request URL]);
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [GSWebBridge webViewDidStartLoad:webView];
}

- (void)webView:(id)webView receivedJsLog:(NSString *)logType logInfo:(NSDictionary *)logInfo{
    
 //   NSLog(@"receivedJsLog:");
       NSLog(@"%@ - %@", logType, logInfo);
}

- (void)webView:(id)webView receivedPluginEvent:(NSDictionary *)event fromPluginInContainer:(NSString *)containerID{
    NSLog(@"receivedPluginEvent: %@ - %@", containerID, event);
   
}


@end
