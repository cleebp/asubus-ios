//
//  BPCTwitterWebViewController.m
//  AsUBus 0.2
//
//  Created by Brian Clee on 3/29/13.
//
//

#import "BPCTwitterWebViewController.h"
#import "Reachability.h"

@interface BPCTwitterWebViewController ()

@end

@implementation BPCTwitterWebViewController

@synthesize tweetView;

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
	self.screenName = @"News";
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(@"There IS NO internet connection");
        NSString *msg = [[NSString alloc] initWithFormat: @"So sorry, but the news feed requires internet connection to view AppalCART's twiiter."];
        NSString *title = [[NSString alloc] initWithFormat: @"No internet connection"];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:title
                              message:msg
                              delegate:self
                              cancelButtonTitle:@"Okay"otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSLog(@"There IS internet connection");
        NSURL *url = [NSURL URLWithString:@"https://mobile.twitter.com/AppalCART/tweets"];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        [tweetView loadRequest:requestObj];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTweetView:nil];
    [super viewDidUnload];
}
@end
