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

bool regSwitch, resetPwdSwitch, profCompletion;
NSString *linkReg;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self.loginBtn layer] setBorderWidth:1.0f];
    [[self.loginBtn layer] setBorderColor:[UIColor colorWithRed:(59/255.0) green:(89/255.0) blue:(152/255.0) alpha:1.0].CGColor];
    
    self.loginBtn.frame = CGRectMake(self.loginBtn.frame.origin.x, self.loginBtn.frame.origin.y-60, self.loginBtn.frame.size.width , self.loginBtn.frame.size.height);

    regSwitch = false;
    resetPwdSwitch= false;
    profCompletion = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated  {
    self.errorField.hidden = YES;
}

//Gigya RaaS Flows

-(void)accountsLinkingFlow{
    
}

-(void)passwordResetFlow{
    
}

-(void)profileCompletionFlow{
    
}

-(void)registerFlow{
    
}

-(void)loginFlow{
    
}

-(void)socialLoginFlow{
    
}


-(void)socialLogin:(NSString*)provider{
    self.errorField.hidden = YES;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"saveProfileAndFail" forKey:@"x_conflictHandling"];
   
    NSLog(@"Provider is: %@",provider);
    
    
    [Gigya loginToProvider:provider
                parameters:parameters
                      over:self
         completionHandler:^(GSUser *user, NSError *error) {
             NSLog(@"%ld",error.code);
             if (!error) {
                 // Login was successful
                 NSLog(@"%@",user);
             } else {
                 // Handle errors
                 NSLog(@"%@",error);
                 
                 //profile completion / required fields
                 if(error.code == 206001){
                     profCompletion = YES;
                     
                     //check required fields. In this example, email address is a required field
                     NSString *regToken = error.userInfo[@"regToken"];
                     linkReg = regToken;
                     
                     UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Profile Completion Page" message:@"Please enter your email address:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
                     [av setAlertViewStyle:UIAlertViewStylePlainTextInput];
                     
                     // Alert style customization
                     [[av textFieldAtIndex:0] setPlaceholder:@"Email Address"];
                     [av show];

                 }
                 
                 //account linking
                 if(error.code == 200010 || error.code == 403043){
                    
                     NSString *regToken = error.userInfo[@"regToken"];
                     linkReg = regToken;
                     
                     NSMutableDictionary *params = [NSMutableDictionary dictionary];
                     [params setObject:regToken forKey:@"regToken"];
                     
                     GSRequest *request = [GSRequest requestForMethod:@"accounts.getConflictingAccount" parameters:params];
                     [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
                         if (!error) {
                             NSLog(@"Success - %@",response);
                             // Success! Use the response object.
                             
                             NSDictionary *providers = response[@"conflictingAccount"];
                             NSArray* availableProviders = providers[@"loginProviders"];
                             
                             UIAlertController * alert = [UIAlertController
                                                          alertControllerWithTitle:@"Accounts Linking"
                                                          message:@"You have previously logged in with a different account. To link your accounts, please re-authenticate using the following options:"
                                                          preferredStyle:UIAlertControllerStyleAlert];
                             
                             for (int i = 0; i < availableProviders.count ; i++){
                                 
                                 NSString* prov = [availableProviders objectAtIndex:i];
                                 
                                 if([prov isEqualToString:@"site"]){
                                     UIAlertAction* yesButton = [UIAlertAction
                                                                 actionWithTitle:@"Email/Pwd"
                                                                 style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action) {
                                                                     
                                                                     UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Login with your username and password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
                                                                     [av setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
                                                                     
                                                                     // Alert style customization
                                                                     [[av textFieldAtIndex:1] setSecureTextEntry:YES];
                                                                     [[av textFieldAtIndex:0] setPlaceholder:@"Email Address"];
                                                                     [[av textFieldAtIndex:1] setPlaceholder:@"Password"];
                                                                     [av show];
                                                                     
                                                                     
                                                                 }];
                                     
                                     [alert addAction:yesButton];
                                     
                                 }
                                 else{
                                     UIAlertAction* noButton = [UIAlertAction
                                                                actionWithTitle:prov
                                                                style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * action) {
                                                                    
                                                                    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                                                                    [parameters setObject:@"link" forKey:@"loginMode"];
                                                                    [parameters setObject:regToken forKey:@"regToken"];
                                                                    
                                                                    
                                                                    [Gigya loginToProvider:prov parameters:parameters
                                                                                      over:self
                                                                         completionHandler:^(GSUser * _Nullable user, NSError * _Nullable error) {
                                                                             
                                                                             if(error.code == 200009){
                                                                                 
                                                                                 self.errorField.text = @"Accounts successfully linked.";
                                                                                 self.errorField.hidden = NO;
                                                                                 
                                                                                 [Gigya loginToProvider:provider
                                                                                             parameters:nil
                                                                                                   over:self
                                                                                      completionHandler:^(GSUser *user, NSError *error) {
                                                                                          NSLog(@"%ld",error.code);
                                                                                          if (!error) {
                                                                                              // Login was successful
                                                                                              NSLog(@"%@",user);
                                                                                          }
                                                                                          else {
                                                                                              NSLog(@"error - %@", error.localizedDescription);
                                                                                              self.errorField.text = error.localizedDescription;
                                                                                              self.errorField.hidden = NO;
                                                                                              
                                                                                              // Check the error code according to the GSErrorCode enum, and handle it.
                                                                                          }
                                                                                      }];
                                                                             }
                                                                             
                                                                         }];
                                                                    
                                                                    
                                                                }];
                                     
                                     [alert addAction:noButton];
                                     
                                 }
                                 
                             }
                             
                             
                             
                             
                             [self presentViewController:alert animated:YES completion:nil];

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
                     NSLog(@"error - %@", error.localizedDescription);
                     self.errorField.text = error.localizedDescription;
                     self.errorField.hidden = NO;
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(buttonIndex == 1){
        
        if(profCompletion){
            
            NSString *regToken2 = linkReg;//response[@"regToken"];
            
            NSString *profileData = [NSString stringWithFormat: @"{ 'email' : '%@'  }", [alertView textFieldAtIndex:0].text] ;
            NSString *dataData =  @"{ 'terms' : 'true' }" ;
            
            NSMutableDictionary *userAction2 = [NSMutableDictionary dictionary];
            [userAction2 setObject:profileData forKey:@"profile"];
            [userAction2 setObject:dataData forKey:@"data"];
            [userAction2 setObject:regToken2 forKey:@"regToken"];
            [userAction2 setObject:@"saveProfileAndFail" forKey:@"conflictHandling"];
            
            
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
                            
                            }
                        else {
                            NSLog(@"error - %@", error.localizedDescription);
                            self.errorField.text = error.localizedDescription;
                            self.errorField.hidden = NO;
                            
                            // Check the error code according to the GSErrorCode enum, and handle it.
                        }
                    }];
                }
                if(error.code == 200010 || error.code == 403043){
                    
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    [params setObject:linkReg forKey:@"regToken"];
                    
                    GSRequest *request = [GSRequest requestForMethod:@"accounts.getConflictingAccount" parameters:params];
                    [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
                        if (!error) {
                            NSLog(@"Success - %@",response);
                            // Success! Use the response object.
                            
                            NSDictionary *providers = response[@"conflictingAccount"];
                            NSArray* availableProviders = providers[@"loginProviders"];
                            
                            UIAlertController * alert = [UIAlertController
                                                         alertControllerWithTitle:@"Accounts Linking"
                                                         message:@"You have previously logged in with a different account. To link your accounts, please re-authenticate using the following options:"
                                                         preferredStyle:UIAlertControllerStyleAlert];
                            
                            for (int i = 0; i < availableProviders.count ; i++){
                                
                                NSString* prov = [availableProviders objectAtIndex:i];
                                
                                if([prov isEqualToString:@"site"]){
                                    UIAlertAction* yesButton = [UIAlertAction
                                                                actionWithTitle:@"Email/Pwd"
                                                                style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * action) {
                                                                    
                                                                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Login with your username and password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
                                                                    [av setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
                                                                    
                                                                    // Alert style customization
                                                                    [[av textFieldAtIndex:1] setSecureTextEntry:YES];
                                                                    [[av textFieldAtIndex:0] setPlaceholder:@"Email Address"];
                                                                    [[av textFieldAtIndex:1] setPlaceholder:@"Password"];
                                                                    [av show];
                                                                    
                                                                    
                                                                }];
                                    
                                    [alert addAction:yesButton];
                                    
                                }
                                else{
                                    UIAlertAction* noButton = [UIAlertAction
                                                               actionWithTitle:prov
                                                               style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   
                                                                   NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                                                                   [parameters setObject:@"link" forKey:@"loginMode"];
                                                                   [parameters setObject:linkReg forKey:@"regToken"];
                                                                   
                                                                   
                                                                   [Gigya loginToProvider:prov parameters:parameters
                                                                                     over:self
                                                                        completionHandler:^(GSUser * _Nullable user, NSError * _Nullable error) {
                                                                            
                                                                            if(error.code == 200009){
                                                                                
                                                                                self.errorField.text = @"Accounts successfully linked.";
                                                                                self.errorField.hidden = NO;
                                                                                
//                                                                                [Gigya loginToProvider:provider
//                                                                                            parameters:nil
//                                                                                                  over:self
//                                                                                     completionHandler:^(GSUser *user, NSError *error) {
//                                                                                         NSLog(@"%ld",error.code);
//                                                                                         if (!error) {
//                                                                                             // Login was successful
//                                                                                             NSLog(@"%@",user);
//                                                                                         }
//                                                                                         else {
//                                                                                             NSLog(@"error - %@", error.localizedDescription);
//                                                                                             self.errorField.text = error.localizedDescription;
//                                                                                             self.errorField.hidden = NO;
//                                                                                             
//                                                                                             // Check the error code according to the GSErrorCode enum, and handle it.
//                                                                                         }
//                                                                                     }];
                                                                            }
                                                                            
                                                                        }];
                                                                   
                                                                   
                                                               }];
                                    
                                    [alert addAction:noButton];
                                    
                                }
                                
                            }
                            
                            
                            
                            
                            [self presentViewController:alert animated:YES completion:nil];
                            
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
            profCompletion = NO;
            
        }
        else{
        NSMutableDictionary *userAction = [NSMutableDictionary dictionary];
        [userAction setObject:[alertView textFieldAtIndex:0].text forKey:@"loginID"];
        [userAction setObject:[alertView textFieldAtIndex:1].text forKey:@"password"];
         [userAction setObject:linkReg forKey:@"regToken"];
        
        
        GSRequest *request = [GSRequest requestForMethod:@"accounts.linkAccounts" parameters:userAction];
        [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
            if (!error) {
                NSLog(@"Success - %@",response);
                // Success! Use the response object.
                self.errorField.text = @"Accounts successfully linked.";
                self.errorField.hidden = NO;
                
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
}

@end
