//
//  BPCAboutViewController.m
//  AsUBus 0.2
//
//  Created by Brian Clee on 8/11/12.
//
//

#import "BPCAboutViewController.h"
#import "BPCAd.h"
#import "Reachability.h"
#import "GAIDictionaryBuilder.h"

@interface BPCAboutViewController ()

@end

@implementation BPCAboutViewController
@synthesize adItems;

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
    self.screenName = @"About";
	// Do any additional setup after loading the view.
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(@"There IS NO internet connection");
    }
    else
    {
        NSLog(@"There IS internet connection");
        [self initAds];
    }
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"underPageBackground.png"]];
    
}

- (void)initAds
{
    //ad data
    NSURL *url = [NSURL URLWithString:@"http://asubus.com/ads/adlist.json"];
    NSData * urlData = [NSData dataWithContentsOfURL:url];
    
    NSError * localError;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:&localError];
    
    adItems = [NSMutableArray arrayWithCapacity:999];
    
    if (!localError)
    {
        BPCAd * ad;
        //populate ad object array
        
        for (NSDictionary *dic in json)
        {
            ad = [[BPCAd alloc] init];
            
            //grab all keys
            NSString * promo = (NSString*) [dic valueForKey:@"promo"];
            NSString * image = (NSString*) [dic valueForKey:@"imageURL"];
            NSString * link = (NSString*) [dic valueForKey:@"link"];
            NSURL *imageURL = [NSURL URLWithString:image];
            NSURL *linkURL = [NSURL URLWithString:link];
            
            //create ad object and add to array
            ad.promo = promo;
            ad.imageURL = imageURL;
            ad.linkURL = linkURL;
            [adItems addObject: ad];
        }
        
        int index = arc4random() % [adItems count];
        
        BPCAd *testAd = [adItems objectAtIndex:index];
        
        CGRect imgFrame;
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if (screenBounds.size.height == 568)
        {
            imgFrame = CGRectMake(0, 518, 320, 50);
        }
        else
        {
            imgFrame = CGRectMake(0, 430, 320, 50);
        }
        UIButton *adImage=[[UIButton alloc] initWithFrame:imgFrame];
        NSData * imageData = [NSData dataWithContentsOfURL:testAd.imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        [adImage setBackgroundImage:image forState:UIControlStateNormal];
        [adImage setTag:index];
        [adImage addTarget:self action:@selector(adButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:adImage];
    }
    else
    {
        NSLog(@"CRASH AND BURN");
    }

}

- (void)adButtonPressed:(UIButton *)sender
{
    int index = [sender tag];
    BPCAd * ad = [adItems objectAtIndex:index];
    
    NSString *urlString = [ad.linkURL absoluteString];
    
    // May return nil if a tracker has not already been initialized with a property
    // ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"ad_press"
                                                           label:urlString
                                                           value:nil] build]];
    [[UIApplication sharedApplication] openURL:ad.linkURL];
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

@end
