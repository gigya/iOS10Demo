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

bool regSwitch, resetPwdSwitch;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self.loginBtn layer] setBorderWidth:1.0f];
    [[self.loginBtn layer] setBorderColor:[UIColor colorWithRed:(59/255.0) green:(89/255.0) blue:(152/255.0) alpha:1.0].CGColor];
    
    self.loginBtn.frame = CGRectMake(self.loginBtn.frame.origin.x, self.loginBtn.frame.origin.y-60, self.loginBtn.frame.size.width , self.loginBtn.frame.size.height);

    regSwitch = false;
    resetPwdSwitch= false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)socialLogin:(NSString*)provider{
    
    //[Gigya setDontLeaveApp:NO];
    
    NSLog(@"Provider is: %@",provider);
    [Gigya loginToProvider:provider
                parameters:nil
                      over:self
         completionHandler:^(GSUser *user, NSError *error) {
             NSLog(@"%ld",error.code);
             if (error.code == 0) {
                 // Login was successful
                 NSLog(@"%@",user);
             } else {
                 // Handle errors
                 NSLog(@"%@",error);
                 
                 //account linking
                 if(error.code == 403043){
                     
                 }
                 
                 
             }
         }];
    
    }



- (IBAction)nativeTapped:(id)sender {
    self.errorField.hidden = YES;
    
    if(!regSwitch && !resetPwdSwitch){
        //Login

        NSMutableDictionary *userAction = [NSMutableDictionary dictionary];
        [userAction setObject:self.emailField.text forKey:@"loginID"];
        [userAction setObject:self.passwordField.text forKey:@"password"];
    
    
        GSRequest *request = [GSRequest requestForMethod:@"accounts.login" parameters:userAction];
        [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
            if (!error) {
                NSLog(@"Success - %@",response);
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
    else if(resetPwdSwitch){
        
        //password reset flow
        
        NSMutableDictionary *userAction = [NSMutableDictionary dictionary];
        [userAction setObject:self.emailField.text forKey:@"loginID"];
        [userAction setObject:self.emailField.text forKey:@"email"];
        
        
        GSRequest *request = [GSRequest requestForMethod:@"accounts.resetPassword" parameters:userAction];
        [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
            if (!error) {
                NSLog(@"Success - %@",response);
                // Success! Use the response object.
                self.errorField.text = @"Please check your email to reset your password";
                self.errorField.hidden = NO;
                
                self.passwordField.hidden= NO;
                self.btnRegister.hidden = NO;
                self.loginBtn.titleLabel.text = @"LOGIN";
                self.forgotPwBtn.hidden = NO;
                resetPwdSwitch = NO;

                
            }
            else {
                NSLog(@"error - %@", error.localizedDescription);
                self.errorField.text = error.localizedDescription;
                self.errorField.hidden = NO;
                
                // Check the error code according to the GSErrorCode enum, and handle it.
            }
        }];

        
    }
    else{
        //Register
        
        NSString *firstName = self.firstNameField.text;
        NSString *lastName = self.lastNameField.text;
        NSString *email= self.emailField.text;
        NSString *password = self.passwordField.text;
        NSString *tnc;
        
        if(self.tncField.on){
            tnc = @"true";
        }
        else{
            tnc = @"false";
        }
        
        GSRequest *request = [GSRequest requestForMethod:@"accounts.initRegistration" parameters:nil];
        [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
            if (!error) {
                NSLog(@"Success - %@",response);
                // Success! Use the response object.
                
                NSString *regToken = response[@"regToken"];
                
                NSMutableDictionary *userAction = [NSMutableDictionary dictionary];
                [userAction setObject:email forKey:@"email"];
                [userAction setObject:password forKey:@"password"];
                [userAction setObject:regToken forKey:@"regToken"];
                
                
                GSRequest *request = [GSRequest requestForMethod:@"accounts.register" parameters:userAction];
                [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
                    if (error.code == GSErrorAccountPendingRegistration) {
                        NSLog(@"Success - %@",response);
                        // Success! Use the response object.
                        
                        //Get new regToken from response as an error was thrown
                        NSString *regToken2 = response[@"regToken"];
                        
                        NSString *profileData = [NSString stringWithFormat: @"{ 'firstName' : '%@' , 'lastName' : '%@' }", firstName, lastName] ;
                        NSString *dataData = [NSString stringWithFormat: @"{ 'terms' : '%@' }", tnc] ;
                        
                        NSMutableDictionary *userAction2 = [NSMutableDictionary dictionary];
                        [userAction2 setObject:profileData forKey:@"profile"];
                        [userAction2 setObject:dataData forKey:@"data"];
                        [userAction2 setObject:regToken2 forKey:@"regToken"];

                        
                        GSRequest *request = [GSRequest requestForMethod:@"accounts.setAccountInfo" parameters:userAction2];
                        [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
                            if (!error) {
                                NSLog(@"Success - %@",response);
                                // Success! Use the response object.
                                
                                NSMutableDictionary *userAction3 = [NSMutableDictionary dictionary];
                                [userAction3 setObject:regToken2 forKey:@"regToken"];
                                
                                GSRequest *request = [GSRequest requestForMethod:@"accounts.finalizeRegistration" parameters:userAction3];
                                [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
                                    if (!error) {
                                        NSLog(@"Success - %@",response);
                                        // Success! Use the response object.
                                        
                                        //Login the user
                                        NSMutableDictionary *userAction4 = [NSMutableDictionary dictionary];
                                        [userAction4 setObject:self.emailField.text forKey:@"loginID"];
                                        [userAction4 setObject:self.passwordField.text forKey:@"password"];
                                        
                                        
                                        GSRequest *request = [GSRequest requestForMethod:@"accounts.login" parameters:userAction4];
                                        [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
                                            if (!error) {
                                                NSLog(@"Success - %@",response);
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
                                    else {
                                        NSLog(@"error - %@", error.localizedDescription);
                                        self.errorField.text = error.localizedDescription;
                                        self.errorField.hidden = NO;
                                        
                                        // Check the error code according to the GSErrorCode enum, and handle it.
                                    }
                                }];
                            }
                            else {
                                NSLog(@"error - %@", error.localizedDescription);
                                self.errorField.text = error.localizedDescription;
                                self.errorField.hidden = NO;
                                
                                // Check the error code according to the GSErrorCode enum, and handle it.
                            }
                        }];
                    }
                    else {
                        NSLog(@"error - %@", error.localizedDescription);
                        self.errorField.text = error.localizedDescription;
                        self.errorField.hidden = NO;
                        
                        // Check the error code according to the GSErrorCode enum, and handle it.
                    }
                }];
            }
            else {
                NSLog(@"error - %@", error.localizedDescription);
                self.errorField.text = error.localizedDescription;
                self.errorField.hidden = NO;
                
                // Check the error code according to the GSErrorCode enum, and handle it.
            }
        }];
    }
    
}

- (IBAction)registerTapped:(id)sender {
    self.errorField.hidden = YES;
    
    if(!regSwitch){
        
        self.firstNameField.hidden = NO;
        self.lastNameField.hidden = NO;
        self.uiSeperator.hidden = NO;
        self.tncField.hidden = NO;
        self.tncLabel.hidden = NO;
        self.forgotPwBtn.hidden = NO;
        
        self.btnRegister.titleLabel.text = @"Have an account already?";
        self.loginBtn.titleLabel.text = @"SIGN";
        
        self.loginBtn.frame = CGRectMake(self.loginBtn.frame.origin.x, self.loginBtn.frame.origin.y+60, self.loginBtn.frame.size.width , self.loginBtn.frame.size.height);
        
        regSwitch = YES;
    }
    else{
        
        self.firstNameField.hidden = YES;
        self.lastNameField.hidden = YES;
        self.uiSeperator.hidden = YES;
        self.tncField.hidden = YES;
        self.tncLabel.hidden = YES;
        self.forgotPwBtn.hidden = YES;
        
        self.btnRegister.titleLabel.text = @"Don't have an account?";
        self.loginBtn.titleLabel.text = @"LOGIN";
        
        self.loginBtn.frame = CGRectMake(self.loginBtn.frame.origin.x, self.loginBtn.frame.origin.y-60, self.loginBtn.frame.size.width , self.loginBtn.frame.size.height);

        regSwitch = NO;
    }
    
}

- (IBAction)forgotPwdTapped:(id)sender {
    
    self.passwordField.hidden= YES;
    self.btnRegister.hidden = YES;
    self.loginBtn.titleLabel.text = @"EMAIL";
    self.forgotPwBtn.hidden = YES;
    
    resetPwdSwitch = YES;
    
}

- (IBAction)twitterTapped:(id)sender {
    [self socialLogin:@"twitter"];
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
