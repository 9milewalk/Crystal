//
//  FirstViewController.h
//  Crystal
//
//  Created by jingame on 2014/09/03.
//  Copyright (c) 2014年 Yusuke Kawashima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController

- (IBAction)pushedButton:(id)sender;


- (IBAction)onSelectIcon:(id)sender;
- (IBAction)onRegist:(id)sender;

@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UIImageView *iconImageView;

@end
