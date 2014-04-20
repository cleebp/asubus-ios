//
//  BPCFavoritesViewController.h
//  AsUBus 0.2
//
//  Created by Brian Clee on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface BPCFavoritesViewController : UITableViewController

@property (strong, nonatomic) NSArray *favorites;
@property (weak, nonatomic) NSString *routeString;
@property (weak, nonatomic) NSString *stopString;

@property (strong, nonatomic) NSMutableArray *favoriteItems;
//@property (strong, nonatomic) NSMutableArray *titles;
//@property (strong, nonatomic) NSMutableArray *subtitles;
@end
