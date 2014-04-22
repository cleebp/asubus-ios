//
//  BPCDetailViewController.m
//  AsUBus 0.2
//
//  Created by Brian Clee on 6/19/12.
//  Copyright (c) 2012 __asUbus__. All rights reserved.
//
//  <author>Brian Clee</author>
//  <email>bpclee2011@gmail.com</email>
//  <date>2012-06-24</date>
//

#import "BPCDetailViewController.h"
#import "BPCAd.h"
#import "Reachability.h"
#import "GAIDictionaryBuilder.h"

@interface BPCDetailViewController ()

@end

@implementation BPCDetailViewController
@synthesize adItems;
@synthesize json;
@synthesize timer1;
@synthesize timer2;
//Seg info
@synthesize selection;
@synthesize delegate;
@synthesize route;
@synthesize navBar;
@synthesize stops;
@synthesize stopName;
@synthesize stopInformation;
//Labels
@synthesize stopNameLabel;
@synthesize arriveTime;
@synthesize arriveTimeRemaining;
@synthesize favoritesButton;
@synthesize scheduleView;
@synthesize scheduleTimes;
//Time info
@synthesize time1;
@synthesize time1String;
@synthesize time2;
@synthesize time2String;
@synthesize time3;
@synthesize time3String;
@synthesize time4;
@synthesize time4String;
@synthesize time5;
@synthesize time5String;
@synthesize time6;
@synthesize time6String;

//@synthesize intTimes;
//@synthesize stringTimes;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initializeComponents:(NSTimer*)theTimer
{
    NSLog(@"initializing ish");
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekdayCalendarUnit) fromDate:now];
    weekday = [components weekday];
    hour = [components hour];
    [self checkMilitary];
    minutes = [components minute];
    
    //Reads something and adds annotations for correct route
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Stops" ofType:@"plist"];
    NSDictionary *stopInfo = [NSDictionary dictionaryWithContentsOfFile:path];
    
    //Grabs the appropriate route
    self.stops = [stopInfo objectForKey:route];
    //Grabs the appropriate stop
    for(NSDictionary *stop in stops)
    {
        if ([[stop objectForKey:@"title"] isEqualToString:stopName])
        {
            stopInformation = stop;
            if ([route isEqualToString:@"Blue Route"])
            {
                time1String = [stopInformation objectForKey:@"departs1"];
                time1 = [time1String intValue];
                
                //intTimes.addObject(time1);
                
                time2String = [stopInformation objectForKey:@"departs2"];
                time2 = [time2String intValue];
                time3String = [stopInformation objectForKey:@"departs3"];
                time3 = [time3String intValue];
                
                //intTimes = [NSArray arrayWithObjects: time1, nil];
                
                [self threeStopLoad];
            }
            else if ([route isEqualToString:@"Pop 105 Route"])
            {
                time1String = [stopInformation objectForKey:@"bus1departs1"];
                time1 = [time1String intValue];
                time2String = [stopInformation objectForKey:@"bus1departs2"];
                time2 = [time2String intValue];
                time3String = [stopInformation objectForKey:@"bus2departs1"];
                time3 = [time3String intValue];
                time4String = [stopInformation objectForKey:@"bus2departs2"];
                time4 = [time4String intValue];
                time5String = [stopInformation objectForKey:@"bus3departs1"];
                time5 = [time5String intValue];
                time6String = [stopInformation objectForKey:@"bus3departs2"];
                time6 = [time6String intValue];
                
                [self threeBusSetup];
            }
            else if ([route isEqualToString:@"Orange Route"] || [route isEqualToString:@"Purple Route"])
            {
                //time1 is bus1stop1 and time2 is bus1stop2 etc.
                time1String = [stopInformation objectForKey:@"bus1departs1"];
                time1 = [time1String intValue];
                time2String = [stopInformation objectForKey:@"bus1departs2"];
                time2 = [time2String intValue];
                time3String = [stopInformation objectForKey:@"bus2departs1"];
                time3 = [time3String intValue];
                time4String = [stopInformation objectForKey:@"bus2departs2"];
                time4 = [time4String intValue];
                
                [self twoBusTwoStopSetup];
            }
            else
            {
                time1String = [stopInformation objectForKey:@"departs1"];
                time1 = [time1String intValue];
                time2String = [stopInformation objectForKey:@"departs2"];
                time2 = [time2String intValue];
                
                [self twoStopLoad];
            }
        }
    }  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"Detail";
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"underPageBackground.png"]];
    
    route = [selection objectForKey:@"route"];
    navBar.title = route;
    stopName = [selection objectForKey:@"stop"];
    stopNameLabel.text = stopName;
    
    isPM = NO;
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal
                                             stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [favoritesButton setBackgroundImage:stretchableButtonImageNormal
                            forState:UIControlStateNormal];
    
    UIImage *buttonImagePressed = [UIImage imageNamed:@"blueButton.png"];
    UIImage *stretchableButtonImagePressed = [buttonImagePressed
                                              stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [favoritesButton setBackgroundImage:stretchableButtonImagePressed
                            forState:UIControlStateHighlighted];
    
    timer1 = [NSTimer timerWithTimeInterval:10.0f target:self selector:@selector(initializeComponents:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSRunLoopCommonModes];
    timer2 = [NSTimer timerWithTimeInterval:10.0f target:self selector:@selector(initAds:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSRunLoopCommonModes];
    
    [self initializeScheduleView];
    [scheduleView flashScrollIndicators];
    [self initializeComponents:(NSTimer*)timer1];
    
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
            [self initAds:timer2];
    }
}

- (void)checkMilitary
{
    NSInteger temp = hour;
    if (temp > 12)
    {
        isPM = YES;
        temp = temp-12;
    }
    else if (hour == 12)
    {
        isPM = YES;
    }
    else if (temp == 0)
    {
        temp = 12;
    }
    hour = temp;
}

- (void)addHour
{
    hour++;
    [self checkMilitary];
}

- (void)threeStopLoad
{
    scheduleTimes.text = [NSString stringWithFormat:@"%@, %@, and %@", time1String, time2String, time3String];
    
    if (time1 < 10)
    {
        time1String = [NSString stringWithFormat:@"0%d", time1];
    }
    else
    {
        time1String = [NSString stringWithFormat:@"%d", time1];
    }
    
    if (minutes == time1 || minutes == time2 || minutes == time3)
    {
        arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"NOW!!!"];
        arriveTime.text = [NSString stringWithFormat:@"%d:%d", hour, minutes];
    }
    else if (minutes < time1)
    {
        if (time1-minutes > 1)
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%d%@", (time1-minutes), @" Minutes"];
        }
        else
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"1 Minute"];
        }
        arriveTime.text = [NSString stringWithFormat:@"%d:%@", hour, time1String];
    }
    else if (minutes < time2)
    {
        if (time2-minutes > 1)
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%d%@", (time2-minutes), @" Minutes"];
        }
        else
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"1 Minute"];
        }
        arriveTime.text = [NSString stringWithFormat:@"%d:%@", hour, time2String];
    }
    else if (minutes < time3)
    {
        if (time3-minutes > 1)
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%d%@", (time3-minutes), @" Minutes"];
        }
        else
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"1 Minute"];
        }
        arriveTime.text = [NSString stringWithFormat:@"%d:%@", hour, time3String];
    }
    else
    {
        [self addHour];
        if ((time1+60)-minutes > 1)
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%d%@", ((time1+60)-minutes), @" Minutes"];
        }
        else
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"1 Minute"];
        }
        arriveTime.text = [NSString stringWithFormat:@"%d:%@", (hour), time1String];
    }
}

- (void)fourStopLoad
{
    scheduleTimes.text = [NSString stringWithFormat:@"%@, %@, %@, and %@", time1String, time2String, time3String, time4String];
    if (time1 < 10)
    {
        time1String = [NSString stringWithFormat:@"0%d", time1];
    }
    else
    {
        time1String = [NSString stringWithFormat:@"%d", time1];
    }
    
    if (minutes == time1 || minutes == time2 || minutes == time3 || minutes == time4)
    {
        arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"NOW!!!"];
        arriveTime.text = [NSString stringWithFormat:@"%d:%d", hour, minutes];
    }
    else if (minutes < time1)
    {
        if (time1-minutes > 1)
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%d%@", (time1-minutes), @" Minutes"];
        }
        else
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"1 Minute"];
        }
        arriveTime.text = [NSString stringWithFormat:@"%d:%@", hour, time1String];
    }
    else if (minutes < time2)
    {
        if (time2-minutes > 1)
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%d%@", (time2-minutes), @" Minutes"];
        }
        else
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"1 Minute"];
        }
        arriveTime.text = [NSString stringWithFormat:@"%d:%@", hour, time2String];
    }
    else if (minutes < time3)
    {
        if (time3-minutes > 1)
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%d%@", (time3-minutes), @" Minutes"];
        }
        else
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"1 Minute"];
        }
        arriveTime.text = [NSString stringWithFormat:@"%d:%@", hour, time3String];
    }
    else if (minutes < time4)
    {
        if (time4-minutes > 1)
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%d%@", (time4-minutes), @" Minutes"];
        }
        else
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"1 Minute"];
        }
        arriveTime.text = [NSString stringWithFormat:@"%d:%@", hour, time4String];
    }
    else
    {
        [self addHour];
        if ((time1+60)-minutes > 1)
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%d%@", ((time1+60)-minutes), @" Minutes"];
        }
        else
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"1 Minute"];
        }
        arriveTime.text = [NSString stringWithFormat:@"%d:%@", (hour), time1String];
    }
}

- (void)twoStopLoad
{
    scheduleTimes.text = [NSString stringWithFormat:@"%@ and %@", time1String, time2String];
    if (time1 < 10)
    {
        time1String = [NSString stringWithFormat:@"0%d", time1];
    }
    else
    {
        time1String = [NSString stringWithFormat:@"%d", time1];
    }
    
    if (minutes == time1 || minutes == time2)
    {
        arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"NOW!!!"];
        arriveTime.text = [NSString stringWithFormat:@"%d:%d", hour, minutes];
    }
    else if (minutes < time1)
    {
        if (time1-minutes > 1)
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%d%@", (time1-minutes), @" Minutes"];
        }
        else
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"1 Minute"];
        }
        arriveTime.text = [NSString stringWithFormat:@"%d:%@", hour, time1String];
    }
    else if (minutes < time2)
    {
        if (time2-minutes > 1)
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%d%@", (time2-minutes), @" Minutes"];
        }
        else
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"1 Minute"];
        }
        arriveTime.text = [NSString stringWithFormat:@"%d:%@", hour, time2String];
    }
    else
    {
        [self addHour];
        if ((time1+60)-minutes > 1)
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%d%@", ((time1+60)-minutes), @" Minutes"];
        }
        else
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"1 Minute"];
        }
        arriveTime.text = [NSString stringWithFormat:@"%d:%@", (hour), time1String];
    }
}

- (void)threeBusTwoStopLoad
{
    scheduleTimes.text = [NSString stringWithFormat:@"%@, %@, %@, %@, %@ and %@", time1String, time2String, time3String,
                          time4String, time5String, time6String];
    
    if (time1 < 10)
    {
        time1String = [NSString stringWithFormat:@"0%d", time1];
    }
    else
    {
        time1String = [NSString stringWithFormat:@"%d", time1];
    }
    
    if (minutes == time1 || minutes == time2 || minutes == time3 || minutes == time4 || minutes == time5 || minutes == time6)
    {
        arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"NOW!!!"];
        arriveTime.text = [NSString stringWithFormat:@"%d:%d", hour, minutes];
    }
    else if (minutes < time1)
    {
        if (time1-minutes > 1)
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%d%@", (time1-minutes), @" Minutes"];
        }
        else
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"1 Minute"];
        }
        arriveTime.text = [NSString stringWithFormat:@"%d:%@", hour, time1String];
    }
    else if (minutes < time2)
    {
        if (time2-minutes > 1)
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%d%@", (time2-minutes), @" Minutes"];
        }
        else
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"1 Minute"];
        }
        arriveTime.text = [NSString stringWithFormat:@"%d:%@", hour, time2String];
    }
    else if (minutes < time3)
    {
        if (time3-minutes > 1)
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%d%@", (time3-minutes), @" Minutes"];
        }
        else
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"1 Minute"];
        }
        arriveTime.text = [NSString stringWithFormat:@"%d:%@", hour, time3String];
    }
    else if (minutes < time4)
    {
        if (time4-minutes > 1)
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%d%@", (time4-minutes), @" Minutes"];
        }
        else
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"1 Minute"];
        }
        arriveTime.text = [NSString stringWithFormat:@"%d:%@", hour, time4String];
    }
    else if (minutes < time5)
    {
        if (time5-minutes > 1)
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%d%@", (time5-minutes), @" Minutes"];
        }
        else
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"1 Minute"];
        }
        arriveTime.text = [NSString stringWithFormat:@"%d:%@", hour, time5String];
    }
    else if (minutes < time6)
    {
        if (time6-minutes > 1)
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%d%@", (time6-minutes), @" Minutes"];
        }
        else
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"1 Minute"];
        }
        arriveTime.text = [NSString stringWithFormat:@"%d:%@", hour, time6String];
    }
    else
    {
        [self addHour];
        if ((time1+60)-minutes > 1)
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%d%@", ((time1+60)-minutes), @" Minutes"];
        }
        else
        {
            arriveTimeRemaining.text = [NSString stringWithFormat:@"%@", @"1 Minute"];
        }
        arriveTime.text = [NSString stringWithFormat:@"%d:%@", (hour), time1String];
    }
}

- (void)threeBusSetup
{
    if (weekday > 1 && weekday < 7)
    {
        if (isPM && hour > 5)
        {
            if (hour == 12)
            {
                [self twoBusTwoStopLoad];
            }
            else
            {
                [self twoStopLoad];
        
            }
        }
        else if (isPM && hour == 5 && minutes > 29)
        {
            [self twoStopLoad];
        }
        else if (!isPM && hour < 7)
        {
            [self twoStopLoad];
        }
        else if(!isPM && hour == 7 && minutes < 15)
        {
            [self twoStopLoad];
        }
        else
        {
            [self sortSixTimes];
            [self threeBusTwoStopLoad];
        }
    }
    else
    {
        [self twoStopLoad];
    }
}

- (void)twoBusTwoStopSetup
{
    if ([route isEqualToString:@"Purple Route"])
    {
        //It is monday-friday
        if (weekday > 1 && weekday < 7)
        {
            //Bus 1 is running and bus 2 is not
            if (isPM && hour > 5)
            {
                [self twoStopLoad];
            }
            /*else if(isPM && hour == 5 && minutes > 32)
            {
                [self twoStopLoad];
            }*/
            else if(!isPM && hour < 7)
            {
                [self twoStopLoad];
            }
            else if(!isPM && hour == 7 && minutes < 40)
            {
                [self twoStopLoad];
            }
            else if(hour == 12)
            {
                if (isPM)
                {
                    [self twoBusTwoStopLoad];
                }
                else
                {
                    [self twoStopLoad];
                }
            }
            else
            {
                [self twoBusTwoStopLoad];
            }
        }
        //It is the weekend and only bus1 runs
        else
        {
            [self twoStopLoad];
        }
    }
    else //Orange route
    {
        //It is monday-friday
        if (weekday > 1 && weekday < 7)
        {
            //Bus 1 is running and bus 2 is not
            if (isPM && hour > 5)
            {
                [self twoStopLoad];
            }
            else if(isPM && hour == 5 && minutes > 32)
            {
                [self twoStopLoad];
            }
            else if(!isPM && hour < 7)
            {
                [self twoStopLoad];
            }
            else if(!isPM && hour == 7 && minutes < 15)
            {
                [self twoStopLoad];
            }
            else if(hour == 12)
            {
                if (isPM)
                {
                    [self twoBusTwoStopLoad];
                }
                else
                {
                    [self twoStopLoad];
                }
            }
            else
            {
                [self twoBusTwoStopLoad];
            }
        }
        //It is the weekend and only bus1 runs
        else
        {
            [self twoStopLoad];
        }
    }
}

- (void)twoBusTwoStopLoad
{
    [self sortFourTimes];
    [self fourStopLoad];
}

- (void)initializeScheduleView
{
    if ([route isEqualToString:@"Red Route"])
    {
        scheduleView.text = [NSString stringWithFormat:@"Monday-Friday: 7:25 AM to 10:00 PM (Except Holidays) During Fall and Spring semesters, otherwise ends at 8:00 PM.\nSaturdays: 8:25 AM to 5:00 PM, ASU Home Football Extends for Two Hours After Game Ends.\nSunday (Fall and Spring Semesters): 3:55 PM Until 10:00 PM.\n"];
    }
    else if ([route isEqualToString:@"Green Route"])
    {
        scheduleView.text = [NSString stringWithFormat:@"Bus 1 Monday-Friday: 6:59 AM to 9:58 PM.\nBus 1 Saturdays: 8:55 AM to 5:21 PM.\nLimited Schedule when ASU not in session 6:59 AM to 7:58 PM.\nBus 2 (Fall and Spring Semesters) Monday-Friday: 7:25 AM to 5:20 PM"];
    }
    else if ([route isEqualToString:@"Orange Route"])
    {
        scheduleView.text = [NSString stringWithFormat:@"Bus 1 (Fall and Spring Semesters) Monday-Friday: 7:00 AM to 9:47 PM.\nBus 1 (ASU not in session) Monday-Friday: 7:00 AM to 7:47 PM.\nBus 1 Saturdays: 9:00 AM to 5:00 PM.\nBus 2 (Fall and Spring Semesters) Monday-Friday: 7:15 AM to 5:32 PM"];
    }
    else if ([route isEqualToString:@"Pop 105 Route"])
    {
        scheduleView.text = [NSString stringWithFormat:@"Bus 1 (Fall and Spring Semesters) Monday-Friday: 6:55 AM to 10:06 PM.\nBus 1 (Summer) Monday - Friday: 7:00 AM to 6:28 PM.\nBus 1 Saturdays: 9:05 AM to 5:06 PM, Home Football Games Extend Service Until Two Hours After the Game.\nBus 2 (Fall and Spring Semesters) Monday-Friday: 7:15 AM to 5:21 PM.\nBus 3 (Fall and Spring Semesters) Monday-Friday: 7:23 AM to 5:29 PM."];
    }
    else if ([route isEqualToString:@"Purple Route"])
    {
        scheduleView.text = [NSString stringWithFormat:@"Bus 1 Monday-Friday: 6:55 AM to 8:14 PM. Will Run on Exam Saturdays.\nWill Run on Home Football Saturdays Five Hours Before Game and Continue Until Two Hours After Game Ends.\nBus 2 (Fall and Spring Semesters) Monday-Friday: 7:40 AM to 5:59 PM."];
    }
    else if ([route isEqualToString:@"Blue Route"])
    {
        scheduleView.text = [NSString stringWithFormat:@"Monday-Friday: 7:20 AM to 5:44 PM.\nWill Run on Home Football Saturdays Five Hours Before Game and Continue Until Two Hours After Game Ends."];
    }
    else if ([route isEqualToString:@"Express Route"])
    {
        scheduleView.text = [NSString stringWithFormat:@"Monday-Friday (Fall & Spring Semesters): 7:10 AM to 6:23 PM."];
    }
    else if ([route isEqualToString:@"Pink Route"])
    {
        scheduleView.text = [NSString stringWithFormat:@"Monday-Friday: 6:55 AM to 9:39 PM. Will Run on ASU Exam Saturdays.\nWill Run on Home Football Saturdays Five Hours Before Game and Continue Until Two Hours After Game Ends."];
    }
    else if ([route isEqualToString:@"State Farm Route"])
    {
        scheduleView.text = [NSString stringWithFormat:@"Monday-Friday: 9:30 AM to 10:00 PM.\nSaturday: 9:30 AM to 5:00 PM. ASU Home Football Games Extends Service for Two Hours After Game Ends.\nOperates On the Day Before a School Week Begins (Usually Sunday): 4:00 PM to 1:25 AM."];
    }
    else if ([route isEqualToString:@"Silver Route"])
    {
        scheduleView.text = [NSString stringWithFormat:@"Monday-Friday (Fall and Spring Semesters): 7:33 AM to 10:03 PM.\nMonday-Friday (Summer): 7:33 AM to 6:33 PM."];
    }
    else if ([route isEqualToString:@"Gold Route"])
    {
        scheduleView.text = [NSString stringWithFormat:@"Monday-Friday (Fall and Spring Semesters): 6:55 AM to 9:54 PM.\nDay Before ASU Class Week (Usually Sunday): 4:11 PM to 10:06 PM.\nMonday-Friday (Summer): 6:55 AM to 5:27 PM.\nNote: After 6:00 PM Goes Up Bodenheimer Instead of ASU Child Care Center."];
    }
    else if ([route isEqualToString:@"Teal Route"])
    {
        scheduleView.text = [NSString stringWithFormat:@"Monday-Friday (Fall and Spring Semesters): 7:18 AM to 10:06 PM.\nMonday-Friday (Summer): 7:00 AM to 6:36 PM.\nSaturdays: 9:18 AM to 5:06 PM."];
    }
    else
    {
        scheduleView.text = [NSString stringWithFormat:@"Error loading route schedule."];
    }
}

- (void)sortFourTimes
{
    NSInteger times[4];
    times[0] = time1;
    times[1] = time2;
    times[2] = time3;
    times[3] = time4;
    
    for (NSInteger i = 1; i < 4; i++)
    {
        NSInteger value = times[i];
        NSInteger j;
        for (j = i-1; j >= 0 && times[j] > value; j--)
        {
            times[j + 1] = times[j];
        }
        times[j + 1] = value;
    }
    
    time1 = times[0];
    if (times[0] < 10)
    {
        time1String = [NSString stringWithFormat:@"0%d", time1];
    }
    else
    {
        time1String = [NSString stringWithFormat:@"%d", time1];
    }
    time2 = times[1];
    time2String = [NSString stringWithFormat:@"%d", time2];
    time3 = times[2];
    time3String = [NSString stringWithFormat:@"%d", time3];
    time4 = times[3];
    time4String = [NSString stringWithFormat:@"%d", time4];
}

- (void)sortSixTimes
{
    NSInteger times[6];
    times[0] = time1;
    times[1] = time2;
    times[2] = time3;
    times[3] = time4;
    times[4] = time5;
    times[5] = time6;
    
    for (NSInteger i = 1; i < 6; i++)
    {
        NSInteger value = times[i];
        NSInteger j;
        for (j = i-1; j >= 0 && times[j] > value; j--)
        {
            times[j + 1] = times[j];
        }
        times[j + 1] = value;
    }
    
    time1 = times[0];
    if (times[0] < 10)
    {
        time1String = [NSString stringWithFormat:@"0%d", time1];
    }
    else
    {
        time1String = [NSString stringWithFormat:@"%d", time1];
    }
    time2 = times[1];
    time2String = [NSString stringWithFormat:@"%d", time2];
    time3 = times[2];
    time3String = [NSString stringWithFormat:@"%d", time3];
    time4 = times[3];
    time4String = [NSString stringWithFormat:@"%d", time4];
    time5 = times[4];
    time5String = [NSString stringWithFormat:@"%d", time5];
    time6 = times[5];
    time6String = [NSString stringWithFormat:@"%d", time6];
}

- (void)viewDidUnload
{
    [self setScheduleView:nil];
    [self setScheduleTimes:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.arriveTime = nil;
    self.arriveTimeRemaining = nil;
    self.stopNameLabel = nil;
    self.stopName = nil;
    self.stops = nil;
    self.navBar = nil;
    self.route = nil;
    self.selection = nil;
    self.delegate = nil;
    self.time1String = nil;
    self.time2String = nil;
    self.time3String = nil;
    self.time4String = nil;
    self.time5String = nil;
    self.time6String = nil;
    self.scheduleView = nil;
    self.scheduleTimes = nil;
}

- (IBAction)favoriteButtonPressed:(id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"FavoriteList.plist"];
    //path = [path stringByAppendingPathComponent:@"FavoriteList.plist"];
    
    // If the file doesn't exist in the Documents Folder, copy it.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path])
    {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"FavoriteList" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:path error:nil];
    }
    
    // Load the Property List.
    //NSMutableDictionary *favoriteInfo = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *favorites = [[NSMutableArray alloc] init];
    //favorites = [favoriteInfo objectForKey:@"Favorites"];
    favorites = [NSMutableArray arrayWithContentsOfFile:path];
    
    NSArray *values = [[NSArray alloc] initWithObjects: stopName, route, nil];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"title", @"subtitle", nil];
    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithObjects:values forKeys:keys];
    
    [favorites addObject:item];
    [favorites writeToFile:path atomically:YES];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Added to Favorites"
                                                    message:[NSString stringWithFormat:@"%@ has been added to favorites.", stopName]
                                                   delegate:nil
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)initAds:(NSTimer*)theOtherTimer
{
    NSLog(@"\nloading a new ad... on detail\n");
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewWillAppear:(BOOL)animated
{
    if (![timer1 isValid] || ![timer2 isValid])
    {
        [self viewDidLoad];
    }
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    if ([timer1 isValid] || [timer2 isValid])
    {
        NSLog(@"invalidating detail timers...");
        [timer1 invalidate];
        [timer2 invalidate];
        timer1 = nil;
        timer2 = nil;
    }
    [super viewWillDisappear:animated];
}

@end
