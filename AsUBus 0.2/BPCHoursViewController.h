//BPCHoursViewController.h
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

@interface BPCHoursViewController : UIViewController

@property (copy, nonatomic) NSDictionary *selection;
//@property (weak, nonatomic) id delegate;
@property (weak, nonatomic) NSString *routeString;

@property (weak, nonatomic) IBOutlet UILabel *mondayFridayLabel;
@property (weak, nonatomic) IBOutlet UILabel *mondayFridayTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *saturdaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *saturdaysTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sundaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *sundaysTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *examSaturdaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitedScheduleLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialLabel;

@property (weak, nonatomic) IBOutlet UILabel *routeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *footballTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *footballFiveTwoLabel;

@property (weak, nonatomic) IBOutlet UILabel *bus1Label;
@property (weak, nonatomic) IBOutlet UILabel *bus2Label;
@property (weak, nonatomic) IBOutlet UILabel *bus3Label;
@property (weak, nonatomic) IBOutlet UILabel *bus2MFLabel;
@property (weak, nonatomic) IBOutlet UILabel *bus2MFTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bus3MFLabel;
@property (weak, nonatomic) IBOutlet UILabel *bus3MFTimeLabel;

@end
