//
//  BPCHoursViewController.h
//  AsUBus 0.2
//
//  Created by Brian Clee on 8/11/12.
//
//

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
