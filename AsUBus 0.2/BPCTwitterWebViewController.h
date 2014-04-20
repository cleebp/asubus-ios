//
//  BPCTwitterWebViewController.h
//  AsUBus 0.2
//
//  Created by Brian Clee on 3/29/13.
//
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface BPCTwitterWebViewController : GAITrackedViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *tweetView;

@end
