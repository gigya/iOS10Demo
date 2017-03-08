//
//  GigyaNativeViewController.h
//  MyGigya
//
//  Created by Gheerish Bansoodeb on 06/11/2016.
//  Copyright © 2016 Gheerish Bansoodeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface GigyaNativeViewController : UIViewController{
    MPMoviePlayerController *player;
}
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *errorField;
@property (weak, nonatomic) IBOutlet UIView *socialView;
@property (weak, nonatomic) IBOutlet UIView *vidView;
@property (weak, nonatomic) IBOutlet UIView *contView;

- (IBAction)nativeTapped:(id)sender;


@end
