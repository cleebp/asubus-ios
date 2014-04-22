//
//  BPCAboutViewController.h
//  AsUBus 0.2
//
//  Created by Brian Clee on 8/11/12.
//
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface BPCAboutViewController : GAITrackedViewController

@property (strong, nonatomic) NSMutableArray *adItems;
@property (strong, nonatomic) NSMutableArray *json;
@property (strong, nonatomic) NSTimer *timer;
@end
