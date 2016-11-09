//
//  GigyaPluginViewController.m
//  MyGigya
//
//  Created by Gheerish Bansoodeb on 06/11/2016.
//  Copyright © 2016 Gheerish Bansoodeb. All rights reserved.
//

#import "GigyaPluginViewController.h"

@interface GigyaPluginViewController ()

@end

@implementation GigyaPluginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showGigyaComponent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Gigya Plugin view integration

-(void)showGigyaComponent{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"NEW-RegistrationLogin" forKey:@"screenSet"];
    
    GSPluginView *pluginView = [[GSPluginView alloc] initWithFrame:self.view.frame];
    pluginView.delegate = self;
    [pluginView loadPlugin:@"accounts.screenSet" parameters:params];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
