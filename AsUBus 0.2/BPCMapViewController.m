//BPCMapViewController.m
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

#import "BPCMapViewController.h"
#import "BPCMapAnnotation.h"

@interface BPCMapViewController ()

@end

@implementation BPCMapViewController
@synthesize navBar;
@synthesize selection;
@synthesize delegate;
@synthesize routeString;
@synthesize stops;
@synthesize stopString;

- (void)plotBusPositions
{
    //Removes all current annotations
    for (id<MKAnnotation> annotation in worldView.annotations) 
    {
        [worldView removeAnnotation:annotation];
    }
    
    //Reads something and adds annotations for correct route
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Stops" ofType:@"plist"];
    NSDictionary *stopInfo = [NSDictionary dictionaryWithContentsOfFile:path];
    
    //Grabs the appropriate route
    self.stops = [stopInfo objectForKey:routeString];
    
    //grabs item0 and puts it in stop
    for(NSDictionary *stop in stops)
    {
        NSString *name = [stop objectForKey:@"title"];
        NSString *type = [stop objectForKey:@"subtitle"];
        CLLocationCoordinate2D coord;
        float stopLatitude = [[stop objectForKey:@"latitude"] floatValue];
        float stopLongitude = [[stop objectForKey:@"longitude"] floatValue];
        coord.latitude = stopLatitude;
        coord.longitude = stopLongitude;
        
        //Takes all of that info and puts it in an annotation
        BPCMapAnnotation *annotation = [[BPCMapAnnotation alloc] init];
        annotation.title = name;
        annotation.subtitle = type;
        annotation.coordinate = coord;
        annotation.busId = routeString;
        
        [worldView addAnnotation:annotation];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BPCMapAnnotation class]])
    {
        static NSString *reuseId = @"customAnnotation";
        
        MKAnnotationView *customAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
        if (customAnnotationView == nil)
        {
            customAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
            customAnnotationView.canShowCallout = YES;
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            customAnnotationView.rightCalloutAccessoryView = rightButton;
        }
        
        NSString *pinFile = @"";
        BPCMapAnnotation *annot = (BPCMapAnnotation *)annotation;
        if ([annot.busId isEqualToString:@"Blue Route"])
        {
            pinFile = @"busAnnotBlue";
        }
        else if ([annot.busId isEqualToString:@"Red Route"])
        {
            pinFile = @"busAnnotRed";
        }
        else if ([annot.busId isEqualToString:@"State Farm Route"])
        {
            pinFile = @"busAnnotStock";
        }
        else if ([annot.busId isEqualToString:@"Purple Route"])
        {
            pinFile = @"busAnnotPurple";
        }
        else if ([annot.busId isEqualToString:@"Green Route"])
        {
            pinFile = @"busAnnotGreen";
        }
        else if ([annot.busId isEqualToString:@"Orange Route"])
        {
            pinFile = @"busAnnotOrange";
        }
        else if ([annot.busId isEqualToString:@"Pop 105 Route"])
        {
            pinFile = @"busAnnotStock";
        }
        else if ([annot.busId isEqualToString:@"Express Route"])
        {
            pinFile = @"busAnnotStock";
        }
        else if ([annot.busId isEqualToString:@"Pink Route"])
        {
            pinFile = @"busAnnotPink";
        }
        else if ([annot.busId isEqualToString:@"Gold Route"])
        {
            pinFile = @"busAnnotGold";
        }
        else if ([annot.busId isEqualToString:@"Silver Route"])
        {
            pinFile = @"busAnnotSilver";
        }
        else if ([annot.busId isEqualToString:@"Teal Route"])
        {
            pinFile = @"busAnnotTeal";
        }
        [customAnnotationView setImage: [UIImage imageNamed:pinFile]];
        //UIImageView *leftIconView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:iconFilename]] autorelease];
        //customAnnotationView.leftCalloutAccessoryView = leftIconView;
        
        customAnnotationView.annotation = annotation;
        
        return customAnnotationView; 
    }
    
    return nil; 
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control 
{
    stopString = view.annotation.title;
    [self performSegueWithIdentifier:@"Stop Info" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)])
    {
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setSelection:)])
    {
        NSString *route = routeString;
        NSDictionary *selection1 = [NSDictionary dictionaryWithObjectsAndKeys:route, @"route", stopString, @"stop", nil];
        [destination setValue:selection1 forKey:@"selection"];
    }
}

- (void)findLocation
{
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Could not find locations: %@", error);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) 
    {
        locationManager = [[CLLocationManager alloc] init];
        
        [locationManager setDelegate:self];
        
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    return self;
}

- (void)viewDidLoad
{
    [worldView setDelegate:self];
    [worldView setShowsUserLocation:YES];
    
    MKUserLocation *userLocation;
    CLLocationCoordinate2D loc = [userLocation coordinate];
    float coordLatitude = loc.latitude-36;
    float coordLongitude = loc.longitude+81;
    if ((coordLatitude >= .35 || coordLatitude <= .1) || (coordLongitude >= .76 || coordLongitude <= .5))
    {
        float defaultLatitude = 36.215341;
        float defaultLongitude = -81.67967;
        loc.latitude = defaultLatitude;
        loc.longitude = defaultLongitude;
    }
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
    [worldView setRegion:region animated:YES];
    
    routeString = [selection objectForKey:@"routeName"];
    navBar.title = routeString;
    
    [self plotBusPositions];
}

/**- (void)runningAlert
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit) fromDate:now];
    hour = [components hour];
    minutes = [components minute];
    weekday = [components weekday]; //sunday = 1
    BOOL notRunning = false;
    NSString *msg;
    //NSString *title = [[NSString alloc] initWithFormat: @"%@ is not currently running", routeString];
    NSString *title = @"Alert";
    
    if ([routeString isEqualToString:@"Red Route"])
    {
        msg = [[NSString alloc] initWithFormat: @"Red Route appears to not be running. View operational hours in the news section for more info, and possible exceptions."];
        if (weekday > 1 && weekday < 7)
        {
            if (hour < 7 || hour > 21)
            {
                notRunning = YES;
            }
        }
        else if (weekday == 1)
        {
            if (hour < 16 || hour > 21)
            {
                notRunning = YES;
            }
        }
        else if (weekday == 7)
        {
            if (hour < 8 || hour > 16)
            {
                notRunning = YES;
            }
        }
    }
    else if ([routeString isEqualToString:@"Purple Route"])
    {
        msg = [[NSString alloc] initWithFormat: @"Purple Route appears to not be running. View operational hours in the news section for more info, and possible exceptions."];
        if (weekday > 1 && weekday < 7)
        {
            if (hour < 7 || hour > 20)
            {
                notRunning = YES;
            }
        }
        else
        {
            notRunning = YES;
        }
    }
    else if ([routeString isEqualToString:@"Green Route"])
    {
        msg = [[NSString alloc] initWithFormat: @"Green Route appears to not be running. View operational hours in the news section for more info, and possible exceptions."];
        if (weekday > 1 && weekday < 7)
        {
            if (hour < 7 || hour > 21)
            {
                notRunning = YES;
            }
        }
        else if (weekday == 7)
        {
            if (hour < 9 || hour > 16)
            {
                notRunning = YES;
            }
        }
        else
        {
            notRunning = YES;
        }
    }
    else if ([routeString isEqualToString:@"Pop 105 Route"])
    {
        msg = [[NSString alloc] initWithFormat: @"Pop 105 Route appears to not be running. View operational hours in the news section for more info, and possible exceptions."];
        if (weekday > 1 && weekday < 7)
        {
            if (hour < 7 || hour > 22)
            {
                notRunning = YES;
            }
        }
        else if (weekday == 7)
        {
            if (hour < 9 || hour > 16)
            {
                notRunning = YES;
            }
        }
        else
        {
            notRunning = YES;
        }
    }
    else if ([routeString isEqualToString:@"Orange Route"])
    {
        msg = [[NSString alloc] initWithFormat: @"Orange Route appears to not be running. View operational hours in the news section for more info, and possible exceptions."];
        if (weekday > 1 && weekday < 7)
        {
            if (hour < 7 || hour > 21)
            {
                notRunning = YES;
            }
        }
        else if (weekday == 7)
        {
            if (hour < 9 || hour > 16)
            {
                notRunning = YES;
            }
        }
        else
        {
            notRunning = YES;
        }
    }
    else if ([routeString isEqualToString:@"Blue Route"])
    {
        msg = [[NSString alloc] initWithFormat: @"Blue Route appears to not be running. View operational hours in the news section for more info, and possible exceptions."];
        if (weekday > 1 && weekday < 7)
        {
            if (hour < 7 || hour > 17)
            {
                notRunning = YES;
            }
        }
        else
        {
            notRunning = YES;
        }
    }
    else if ([routeString isEqualToString:@"Express Route"])
    {
        msg = [[NSString alloc] initWithFormat: @"Express Route appears to not be running. View operational hours in the news section for more info, and possible exceptions."];
        if (weekday > 1 && weekday < 7)
        {
            if (hour < 7 || hour > 18)
            {
                notRunning = YES;
            }
        }
        else
        {
            notRunning = YES;
        }
    }
    else if ([routeString isEqualToString:@"Pink Route"])
    {
        msg = [[NSString alloc] initWithFormat: @"Pink Route appears to not be running. View operational hours in the news section for more info, and possible exceptions."];
        if (weekday > 1 && weekday < 7)
        {
            if (hour < 7 || hour > 21)
            {
                notRunning = YES;
            }
        }
        else
        {
            notRunning = YES;
        }
    }
    if ([routeString isEqualToString:@"State Farm Route"])
    {
        msg = [[NSString alloc] initWithFormat: @"State Farm Route appears to not be running. View operational hours in the news section for more info, and possible exceptions."];
        if (weekday > 1 && weekday < 7)
        {
            if (hour < 9 || hour > 21)
            {
                notRunning = YES;
            }
        }
        else if (weekday == 1)
        {
            if (hour == 1 && minutes > 25)
            {
                notRunning = YES;
            }
            else if (hour < 16)
            {
                notRunning = YES;
            }
        }
        else if (weekday == 7)
        {
            if (hour < 9 || hour > 16)
            {
                notRunning = YES;
            }
        }
    }
    else if ([routeString isEqualToString:@"Silver Route"])
    {
        msg = [[NSString alloc] initWithFormat: @"Silver Route appears to not be running. View operational hours in the news section for more info, and possible exceptions."];
        if (weekday > 1 && weekday < 7)
        {
            if (hour < 7 || hour > 21)
            {
                notRunning = YES;
            }
        }
        else
        {
            notRunning = YES;
        }
    }
    else if ([routeString isEqualToString:@"Gold Route"])
    {
        msg = [[NSString alloc] initWithFormat: @"Gold Route appears to not be running. View operational hours in the news section for more info, and possible exceptions."];
        if (weekday > 1 && weekday < 7)
        {
            if (hour < 7 || hour > 21)
            {
                notRunning = YES;
            }
        }
        else if (weekday == 1)
        {
            if (hour < 16 || hour > 21)
            {
                notRunning = YES;
            }
        }
        else
        {
            notRunning = YES;
        }
    }
    if (notRunning)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:title
                              message:msg
                              delegate:self
                              cancelButtonTitle:@"Okay"otherButtonTitles:nil];
        [alert show];
    }
}*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setNavBar:nil];
    self.stops = nil;
}

- (void)dealloc
{
    //tell the location manager to stop sending us messages
    [locationManager setDelegate:nil];
}

@end
