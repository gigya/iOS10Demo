//
//  ContentViewController.m
//  MyGigya
//
//  Created by Gheerish Bansoodeb on 06/11/2016.
//  Copyright © 2016 Gheerish Bansoodeb. All rights reserved.
//

#import "ContentViewController.h"
#import <GigyaSDK/Gigya.h>

GSPluginView *profileView, *commentView, *shareView, *reactView;
UIView *reactionsHolder;
bool pluginShowing;

@interface ContentViewController ()

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pluginShowing = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [NSHTTPCookieStorage sharedHTTPCookieStorage].cookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
    
    NSString *url=@"http://gheerish.gigya-cs.com/raasDemo/content.html";
    
    NSURL *nsurl=[NSURL URLWithString:url];
    
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [GSWebBridge registerWebView:self.webView delegate:self];

    
    [self.webView loadRequest:nsrequest];
}


// GIGYA Web View/Web bridge Delegate functionality
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"WebView load URL: %@ \n\n\n",[request URL]);
    
    if ([GSWebBridge handleRequest:request webView:webView]) {
        // NSLog(@"GSWebBridge URL Request: %@ \n\n\n",[request URL]);
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [GSWebBridge webViewDidStartLoad:webView];
}

- (void)webView:(id)webView receivedJsLog:(NSString *)logType logInfo:(NSDictionary *)logInfo{
    
    NSLog(@"receivedJsLog:");
    //   NSLog(@"%@ - %@", logType, logInfo);
}

- (void)webView:(id)webView receivedPluginEvent:(NSDictionary *)event fromPluginInContainer:(NSString *)containerID{
    NSLog(@"receivedPluginEvent:");
    //   NSLog(@"%@ - %@", containerID, event);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logoutTapped:(id)sender {
    [Gigya logout];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)viewProfileTapped:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"NEW-ProfileUpdate" forKey:@"screenSet"];
    
    profileView = [[GSPluginView alloc] initWithFrame:self.view.frame];
    profileView.delegate = self;
    [profileView loadPlugin:@"accounts.screenSet" parameters:params];
    [self.view addSubview:profileView];

    
}

- (IBAction)commentsTapped:(id)sender {
    
    if(!pluginShowing){
        
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    commentView = [[GSPluginView alloc] initWithFrame:CGRectMake(0,20,375,603)];
    commentView.delegate = self;
    
    [params setObject:@"mobilecomments" forKey:@"categoryID"];
    [params setObject:@"Gigya-iOS-Demos" forKey:@"streamID"];
    [commentView loadPlugin:@"comments.commentsUI" parameters:params];
    [self.view addSubview:commentView];
    
    pluginShowing = YES;
    }
    else{
        [commentView removeFromSuperview];
        commentView = nil;
        pluginShowing = NO;
    }
}

- (IBAction)shareTapped:(id)sender {
    
    
    if(!pluginShowing){
        
        NSMutableDictionary *userAction = [NSMutableDictionary dictionary];
        [userAction setObject:@"AC Milan news" forKey:@"title"];
        //[userAction setObject:@"AC Milan Recent form" forKey:@"subtitle"];
        [userAction setObject:@"AC Milan has been playing spectacular football in recent weeks." forKey:@"description"];
        [userAction setObject:@"http://gheerish.gigya-cs.com/raasDemo/content.html" forKey:@"linkBack"];
        
        reactionsHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 580, 375, 50)];
        reactView = [[GSPluginView alloc] initWithFrame:CGRectMake(0,0,375,50)];
        reactView.delegate = self;
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setObject:userAction forKey:@"userAction"];
        [params setObject:@"Facebook-Like,Twitter-Tweet,googleplus-share,Share,Email" forKey:@"shareButtons"];
        [params setObject:@"true" forKey:@"iconsOnly"];
        [params setObject:@"none" forKey:@"showCounts"];
        
        [reactView loadPlugin:@"socialize.shareBarUI" parameters:params];
        
        [reactionsHolder addSubview:reactView];
        [self.view addSubview:reactionsHolder];
        
        pluginShowing = YES;
    }
    else{
        [reactView removeFromSuperview];
        [reactionsHolder removeFromSuperview];
        reactView = nil;
        pluginShowing = NO;
    }
    

}

- (IBAction)reactTapped:(id)sender {
    if(!pluginShowing){
        
        NSMutableArray *reactions = [NSMutableArray new];
        
        NSMutableDictionary *userAction = [NSMutableDictionary dictionary];
        [userAction setObject:@"Football News" forKey:@"title"];
        [userAction setObject:@"Awesome Article" forKey:@"description"];
        [userAction setObject:@"http://www.gigya.com" forKey:@"linkBack"];
        
        NSMutableDictionary *reaction1 = [NSMutableDictionary dictionary];
        [reaction1 setObject:@"Awesome" forKey:@"text"];
        [reaction1 setObject:@"awesome" forKey:@"ID"];
        [reaction1 setObject:@"https://cdns.gigya.com/gs/i/reactions/icons/Agree_Icon_Up.png" forKey:@"iconImgUp"];
        [reaction1 setObject:@"This is awesome" forKey:@"tooltip"];
        [reaction1 setObject:@"This is awesome!" forKey:@"feedMessage"];
        [reaction1 setObject:@"You think this is awesome " forKey:@"headerText"];
        [reactions addObject:reaction1];
        
        NSMutableDictionary *reaction3 = [NSMutableDictionary dictionary];
        [reaction3 setObject:@"Fresh" forKey:@"text"];
        [reaction3 setObject:@"fresh" forKey:@"ID"];
        [reaction3 setObject:@"https://cdns.gigya.com/gs/i/reactions/icons/Fresh_Icon_Up.png" forKey:@"iconImgUp"];
        [reaction3 setObject:@"This is fresh" forKey:@"tooltip"];
        [reaction3 setObject:@"Fresh!" forKey:@"feedMessage"];
        [reaction3 setObject:@"You think this is fresh " forKey:@"headerText"];
        [reactions addObject:reaction3];
        
        NSMutableDictionary *reaction4 = [NSMutableDictionary dictionary];
        [reaction4 setObject:@"Outrageous" forKey:@"text"];
        [reaction4 setObject:@"outrageous" forKey:@"ID"];
        [reaction4 setObject:@"https://cdns.gigya.com/gs/i/reactions/icons/Outrageous_Icon_Up.png" forKey:@"iconImgUp"];
        [reaction4 setObject:@"This is outrageous" forKey:@"tooltip"];
        [reaction4 setObject:@"Outrageous!" forKey:@"feedMessage"];
        [reaction4 setObject:@"You think this is outrageous " forKey:@"headerText"];
        [reactions addObject:reaction4];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        reactionsHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 530, 375, 90)];
        shareView = [[GSPluginView alloc] initWithFrame:CGRectMake(30,0,345,90)];
        shareView.delegate = self;
        
        [params setObject:@"appBarId" forKey:@"barID"];
        [params setObject:@"id" forKey:@"containerID"];
        [params setObject:@"top" forKey:@"showCounts"];
        [params setObject:@"true" forKey:@"showSuccessMessage"];
        [params setObject:@"true" forKey:@"noButtonBorders"];
        [params setObject:reactions forKey:@"reactions"];
        [params setObject:userAction forKey:@"userAction"];
        
        [shareView loadPlugin:@"socialize.reactionsBarUI" parameters:params];
        
        [reactionsHolder addSubview:shareView];
        [self.view addSubview:reactionsHolder];
        
        pluginShowing = YES;
    }
    else{
        [shareView removeFromSuperview];
        [reactionsHolder removeFromSuperview];
        shareView = nil;
        reactionsHolder = nil;
        pluginShowing = NO;
    }
}

//Plugin Delegates
- (void)pluginView:(GSPluginView *)pluginView firedEvent:(NSDictionary *)event
{
    NSLog(@"Plugin event from %@ - %@", pluginView.plugin, [event objectForKey:@"eventName"]);
    
    if([pluginView.plugin  isEqual: @"accounts.screenSet"] &&  [[event objectForKey:@"eventName"]  isEqual: @"afterSubmit"]){
        [pluginView removeFromSuperview];
        pluginView = nil;
    }
}

- (void)pluginView:(GSPluginView *)pluginView finishedLoadingPluginWithEvent:(NSDictionary *)event
{
    NSLog(@"Finished loading plugin: %@", pluginView.plugin);
}

- (void)pluginView:(GSPluginView *)pluginView didFailWithError:(NSError *)error
{
    NSLog(@"Plugin error: %@", [error localizedDescription]);
}



@end
