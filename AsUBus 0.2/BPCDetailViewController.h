//BPCDetailViewController.h
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
#import "GAITrackedViewController.h"

@interface BPCDetailViewController : GAITrackedViewController
{
    int minutes;
    int hour;
    int weekday;
    BOOL isPM;
}


@property (strong, nonatomic) NSMutableArray *adItems;
@property (strong, nonatomic) NSMutableArray *json;
@property (strong, nonatomic) NSTimer *timer1;
@property (strong, nonatomic) NSTimer *timer2;

@property (copy, nonatomic) NSDictionary *selection;
@property (copy, nonatomic) NSDictionary *stopInformation;
@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) NSArray *stops;

@property (weak, nonatomic) NSString *route;
//variable used to grab the name and put it in the stopName label
@property (weak, nonatomic) NSString *stopName;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@property (weak, nonatomic) IBOutlet UILabel *stopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *arriveTime;
@property (weak, nonatomic) IBOutlet UILabel *arriveTimeRemaining;
@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;
@property (weak, nonatomic) IBOutlet UITextView *scheduleView;
@property (weak, nonatomic) IBOutlet UILabel *scheduleTimes;

//Time info
@property (weak, nonatomic) NSString *time1String;
@property (weak, nonatomic) NSString *time2String;
@property (weak, nonatomic) NSString *time3String;
@property (weak, nonatomic) NSString *time4String;
@property (weak, nonatomic) NSString *time5String;
@property (weak, nonatomic) NSString *time6String;
@property  NSInteger time1;
@property  NSInteger time2;
@property  NSInteger time3;
@property  NSInteger time4;
@property  NSInteger time5;
@property  NSInteger time6;

- (IBAction)favoriteButtonPressed:(id)sender;
@end
