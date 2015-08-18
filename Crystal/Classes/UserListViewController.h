//
//  UserListViewController.h
//  Crystal
//
//  Created by jingame on 2014/09/03.
//  Copyright (c) 2014年 Yusuke Kawashima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface UserListViewController : PFQueryTableViewController
@end


@interface UserCell : PFTableViewCell 
@property (strong, nonatomic) PFObject *user;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *createdAt;
@property (strong, nonatomic) IBOutlet PFImageView *icon;
@end
