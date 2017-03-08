//
//  CommentsTableViewController.h
//  MyGigya
//
//  Created by Gheerish Bansoodeb on 25/11/2016.
//  Copyright © 2016 Gheerish Bansoodeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GigyaSDK/Gigya.h>

@interface CommentsTableViewController : UITableViewController <GSPluginViewDelegate>
//@property (strong, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UIView *commView;

@end
