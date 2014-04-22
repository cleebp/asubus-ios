//
//  BPCViewController.m
//  AsUBus 1.41
//
//  Created by Brian Clee on 6/17/12.
//  Copyright (c) 2014 __asUbus__. All rights reserved.
//
//  <author>Brian Clee</author>
//  <email>cleebp@gmail.com</email>
//  <date>2012-06-24</date>
//

#import "BPCViewController.h"
#import "BPCAd.h"
#import "Reachability.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface BPCViewController ()

@end

@implementation BPCViewController
@synthesize routeButton;
@synthesize favoriteButton;
@synthesize reportButton;
@synthesize appalCartButton;
@synthesize infoButton;
@synthesize background_4inch;
@synthesize background_3inch;
@synthesize adItems;
@synthesize json;
@synthesize timer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"Home";
    
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //NSLog(@"%f", screenBounds.size.height);
    if (screenBounds.size.height == 568)
    {
        background_4inch.hidden = NO;
        background_3inch.hidden = YES;
        background_4inch.layer.zPosition = 0;
        
        routeButton.layer.zPosition = 2;
        favoriteButton.layer.zPosition = 2;
        reportButton.layer.zPosition = 2;
        appalCartButton.layer.zPosition = 2;
        infoButton.layer.zPosition = 2;
        
        
        [routeButton setFrame:CGRectMake(89, 224, 142, 40)];
        [favoriteButton setFrame:CGRectMake(89, 290, 142, 40)];
        [reportButton setFrame:CGRectMake(89, 358, 142, 40)];
        [appalCartButton setFrame:CGRectMake(89, 420, 142, 40)];
    }
    else
    {
        background_4inch.hidden = YES;
        background_3inch.hidden = NO;
        background_3inch.layer.zPosition = 1;
        
        routeButton.layer.zPosition = 2;
        favoriteButton.layer.zPosition = 2;
        reportButton.layer.zPosition = 2;
        appalCartButton.layer.zPosition = 2;
        infoButton.layer.zPosition = 2;
        
        
        [routeButton setFrame:CGRectMake(100, 202, 120, 40)];
        [favoriteButton setFrame:CGRectMake(100, 255, 120, 40)];
        [reportButton setFrame:CGRectMake(100, 310, 120, 40)];
        [appalCartButton setFrame:CGRectMake(100, 370, 120, 40)];
    }
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal
                                             stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [routeButton setBackgroundImage:stretchableButtonImageNormal
                                 forState:UIControlStateNormal];
    [favoriteButton setBackgroundImage:stretchableButtonImageNormal
                           forState:UIControlStateNormal];
    [reportButton setBackgroundImage:stretchableButtonImageNormal
                           forState:UIControlStateNormal];
    [appalCartButton setBackgroundImage:stretchableButtonImageNormal
                            forState:UIControlStateNormal];
    
    UIImage *buttonImagePressed = [UIImage imageNamed:@"blueButton.png"];
    UIImage *stretchableButtonImagePressed = [buttonImagePressed
                                              stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [routeButton setBackgroundImage:stretchableButtonImagePressed
                                 forState:UIControlStateHighlighted];
    [favoriteButton setBackgroundImage:stretchableButtonImagePressed
                           forState:UIControlStateHighlighted];
    [reportButton setBackgroundImage:stretchableButtonImagePressed
                           forState:UIControlStateHighlighted];
    [appalCartButton setBackgroundImage:stretchableButtonImagePressed
                            forState:UIControlStateHighlighted];

    //ad timer
    timer = [NSTimer timerWithTimeInterval:10.0f target:self selector:@selector(initAds:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    //internet?
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
    NSLog(@"\nloading a new ad... on home\n");
    
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


- (void)viewDidUnload
{
    [self setRouteButton:nil];
    [self setFavoriteButton:nil];
    [self setReportButton:nil];
    [self setAppalCartButton:nil];
    [self setInfoButton:nil];
    [super viewDidUnload];
    [self setAdItems:nil];
    // Release any retained subviews of the main view.
}

- (void) viewWillAppear:(BOOL)animated
{
    if (![timer isValid])
    {
        [self viewDidLoad];
    }
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

@end
