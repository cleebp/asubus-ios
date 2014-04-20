//
//  BPCMapAnnotation.h
//  AsUBus 0.2
//
//  Created by Brian Clee on 6/19/12.
//  Copyright (c) 2012 __asUbus__. All rights reserved.
//
//  <author>Brian Clee</author>
//  <email>bpclee2011@gmail.com</email>
//  <date>2012-06-24</date>
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BPCMapAnnotation : NSObject <MKAnnotation>
{
    NSString *title;
    NSString *subtitle;
    
    CLLocationCoordinate2D coord;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *busId;

@end
