//
//  GigyaPluginViewController.m
//  MyGigya
//
//  Created by Gheerish Bansoodeb on 06/11/2016.
//  Copyright © 2016 Gheerish Bansoodeb. All rights reserved.
//

#import "GigyaPluginViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface GigyaPluginViewController ()

@end

@implementation GigyaPluginViewController

UIWebView* webView;
GSPluginView* pluginView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showGigyaComponent];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    for(int i=0; i < pluginView.subviews.count ; i++){
        
        UIView *thisView = [pluginView.subviews objectAtIndex:i];
        
        if([thisView isKindOfClass:[UIWebView class]]){
            webView = thisView;
            [webView setDelegate:self];
        }
    }

}

//Gigya Plugin view integration

-(void)showGigyaComponent{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"Default-RegistrationLogin" forKey:@"screenSet"];
    
    CGRect region = CGRectMake(0, 0, 375, 567);
    
    pluginView = [[GSPluginView alloc] initWithFrame:region];
    pluginView.delegate = self;
    pluginView.showLoginProgress = YES;
    [pluginView loadPlugin:@"accounts.screenSet" parameters:params];
    [self.view addSubview:pluginView];
   
//  GET UNDERLYING WEB-VIEW DISPLAYING THE PLUGIN
    
    
    [self.view addSubview:pluginView];
}

//Plugin Delegates

- (void)pluginView:(GSPluginView *)pluginView firedEvent:(NSDictionary *)event
{
    NSLog(@"Plugin event from %@ - %@", pluginView.plugin, [event objectForKey:@"eventName"]);
}

- (void)pluginView:(GSPluginView *)pluginView finishedLoadingPluginWithEvent:(NSDictionary *)event
{
    NSLog(@"Finished loading plugin: %@", pluginView.plugin);
}

- (void)pluginView:(GSPluginView *)pluginView didFailWithError:(NSError *)error
{
    NSLog(@"Plugin error: %@", [error localizedDescription]);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    if ([GSWebBridge handleRequest:request webView:webView]) {
        
        NSString* url = [[request URL] absoluteString];
        
            if ([url rangeOfString:@"eventName%3Derror"].location != NSNotFound) {
                if ([url rangeOfString:@"User%2520did%2520not%2520allow%2520access%2520to%2520Twitter%2520Accounts"].location != NSNotFound) {
                    NSLog(@"URL Request: %@ \n\n\n",[request URL]);
                    
                    
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"Provider permission denied"
                                                  message:@"Error: User did not allow access to Twitter Accounts.\nIt seems that you have previously denied permission for this app to use Twitter.\nTo re-enable permission, please close the app and open:\nSettings -> Privacy -> Twitter -> and turn on permission for this app."
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                             
                                         }];
                    [alert addAction:ok];

                    
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }
            }
        
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [GSWebBridge webViewDidStartLoad:webView];
}


@end
