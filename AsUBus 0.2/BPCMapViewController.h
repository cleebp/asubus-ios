//
//  BPCMapViewController.h
//  AsUBus 0.2
//
//  Created by Brian Clee on 6/17/12.
//  Copyright (c) 2012 __asUbus__. All rights reserved.
//
//  <author>Brian Clee</author>
//  <email>bpclee2011@gmail.com</email>
//  <date>2012-06-24</date>
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface BPCMapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    
    IBOutlet MKMapView *worldView;
    
    int minutes;
    int hour;
    int weekday;
}

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (copy, nonatomic) NSDictionary *selection;
@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) NSArray *stops;
@property (weak, nonatomic) NSString *routeString;
@property (weak, nonatomic) NSString *stopString;

- (void)findLocation;
//- (void)foundLocation:(CLLocation *)loc;

@end
