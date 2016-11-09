//
//  GigyaNativeViewController.m
//  MyGigya
//
//  Created by Gheerish Bansoodeb on 06/11/2016.
//  Copyright © 2016 Gheerish Bansoodeb. All rights reserved.
//

#import "GigyaNativeViewController.h"
#import <GigyaSDK/Gigya.h>

@interface GigyaNativeViewController ()

@end

@implementation GigyaNativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)socialLogin:(NSString*)provider{
    
    [Gigya setDontLeaveApp:NO];
    [Gigya loginToProvider:provider];
   //    [userAction setObject:provider forKey:@"provider"];
//    
//    
//    GSRequest *request = [GSRequest requestForMethod:@"socialize.login" parameters:userAction];
//    [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
//        if (!error) {
//            NSLog(@"Success");
//            // Success! Use the response object.
//        }
//        else {
//            NSLog(@"error");
//            // Check the error code according to the GSErrorCode enum, and handle it.
//        }
//    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)nativeTapped:(id)sender {
    self.errorField.hidden = YES;
    
    NSMutableDictionary *userAction = [NSMutableDictionary dictionary];
    [userAction setObject:self.emailField.text forKey:@"loginID"];
    [userAction setObject:self.passwordField.text forKey:@"password"];
    
    
    GSRequest *request = [GSRequest requestForMethod:@"accounts.login" parameters:userAction];
    [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
        if (!error) {
            NSLog(@"Success");
            // Success! Use the response object.
        }
        else {
            NSLog(@"error - %@", error.localizedDescription);
            self.errorField.text = error.localizedDescription;
            self.errorField.hidden = NO;
            
            // Check the error code according to the GSErrorCode enum, and handle it.
        }
    }];

}

- (IBAction)fbTapped:(id)sender {
    [self socialLogin:@"facebook"];
}

- (IBAction)googleTapped:(id)sender {
    [self socialLogin:@"googleplus"];
}

- (IBAction)linkedTapped:(id)sender {
    [self socialLogin:@"linkedin"];
}
@end
