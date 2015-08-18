//
//  FirstViewController.m
//  Crystal
//
//  Created by jingame on 2014/09/03.
//  Copyright (c) 2014年 Yusuke Kawashima. All rights reserved.
//

#import "SettingViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"


@interface SettingViewController ()

@end

@implementation SettingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];

	PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"userId" equalTo:app.user_id];
	[query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object == nil) NSLog(@"%@", error.description);
        NSLog(@"%@", [object objectForKey:@"name"]);
		self.nameField.text = [object objectForKey:@"name"];

		PFFile *file = [object objectForKey:@"icon"];
		[file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
    		if (!error) {
				UIImage *image = [UIImage imageWithData:imageData];
				[self.iconImageView setImage:image]; 
			}
		}];


    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)sender {
	[self.view endEditing:YES];
	return YES;
}

- (void)onRegist:(id)sender
{
	AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];

	if (self.nameField.text) {
	if ([self.nameField.text length] != 0) {

	/*
		PFObject *obj = [PFObject objectWithClassName:@"User"];
		[obj setObject:self.nameField.text forKey:@"name"];
		[obj setObject:app.user_id forKey:@"userId"];
		[obj save];
	*/


/*

	NSData* data = UIImageJPEGRepresentation(self.iconImageView.image, 0.5f);
	PFFile *imageFile = [PFFile fileWithName:@"icon.jpg" data:data];

	[imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (!error) {
			NSLog(@"upload image");


	PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"userId" equalTo:app.user_id];
	[query getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error) {
        if (obj != nil) {

			[obj setObject:self.nameField.text forKey:@"name"];
  			[obj setObject:imageFile forKey:@"icon"];
		    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error1) {
				if (succeeded) {
					NSLog(@"save succedd");
				}
     		}];



		}
    }];



		}
	}];
*/



	NSData* data = UIImageJPEGRepresentation(self.iconImageView.image, 0.5f);
	PFFile *imageFile = [PFFile fileWithName:@"icon.jpg" data:data];

	[imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (!error) {
			NSLog(@"upload image");
		}
	}];

	PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"userId" equalTo:app.user_id];
	[query getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error) {

		if (obj == nil) {
			obj = [PFObject objectWithClassName:@"User"];
		}

		{
			[obj setObject:self.nameField.text forKey:@"name"];
			if (imageFile) {
  				[obj setObject:imageFile forKey:@"icon"];
			} else {
  				[obj removeObjectForKey:@"icon"];
			}
		    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error1) {
				if (succeeded) {
					NSLog(@"save succedd");
				}
     		}];

	[PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
		if (!error) {
			// do something with the new geoPoint
  			[obj setObject:geoPoint forKey:@"location"];
		    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error1) {
				if (succeeded) {
					NSLog(@"loc save succedd");
				}
     		}];

    	}
	}];


		}
    }];





	}
	}

}


- (IBAction)onSelectIcon:(id)sender;
{
    if([UIImagePickerController
        isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
 
// select image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	/*
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0,0,image.size.width,image.size.height);
    [self.view addSubview:imageView];
    // view の背面画像にしてしまう
    [self.view sendSubviewToBack:imageView];
	*/



CGImageRef imageRef = [image CGImage];
size_t w = CGImageGetWidth(imageRef);
size_t h = CGImageGetHeight(imageRef);
size_t resize_w, resize_h;

if (w>h) {
    resize_w = 100;
    resize_h = h * resize_w / w;
} else {
    resize_h = 100;
    resize_w = w * resize_h / h;
}

UIGraphicsBeginImageContext(CGSizeMake(resize_w, resize_h));
[image drawInRect:CGRectMake(0, 0, resize_w, resize_h)];
image = UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext();


	[self.iconImageView setImage:image]; 
    [self dismissViewControllerAnimated:YES completion:nil];


	/*
	// https://parse.com/tutorials/saving-images
	{
    	NSData *imageData = UIImagePNGRepresentation(image);
    	PFFile *imageFile = [PFFile fileWithName:@"icon.png" data:imageData];

		[imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (!error) {
		// Hide old HUD, show completed HUD (see example for code)
			NSLog(@"saved");

			// Create a PFObject around a PFFile and associate it with the current user
			PFObject *obj = [PFObject objectWithClassName:@"User"];
			[obj setObject:imageFile forKey:@"icon"];
			// [suerPhoto save];

			[obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			if (!error) {
				NSLog(@"complete");			//
				//
			} else {
				// Log details of the failure
				NSLog(@"Error: %@ %@", error, [error userInfo]);
			}
			}];
    	} else {
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
    
	*/
}
 
// cancel
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}



/*

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
    if([UIImagePickerController
        isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
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
*/

@end
