//
//  GigyaAccountManagement.m
//  MyGigya
//
//  Created by Gheerish Bansoodeb on 06/11/2016.
//  Copyright © 2016 Gheerish Bansoodeb. All rights reserved.
//

#import "GigyaAccountManagement.h"
#import "AppDelegate.h"
#import "ContentViewController.h"

@implementation GigyaAccountManagement

//Accounts Delegates
- (void)accountDidLogin:(GSAccount *)account{
    NSLog(@"Account Did Login: %@", account);
    app.userAccount = account;
    
    NSLog(@"%@",account.JSONString);
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ContentViewController *myVC = (ContentViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
    [self.landingView presentViewController:myVC animated:YES completion:nil];
    NSLog(@"%@",account);
}

- (void)accountDidLogout{
    NSLog(@"Account Did Logout");
    app.userAccount = nil;
}

//Account state management
-(void)validateGigyaSession{
    
    if ([Gigya isSessionValid]) {
        // Logged in
        // Get user info (if already registerd)
        GSRequest *request = [GSRequest requestForMethod:@"accounts.getAccountInfo"];
        [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
            if (!error) {
                NSLog(@"Account Did Login: %@", response);

                
                NSDictionary *userProfile = response[@"profile"];
                NSString *nickname = userProfile[@"email"];
                // User was logged in

                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Login"
                                              message: [@"User is already logged in: " stringByAppendingString:nickname]
                                              preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* logoutBtn = [UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [Gigya logout];
                    app.userAccount = nil;
                }];
                [alert addAction:logoutBtn];

                UIAlertAction* continueBtn = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ContentViewController *myVC = (ContentViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
                    app.userAccount = (GSAccount *)response;
                    [self.landingView presentViewController:myVC animated:YES completion:nil];

                    }];
                [alert addAction:continueBtn];

                
                [self.landingView presentViewController:alert animated:YES completion:nil];
            }
            else {
                NSLog(@"Got error on getUserInfo: %@", error);
            }
        }];
    }
    else{
        NSLog(@"not valid");
    }
}

@end
