//BPCHoursViewController.m
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

#import "BPCHoursViewController.h"

@interface BPCHoursViewController ()

@end

@implementation BPCHoursViewController
@synthesize selection;
@synthesize routeString;
@synthesize mondayFridayLabel;
@synthesize mondayFridayTimeLabel;
@synthesize saturdaysLabel;
@synthesize saturdaysTimeLabel;
@synthesize sundaysLabel;
@synthesize sundaysTimeLabel;
@synthesize examSaturdaysLabel;
@synthesize limitedScheduleLabel;
@synthesize specialLabel;
@synthesize routeNameLabel;
@synthesize footballTwoLabel;
@synthesize footballFiveTwoLabel;
@synthesize bus1Label;
@synthesize bus2Label;
@synthesize bus3Label;
@synthesize bus2MFLabel;
@synthesize bus2MFTimeLabel;
@synthesize bus3MFLabel;
@synthesize bus3MFTimeLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"underPageBackground.png"]];
    
    routeString = [selection objectForKey:@"routeName"];
    routeNameLabel.text = routeString;
    
    [self initializeComponents];
}

- (void)initializeComponents
{
    [self hideAll];
    
    if ([routeString isEqualToString:@"Green Route"])
    {
        bus1Label.hidden = NO;
        mondayFridayLabel.hidden = NO;
        mondayFridayTimeLabel.hidden = NO;
        mondayFridayTimeLabel.text = @"6:59 AM to 9:58 PM";
        
        saturdaysLabel.hidden = NO;
        saturdaysTimeLabel.hidden = NO;
        saturdaysTimeLabel.text = @"8:59 AM to 5:20 PM";
        
        bus2Label.hidden = NO;
        bus2MFLabel.hidden = NO;
        bus2MFTimeLabel.hidden = NO;
        bus2MFTimeLabel.text = @"7:29 AM to 5:28 PM";
        
        footballTwoLabel.hidden = NO;
        limitedScheduleLabel.hidden = NO;
    }
    else if ([routeString isEqualToString:@"Purple Route"])
    {
        bus1Label.hidden = NO;
        mondayFridayLabel.hidden = NO;
        mondayFridayTimeLabel.hidden = NO;
        mondayFridayTimeLabel.text = @"6:55 AM to 8:14 PM";
        
        bus2Label.hidden = NO;
        bus2MFLabel.hidden = NO;
        bus2MFTimeLabel.hidden = NO;
        bus2MFTimeLabel.text = @"7:40 AM to 5:59 PM";
        
        footballFiveTwoLabel.hidden = NO;
        examSaturdaysLabel.hidden = NO;
    }
    else if ([routeString isEqualToString:@"Red Route"])
    {
        mondayFridayLabel.hidden = NO;
        mondayFridayTimeLabel.hidden = NO;
        mondayFridayTimeLabel.text = @"7:25 AM to 10:00 PM";
        
        saturdaysLabel.hidden = NO;
        saturdaysTimeLabel.hidden = NO;
        saturdaysTimeLabel.text = @"8:25 AM to 5:00 PM";
        
        sundaysLabel.hidden = NO;
        sundaysTimeLabel.hidden = NO;
        sundaysTimeLabel.text = @"3:55 PM to 10:00 PM";
        
        footballTwoLabel.hidden = NO;
        limitedScheduleLabel.hidden = NO;
    }
    else if ([routeString isEqualToString:@"Blue Route"])
    {
        mondayFridayLabel.hidden = NO;
        mondayFridayTimeLabel.hidden = NO;
        mondayFridayTimeLabel.text = @"7:22 AM to 5:49 PM";
        
        footballFiveTwoLabel.hidden = NO;
        specialLabel.hidden = NO;
        specialLabel.text = @"Note: The Football Game Day Shuttle Goes to the Watauga Humane Services Center and Not to Raley Hall. "
            "Drops Off at the Music Building Sidewalk";
    }
    else if ([routeString isEqualToString:@"Express Route"])
    {
        mondayFridayLabel.hidden = NO;
        mondayFridayTimeLabel.hidden = NO;
        mondayFridayTimeLabel.text = @"7:10 AM to 6:23 PM";
    }
    else if ([routeString isEqualToString:@"Pink Route"])
    {
        mondayFridayLabel.hidden = NO;
        mondayFridayTimeLabel.hidden = NO;
        mondayFridayTimeLabel.text = @"6:55 AM to 9:39 PM";
        
        footballFiveTwoLabel.hidden = NO;
        examSaturdaysLabel.hidden = NO;
    }
    else if ([routeString isEqualToString:@"State Farm Route"])
    {
        mondayFridayLabel.hidden = NO;
        mondayFridayTimeLabel.hidden = NO;
        mondayFridayTimeLabel.text = @"9:30 AM to 10:00 PM";
        
        saturdaysLabel.hidden = NO;
        saturdaysTimeLabel.hidden = NO;
        saturdaysTimeLabel.text = @"9:30 AM to 5:00 PM";
        
        sundaysLabel.hidden = NO;
        sundaysTimeLabel.hidden = NO;
        sundaysTimeLabel.text = @"4:00 PM to 1:25 AM";
        
        footballTwoLabel.hidden = NO;
    }
    else if ([routeString isEqualToString:@"Gold Route"])
    {
        mondayFridayLabel.hidden = NO;
        mondayFridayTimeLabel.hidden = NO;
        mondayFridayTimeLabel.text = @"6:55 AM to 9:54 PM";
        
        saturdaysLabel.hidden = NO;
        saturdaysTimeLabel.hidden = NO;
        saturdaysTimeLabel.text = @"4:11 PM to 10:06 PM";
        saturdaysLabel.text = @"Sundays";
        
        specialLabel.hidden = NO;
        specialLabel.text = @"Summer Schedule Monday-Friday from 6:55 AM to 5:27 PM NOTE: After 6:00 PM "
            "Goes Up Bodenheimer Instead of ASU Child Care Center";
    }
    else if ([routeString isEqualToString:@"Orange Route"])
    {
        bus1Label.hidden = NO;
        mondayFridayLabel.hidden = NO;
        mondayFridayTimeLabel.hidden = NO;
        mondayFridayTimeLabel.text = @"7:00 AM to 9:47 PM";
        
        saturdaysLabel.hidden = NO;
        saturdaysTimeLabel.hidden = NO;
        saturdaysTimeLabel.text = @"9:00 AM to 5:00 PM";
        
        bus2Label.hidden = NO;
        bus2MFLabel.hidden = NO;
        bus2MFTimeLabel.hidden = NO;
        bus2MFTimeLabel.text = @"7:15 AM to 5:32 PM";
    }
    else if ([routeString isEqualToString:@"Silver Route"])
    {
        mondayFridayLabel.hidden = NO;
        mondayFridayTimeLabel.hidden = NO;
        mondayFridayTimeLabel.text = @"7:33 AM to 10:03 PM";
    }
    else if ([routeString isEqualToString:@"Pop 105 Route"])
    {
        bus1Label.hidden = NO;
        mondayFridayLabel.hidden = NO;
        mondayFridayTimeLabel.hidden = NO;
        mondayFridayTimeLabel.text = @"7:00 AM to 10:06 PM";
        
        saturdaysLabel.hidden = NO;
        saturdaysTimeLabel.hidden = NO;
        saturdaysTimeLabel.text = @"9:05 AM to 5:06 PM";
        
        bus2Label.hidden = NO;
        bus2MFLabel.hidden = NO;
        bus2MFTimeLabel.hidden = NO;
        bus2MFTimeLabel.text = @"7:15 AM to 5:21 PM";
        
        bus3Label.hidden = NO;
        bus3MFLabel.hidden = NO;
        bus3MFTimeLabel.hidden = NO;
        bus3MFTimeLabel.text = @"7:23 AM to 5:29 PM";
        
        footballTwoLabel.hidden = NO;
    }
    else if ([routeString isEqualToString:@"Teal Route"])
    {
        
    }
}

- (void)hideAll
{
    bus1Label.hidden = YES;
    bus2Label.hidden = YES;
    bus2MFLabel.hidden = YES;
    bus2MFTimeLabel.hidden = YES;
    bus3Label.hidden = YES;
    bus3MFLabel.hidden = YES;
    bus3MFTimeLabel.hidden = YES;
    specialLabel.hidden = YES;
    examSaturdaysLabel.hidden = YES;
    limitedScheduleLabel.hidden = YES;
    footballTwoLabel.hidden = YES;
    footballFiveTwoLabel.hidden = YES;
    mondayFridayLabel.hidden = YES;
    mondayFridayTimeLabel.hidden = YES;
    saturdaysLabel.hidden = YES;
    saturdaysTimeLabel.hidden = YES;
    sundaysLabel.hidden = YES;
    sundaysTimeLabel.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setRouteNameLabel:nil];
    [self setFootballTwoLabel:nil];
    [self setMondayFridayLabel:nil];
    [self setSaturdaysLabel:nil];
    [self setSundaysLabel:nil];
    [self setFootballFiveTwoLabel:nil];
    [self setExamSaturdaysLabel:nil];
    [self setLimitedScheduleLabel:nil];
    [self setMondayFridayTimeLabel:nil];
    [self setSaturdaysTimeLabel:nil];
    [self setSundaysTimeLabel:nil];
    [self setSpecialLabel:nil];
    [self setBus1Label:nil];
    [self setBus2Label:nil];
    [self setBus3Label:nil];
    [self setBus2MFTimeLabel:nil];
    [self setBus3MFLabel:nil];
    [self setBus3MFTimeLabel:nil];
    [self setBus2MFLabel:nil];
    [super viewDidUnload];
}
@end
