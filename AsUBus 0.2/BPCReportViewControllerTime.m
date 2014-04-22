//
//  BPCReportViewControllerTime.m
//  AsUBus 0.2
//
//  Created by Brian Clee on 10/18/12.
//
//

#import "BPCReportViewControllerTime.h"
#import "BPCAd.h"
#import "Reachability.h"
#import "GAIDictionaryBuilder.h"

@interface BPCReportViewControllerTime ()

@end

@implementation BPCReportViewControllerTime
@synthesize reportButton;
@synthesize picker;
@synthesize routeName;
@synthesize problemName;
@synthesize delegate;
@synthesize selection;
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
	self.screenName = @"Report";
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"underPageBackground.png"]];
    
    routeName = [selection objectForKey:@"bus"];
    problemName = [selection objectForKey:@"problem"];
    
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

-(NSString*)getTimetoFill
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"h:mm a"];
    
    NSString *timetofill = [outputFormatter stringFromDate:picker.date];
    return timetofill;
}

- (IBAction)mailButtonPressed:(id)sender
{    
    //Sets the message to be used in the email based on which problem was chosen
    NSString *message;
    message = [[NSString alloc] initWithFormat: @"The following message is formated in order to be processed in a database, if you would like to add a personal message please add it after Notes and do not edit the hash tags.\n\n #Problem: %@ \n #Route: %@ \n #Time of Incident: %@ \n #Notes: ", problemName, routeName, [self getTimetoFill]];
    
    //The following sets up the mail view with the information given by the user input in the picker
    NSArray *recipients;
    
    MFMailComposeViewController *mailComposer;
    mailComposer  = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    if ([problemName isEqualToString:@"AsUBus error"])
    {
        recipients = [[NSArray alloc] initWithObjects:@"report.asubus@gmail.com", nil];
        [mailComposer setSubject:@"AsUBus Issue"];
    }
    else
    {
        recipients = [[NSArray alloc] initWithObjects:@"report.asubus@gmail.com", nil];
        [mailComposer setSubject:@"appalCart Issue"];
    }
    [mailComposer setModalPresentationStyle:UIModalPresentationFormSheet];
    [mailComposer setMessageBody:message isHTML:NO];
    [mailComposer setToRecipients:recipients];
    [self presentViewController:(UIViewController *)mailComposer animated:YES completion:NULL];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    if (error)
    {
        NSLog(@"ERROR - mailComposeController: %@", [error localizedDescription]);
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    return;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initAds:(NSTimer*)theTimer
{
    NSLog(@"\nloading a new ad... on report time\n");
    
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
        NSLog(@"invalidating report time timer...");
        [timer invalidate];
        timer = nil;
    }
    [super viewWillDisappear:animated];
}

@end
