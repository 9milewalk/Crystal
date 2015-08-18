//
//  MapViewController.h
//  Crystal
//
//  Created by jingame on 2014/09/03.
//  Copyright (c) 2014年 Yusuke Kawashima. All rights reserved.
//

#import "MapViewController.h"

#define METERS_PER_MILE 1609.344
enum PinAnnotationTypeTag {
    PinAnnotationTypeTagGeoPoint = 0,
    PinAnnotationTypeTagGeoQuery = 1
};
@implementation MapViewController 

/*
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
 
    // 緯度・軽度を設定
    CLLocationCoordinate2D location;
    location.latitude = 35.68154;
    location.longitude = 139.752498;
 
    [self.mapView setCenterCoordinate:location animated:NO];
 
    // 縮尺を設定
    MKCoordinateRegion region = self.mapView.region;
    region.center = location;
    region.span.latitudeDelta = 0.02;
    region.span.longitudeDelta = 0.02;
 
    [self.mapView setRegion:region animated:NO];
 
    // 表示タイプを航空写真と地図のハイブリッドに設定
    // self.mapView.mapType = MKMapTypeHybrid;
 
    // view に追加
    // [self.view addSubview:self.mapView];
}
*/

/*
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	[self.mapView removeAnnotations:self.mapView.annotations];

	PFQuery *query = [PFQuery queryWithClassName:@"User"];
	[query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
	
		for (PFObject *comment in comments) {
			NSString *tit = comment[@"titulo"];
			NSString *lat = comment[@"latitud"];
			NSString *lon = comment[@"longitud"];

			float latFloat = [lat floatValue];
			float lonFloat = [lon floatValue];

			CLLocationCoordinate2D Pin;
			Pin.latitude = latFloat;
			Pin.longitude = lonFloat;
            MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
			annotationPoint.coordinate = Pin;
			annotationPoint.title = tit;
			[self.mapView addAnnotation:annotationPoint];
		}

	}];
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];

	// self.navigationController.navigationBar.alpha = 0.1;
	// self.navigationController.navigationBar.tintColor = [UIColor orangeColor];

    //-----set image in navbar-----//
    UIImage *image = [UIImage imageNamed: @"navigation_bar_blue.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"Tour Map";


	/*
	CLLocationCoordinate2D location;
	location.latitude = 35.68154;
	location.longitude = 139.752498;
	*/
	PFGeoPoint *geoPoint = [self.user objectForKey:@"location"];
	CLLocationCoordinate2D location = { geoPoint.latitude, geoPoint.longitude };

    MKCoordinateRegion region = self.mapView.region;
    region.center = location;
    region.span.latitudeDelta = 0.02;	// 0.02;
    region.span.longitudeDelta = 0.02;	// .02;
 
    // [self.mapView setRegion:region animated:NO];

    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
    [_mapView setRegion:adjustedRegion animated:YES];

    [self updateLocations];

    self.mapView.delegate = self;
}


#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *GeoPointAnnotationIdentifier = @"RedPinAnnotation";

    if ([annotation isKindOfClass:[GeoPointAnnotation class]]) {
        MKAnnotationView *annotationView =
        (MKAnnotationView *)[mapView
                                dequeueReusableAnnotationViewWithIdentifier:GeoPointAnnotationIdentifier];

        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc]
                              initWithAnnotation:annotation
                              reuseIdentifier:GeoPointAnnotationIdentifier];
            annotationView.tag = PinAnnotationTypeTagGeoPoint;
            annotationView.canShowCallout = YES;
            // switched from MKPinAnn... to MKAnn...
            //annotationView.pinColor = MKPinAnnotationColorRed;
            //annotationView.animatesDrop = YES;
            annotationView.draggable = NO;

            // Set up the right callout
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            rightButton.frame = CGRectMake(0, 0, 40, 30);
            rightButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
           // [rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];

            [rightButton setImage:[UIImage imageNamed:@"20-circle-east.png"] forState:UIControlStateNormal];
            annotationView.rightCalloutAccessoryView = rightButton;

            //
            // Trying to customize annotationView.image to display image for each GeoPoint loaded from Parse.com
            //
            /*
            MKAnnotationView *view = (MKAnnotationView *)view;
            GeoPointAnnotation *customImage = (GeoPointAnnotation *)view.annotation;
            PFImageView *image = customImage.image;
            NSLog(@"%@",image);
            //annotationView.image = [UIImage imageNamed:@"star.png"];
            */

        }

        return annotationView;
    }

    return nil;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{

    GeoPointAnnotation *link = (GeoPointAnnotation *)view.annotation;
  //  NSString *url = link.url;
  //  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];

}


- (void)setInitialLocation:(CLLocation *)aLocation {
 //   self.location = aLocation;
  //  self.radius = 10000;
}


- (void)updateLocations {

    CGFloat kilometers = 100;

    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query setLimit:1000];
	/*
    [query whereKey:@"gps"
		nearGeoPoint:[PFGeoPoint geoPointWithLatitude:46.252285
                                           longitude:-119.243888]
		withinKilometers:kilometers];
	*/
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                GeoPointAnnotation *geoPointAnnotation = [[GeoPointAnnotation alloc]
                                                          initWithObject:object];
                [self.mapView addAnnotation:geoPointAnnotation];
            }
        }else{
            NSLog(@"Error is: %@", error);
        }
    }];
}

@end











@interface GeoPointAnnotation()
@property (nonatomic, strong) PFObject *object;
@end

@implementation GeoPointAnnotation
@synthesize object = _object;
@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;


#pragma mark - NSObject

- (id)initWithObject:(PFObject *)aObject {
    self = [super init];
    if (self) {
        _object = aObject;
        
        PFGeoPoint *geoPoint = [self.object objectForKey:@"location"];
        [self setGeoPoint:geoPoint];
    }
    return self;
}


#pragma mark - MKAnnotation

// Called when the annotation is dragged and dropped. We update the geoPoint with the new coordinates.
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
    [self setGeoPoint:geoPoint];
    [self.object setObject:geoPoint forKey:@"location"];
    [self.object saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // Send a notification when this geopoint has been updated. MasterViewController will be listening for this notification, and will reload its data when this notification is received.
            [[NSNotificationCenter defaultCenter] postNotificationName:@"geoPointAnnotiationUpdated" object:self.object];
        }
    }];
}


#pragma mark - ()

- (void)setGeoPoint:(PFGeoPoint *)geoPoint {
    _coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    static NSNumberFormatter *numberFormatter = nil;
    if (numberFormatter == nil) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setMaximumFractionDigits:3];
    }
    
	/*
    _title = [dateFormatter stringFromDate:[self.object updatedAt]];
    _subtitle = [NSString stringWithFormat:@"%@, %@", [numberFormatter stringFromNumber:[NSNumber numberWithDouble:geoPoint.latitude]],
                 [numberFormatter stringFromNumber:[NSNumber numberWithDouble:geoPoint.longitude]]];    
	*/
    _title = self.object[@"name"];
    _subtitle = [dateFormatter stringFromDate:[self.object updatedAt]];
}

@end

