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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // [self showVideo];
    [self showGigyaComponent];
}

-(void)viewDidAppear:(BOOL)animated{
//    if(![player isPreparedToPlay]){
//        [player prepareToPlay];
//        [player play];
//
//    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [player stop];
    //player = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Gigya Plugin view integration

-(void)showGigyaComponent{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"Default-RegistrationLogin" forKey:@"screenSet"];
    
    CGRect region = CGRectMake(0, 0, 375, 567);
    
    GSPluginView *pluginView = [[GSPluginView alloc] initWithFrame:region];
   // pluginView.backgroundColor = [UIColor clearColor];
    pluginView.delegate = self;
    [pluginView loadPlugin:@"accounts.screenSet" parameters:params];
    [self.view addSubview:pluginView];
    
//    for(int i=0; i < pluginView.subviews.count ; i++){
//        UIView *thisView = [pluginView.subviews objectAtIndex:i];
//        thisView.backgroundColor = [UIColor clearColor];
//        thisView.opaque = NO;
//    }
    
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

-(void)showVideo{
    
    NSString *thePath =[[NSBundle mainBundle] pathForResource:@"repsol" ofType:@"mp4"];
    
    NSURL *videoUrl = [NSURL fileURLWithPath:thePath];
    player = [[MPMoviePlayerController alloc]  initWithContentURL: videoUrl];
    
    player.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:player.view];
    
    player.scalingMode = MPMovieScalingModeAspectFit;
    player.fullscreen = true;
    player.shouldAutoplay = true;
    player.controlStyle = MPMovieControlStyleNone;
    
    
    [player prepareToPlay];
    [player play];
    
    // app.screenSaverOn = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackComplete:) name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    
}

-(void)moviePlaybackComplete:(NSNotification *)notification {
    [player play];
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
