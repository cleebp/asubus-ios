//
//  BPCReportViewControllerTime.h
//  AsUBus 0.2
//
//  Created by Brian Clee on 10/18/12.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "GAITrackedViewController.h"

@interface BPCReportViewControllerTime : GAITrackedViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *picker;
@property (weak, nonatomic) NSString *problemName;
@property (weak, nonatomic) NSString *routeName;

@property (copy, nonatomic) NSDictionary *selection;
@property (weak, nonatomic) id delegate;

@property (strong, nonatomic) NSMutableArray *adItems;
@property (strong, nonatomic) NSMutableArray *json;
@property (strong, nonatomic) NSTimer *timer;

- (IBAction)mailButtonPressed:(id)sender;

@end
