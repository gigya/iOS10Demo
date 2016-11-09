//
//  AppDelegate.h
//  MyGigya
//
//

#import <UIKit/UIKit.h>
#import <GigyaSDK/Gigya.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) GSAccount *userAccount;


@end

extern AppDelegate *app;
