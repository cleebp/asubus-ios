//BPCAboutViewController.m
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

#import "BPCAboutViewController.h"
#import "BPCAd.h"
#import "Reachability.h"
#import "GAIDictionaryBuilder.h"

@interface BPCAboutViewController ()

@end

@implementation BPCAboutViewController
@synthesize adItems;
@synthesize json;
@synthesize timer;

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
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"underPageBackground.png"]];
    
    timer = [NSTimer timerWithTimeInterval:10.0f target:self selector:@selector(initAds:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(@"There IS NO internet connection");
    }
    else
    {
        NSLog(@"There IS internet connection");
        //ad data
        NSURL *url = [NSURL URLWithString:@"http://asubus.com/ads/adlist.json"];
        NSData * urlData = [NSData dataWithContentsOfURL:url];
        
        NSError * localError;
        json = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:&localError];
        
        adItems = [NSMutableArray arrayWithCapacity:999];
        
        if(!localError)
            [self initAds:timer];
    }
}

- (void)initAds:(NSTimer*)theTimer
{
    NSLog(@"\nloading a new ad... on about\n");
    
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
        
        //handle if url is to open fbook app and app not installed
        if (![[UIApplication sharedApplication] canOpenURL:linkURL])
        {
            linkURL = [NSURL URLWithString:@"https://www.facebook.com/asubusapp?hc_location=timeline"];
        }
        
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
    adImage.layer.zPosition = 2;
    [adImage setBackgroundImage:image forState:UIControlStateNormal];
    [adImage setTag:index];
    [adImage addTarget:self action:@selector(adButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:adImage];
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

- (void) viewWillAppear:(BOOL)animated
{
    if (![timer isValid])
    {
        [self viewDidLoad];
    }
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    if ([timer isValid])
    {
        NSLog(@"invalidating home timer...");
        [timer invalidate];
        timer = nil;
    }
    [super viewWillDisappear:animated];
}

@end
