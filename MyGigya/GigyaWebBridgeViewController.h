//
//  GigyaWebBridgeViewController.h
//  MyGigya
//
//  Created by Gheerish Bansoodeb on 06/11/2016.
//  Copyright © 2016 Gheerish Bansoodeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GigyaSDK/Gigya.h>

@interface GigyaWebBridgeViewController : UIViewController<GSWebBridgeDelegate,UIWebViewDelegate>
- (IBAction)eu_tapped:(id)sender;
- (IBAction)au_tapped:(id)sender;
- (IBAction)us_tapped:(id)sender;


@end
