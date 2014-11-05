//BPCMapAnnotation.m
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
