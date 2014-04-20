//
//  BPCMapAnnotation.m
//  AsUBus 0.2
//
//  Created by Brian Clee on 6/19/12.
//  Copyright (c) 2012 __asUbus__. All rights reserved.
//
//  <author>Brian Clee</author>
//  <email>bpclee2011@gmail.com</email>
//  <date>2012-06-24</date>
//

#import "BPCMapAnnotation.h"

@implementation BPCMapAnnotation

@synthesize title;
@synthesize subtitle;
@synthesize coordinate;
@synthesize busId;

-(id)init
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    
    self.title = nil;
    self.subtitle = nil;
    
    return self;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)inCoord
{
    self = [self init];
    self.coordinate = inCoord;
    return self;
}

@end
