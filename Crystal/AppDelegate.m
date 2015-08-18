//
//  AppDelegate.m
//  Crystal
//
//  Created by jingame on 2014/09/03.
//  Copyright (c) 2014年 Yusuke Kawashima. All rights reserved.
//

#import "AppDelegate.h"
#import "Notifications.h"


@interface  AppDelegate () {
}
@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

	/*
	// http://qiita.com/yimajo/items/7051af0919b5286aecfe
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	[UINavigationBar appearance].barTintColor = [UIColor colorWithRed:0 green:0.52 blue:0.70 alpha:0.3];
	[UINavigationBar appearance].tintColor = [UIColor whiteColor];
	[UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
	[UITabBar appearance].barTintColor = [UIColor colorWithRed:0.52 green:0.0 blue:0.70 alpha:0.3];
	*/

	// set notification
	{
		__weak typeof(self) weakSelf = self;

		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		NSOperationQueue *queue = [NSOperationQueue mainQueue];
		[center addObserverForName:ShowMainViewNotification object:nil queue:queue usingBlock:^(NSNotification *note) {
			[weakSelf showMainViewController];
    	}];
	}

	[UINavigationBar appearance].barTintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
	[UITabBar appearance].barTintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];

    // Override point for customization after application launch.
    [Parse setApplicationId:@"uyhsOm8R5kFj43oStqvKmJVilhJhuWj8IguoUncz"
                  clientKey:@"5bIhGSrP9WW8i9YjSgYFDOt9DjjDwNN9CtsYaskS"];


	[self loadUserData];
	NSLog(@" # user_id = %@", self.user_id);

	return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)loadUserData {
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	self.user_id = [ud stringForKey:@"user_id"];

	if (!self.user_id) {
		self.user_id = [[NSUUID UUID] UUIDString];
		[self saveUserData];
	}
}

- (void)saveUserData {
	NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
	if (self.user_id) {
  		[ud setObject:self.user_id forKey:@"user_id"];
	}
	[ud synchronize];
}

- (void)showMainViewController
{
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
	UIViewController *mainViewRootViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewRootViewController"];

 	self.window.rootViewController = mainViewRootViewController;

	/*
    // rootViewController差し替え時のトランジション
    __weak typeof(self) weakSelf = self;
    mainViewRootViewController.view.hidden = YES;
    [UIView transitionWithView:self.window
                      duration:0.6f
                       options:UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionShowHideTransitionViews
                    animations:^{
                        mainViewRootViewController.view.hidden = NO;
                    }
                    completion:nil];
	*/
}

@end
