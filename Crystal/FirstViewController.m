//
//  FirstViewController.m
//  Crystal
//
//  Created by jingame on 2014/09/03.
//  Copyright (c) 2014年 Yusuke Kawashima. All rights reserved.
//

#import "FirstViewController.h"
#import "Parse/Parse.h"
#import "Notifications.h"


@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	PFObject *testObject = [PFObject objectWithClassName:@"TestClass"];
    [testObject setObject:@"tamotamago" forKey:@"name"];
    [testObject save];

	PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:37.77 longitude:-122.41];
	PFObject *placeObject = [PFObject objectWithClassName:@"PlaceObject"];
	[placeObject setObject:point forKey:@"location"];
	[placeObject setObject:@"San Francisco" forKey:@"name"];
	[placeObject saveInBackground];
    

    PFGeoPoint *userGeoPoint = [PFGeoPoint geoPointWithLatitude:37.856965 longitude:-122.483826];
    PFQuery *query = [PFQuery queryWithClassName:@"PlaceObject"];
    [query whereKey:@"location" nearGeoPoint:userGeoPoint withinMiles:10.0];
    NSArray *placeObjects = [query findObjects];
	NSLog([placeObjects description]);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)tappedButton:(id)sender
{

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:ShowMainViewNotification object:nil];

	/*
    if([UIImagePickerController
        isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
	*/
}
 
// select image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0,0,image.size.width,image.size.height);
    [self.view addSubview:imageView];
    // view の背面画像にしてしまう
    [self.view sendSubviewToBack:imageView];
    
    [self dismissViewControllerAnimated:YES completion:nil];

// https://parse.com/tutorials/saving-images
	{
    	NSData   *imageData = UIImagePNGRepresentation(image);
    	PFFile *imageFile = [PFFile fileWithName:@"test.jpg" data:imageData];

[imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error) {
        // Hide old HUD, show completed HUD (see example for code)
        NSLog(@"saved");
        // Create a PFObject around a PFFile and associate it with the current user
        PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
        [userPhoto setObject:imageFile forKey:@"imageFile"];
    	// [suerPhoto save];
             
        [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // [self refresh:nil];
	                NSLog(@"complete");			//
				//
            }
            else{
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    else{
        // [HUD hide:YES];
        // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
} progressBlock:^(int percentDone) {
    // Update your progress spinner here. percentDone will be between 0 and 100.
    // HUD.progress = (float)percentDone/100;
}];


    	// [imageFile save];
	}
    
}
 
// cancel
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
}

@end
