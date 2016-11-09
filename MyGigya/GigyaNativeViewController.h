//
//  GigyaNativeViewController.h
//  MyGigya
//
//  Created by Gheerish Bansoodeb on 06/11/2016.
//  Copyright © 2016 Gheerish Bansoodeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GigyaNativeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *errorField;
@property (weak, nonatomic) IBOutlet UIView *socialView;

- (IBAction)nativeTapped:(id)sender;


@end
