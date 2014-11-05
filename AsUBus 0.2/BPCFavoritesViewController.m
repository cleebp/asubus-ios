//BPCFavoritesViewController.m
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

#import "BPCFavoritesViewController.h"
#import "BPCFavorite.h"
#import "BPCDetailViewController.h"

@interface BPCFavoritesViewController ()

@end

@implementation BPCFavoritesViewController
@synthesize favorites;
@synthesize favoriteItems;
@synthesize routeString;
@synthesize stopString;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initializeComponents
{
    favoriteItems = [NSMutableArray arrayWithCapacity:20];
    BPCFavorite *favorite;
    
    //Reads the favorites plist and adds it to stopInfo
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"FavoriteList" ofType:@"plist"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"FavoriteList.plist"];
    //NSDictionary *stopInfo = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *favoriteInfo = [NSArray arrayWithContentsOfFile:path];
    
    //Grabs the list of favorites
    //self.favorites = [stopInfo objectForKey:@"Favorites"];
    self.favorites = favoriteInfo;
    //Grabs the appropriate stop
    for(NSDictionary *stop in favorites)
    {
        favorite = [[BPCFavorite alloc] init];
        favorite.title = [stop objectForKey:@"title"];
        favorite.subtitle = [stop objectForKey:@"subtitle"];
        [favoriteItems addObject:favorite];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BPCFavorite *favorite = [self.favoriteItems objectAtIndex:indexPath.row];
    
    stopString = favorite.title;
    routeString = favorite.subtitle;
    
    BPCDetailViewController *detailViewController = [[BPCDetailViewController alloc] init];
    
    [detailViewController setStopName:stopString];
    [detailViewController setRoute:routeString];
    
    [self performSegueWithIdentifier:@"favoriteSegue" sender:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[self view] endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self tableView] reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"favoriteSegue"])
    {
        UIViewController *nextViewController = segue.destinationViewController;
        //nextViewController.delegate = self;
        
        NSDictionary *selection1 = [NSDictionary dictionaryWithObjectsAndKeys:routeString, @"route", stopString, @"stop", nil];
        //nextViewController.selection = selection1;
        [nextViewController setValue:selection1 forKey:@"selection"];
    }
}

- (void)viewDidLoad
{
    [self initializeComponents];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.favorites = nil;
    self.routeString = nil;
    self.stopString = nil;
    self.favoriteItems = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [favoriteItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"FavoriteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    //Configure the cell...

    BPCFavorite *favorite = [self.favoriteItems objectAtIndex:indexPath.row];
    
    cell.textLabel.text = favorite.title;
    cell.detailTextLabel.text = favorite.subtitle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"FavoriteList.plist"];
        
        NSMutableArray *plistContents = [NSMutableArray arrayWithContentsOfFile:path];
        [plistContents removeObjectAtIndex:indexPath.row];
        [plistContents writeToFile:path atomically:YES];
        NSLog(@"%@", plistContents);
		[favoriteItems removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

//#pragma mark - Table view delegate



@end
