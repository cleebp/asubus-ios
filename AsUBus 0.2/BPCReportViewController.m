//
//  BPCReportViewController.m
//  AsUBus 0.2
//
//  Created by Brian Clee on 6/18/12.
//  Copyright (c) 2012 __asUbus__. All rights reserved.
//
//  <author>Brian Clee</author>
//  <email>bpclee2011@gmail.com</email>
//  <date>2012-06-24</date>
//

#import "BPCReportViewController.h"
#import "BPCAd.h"
#import "Reachability.h"
#import "GAIDictionaryBuilder.h"

@interface BPCReportViewController ()

@end

@implementation BPCReportViewController
@synthesize picker;
@synthesize busses;
@synthesize reportButton;
@synthesize problemTypes;
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
    
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"underPageBackground.png"]];
    
    NSArray *problemArray = [[NSArray alloc] initWithObjects:@"Bus was full", @"Bus was late", @"Bus broke", @"AsUBus error", nil];
    self.problemTypes = problemArray;
    
    NSArray *busArray = [[NSArray alloc] initWithObjects:@"Blue", @"Express", @"Gold", @"Green", @"Orange",
                         @"Pink", @"Pop 105", @"Purple", @"Red", @"Silver", @"State Farm", @"Teal", nil];
    self.busses = busArray;
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal
                                             stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [reportButton setBackgroundImage:stretchableButtonImageNormal
                           forState:UIControlStateNormal];
    
    UIImage *buttonImagePressed = [UIImage imageNamed:@"blueButton.png"];
    UIImage *stretchableButtonImagePressed = [buttonImagePressed
                                              stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [reportButton setBackgroundImage:stretchableButtonImagePressed
                           forState:UIControlStateHighlighted];

}

- (void)viewDidUnload
{
    [self setReportButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.picker = nil;
    self.problemTypes = nil;
    self.busses = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSInteger problemRow = [picker selectedRowInComponent:kProblemComponent];
    NSInteger busRow = [picker selectedRowInComponent:kBusComponent];
    
    NSString *problem = [problemTypes objectAtIndex:problemRow];
    NSString *bus = [busses objectAtIndex:busRow];
    
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)])
    {
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setSelection:)])
    {
        NSDictionary *selection = [NSDictionary dictionaryWithObjectsAndKeys:problem, @"problem", bus, @"bus", nil];
        [destination setValue:selection forKey:@"selection"];
    }
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == kProblemComponent)
    {
        return [self.problemTypes count];
    }
    
    return [self.busses count];
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == kProblemComponent)
    {
        return [self.problemTypes objectAtIndex:row];
    }
    
    return [self.busses objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == kProblemComponent)
    {
        return 170;
    }
    
    return 120;
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

@end
