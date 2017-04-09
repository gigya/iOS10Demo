//
//  LandingTabBarController.m
//  MyGigya
//
//  Created by Gheerish Bansoodeb on 06/11/2016.
//  Copyright © 2016 Gheerish Bansoodeb. All rights reserved.
//

#import "LandingTabBarController.h"
#import "GigyaAccountManagement.h"
#import <GigyaSDK/Gigya.h>
#import "ContentViewController.h"

@interface LandingTabBarController ()

@end

@implementation LandingTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GigyaAccountManagement *gigyaAccount = [[GigyaAccountManagement alloc]init];
    gigyaAccount.landingView = self;
    
    //Establish Gigya Accounts wrapper
    [Gigya setAccountsDelegate:gigyaAccount];
    [gigyaAccount validateGigyaSession];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
