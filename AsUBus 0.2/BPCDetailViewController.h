//
//  BPCDetailViewController.h
//  AsUBus 0.2
//
//  Created by Brian Clee on 6/19/12.
//  Copyright (c) 2012 __asUbus__. All rights reserved.
//
//  <author>Brian Clee</author>
//  <email>bpclee2011@gmail.com</email>
//  <date>2012-06-24</date>
//

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
