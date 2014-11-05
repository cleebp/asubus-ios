//BPCMapViewController.h
//Copyright (C) 2014  Brian Clee (cleebp AT gmail DOT com)
//
//This program is free software; you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation; either version 2 of the License, or
//(at your option) any later version.
//
//This program is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.
//
//You should have received a copy of the GNU General Public License along
//with this program; if not, write to the Free Software Foundation, Inc.,
//51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

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
