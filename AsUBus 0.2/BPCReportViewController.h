//
//  BPCReportViewController.h
//  AsUBus 0.2
//
//  Created by Brian Clee on 6/18/12.
//  Copyright (c) 2012 __asUbus__. All rights reserved.
//
//  <author>Brian Clee</author>
//  <email>bpclee2011@gmail.com</email>
//  <date>2012-06-24</date>
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#define kProblemComponent   0
#define kBusComponent       1

@interface BPCReportViewController : UIViewController <MFMailComposeViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) NSArray *problemTypes;
@property (strong, nonatomic) NSArray *busses;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;

@property (strong, nonatomic) NSMutableArray *adItems;
@end
