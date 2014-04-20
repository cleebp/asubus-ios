//
//  BPCRouteViewController.m
//  AsUBus 0.2
//
//  Created by Brian Clee on 6/19/12.
//  Copyright (c) 2012 __asUbus__. All rights reserved.
//
//  <author>Brian Clee</author>
//  <email>bpclee2011@gmail.com</email>
//  <date>2012-06-24</date>
//

#import "BPCRouteViewController.h"

@interface BPCRouteViewController ()

@end

@implementation BPCRouteViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)])
    {
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setSelection:)])
    {
        NSString *routeName = segue.identifier;
        NSDictionary *selection = [NSDictionary dictionaryWithObjectsAndKeys:routeName, @"routeName", nil];
        [destination setValue:selection forKey:@"selection"];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
