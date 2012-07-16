//
//  SearchRadiusTableView.m
//  TowerFinder
//
//  Created by Kevin Vinck on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchRadiusTableView.h"


@implementation SearchRadiusTableView

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Search Radius";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    int cellSearchRadius;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"5 km";
            cellSearchRadius = 5;
            break;
        case 1:
            cell.textLabel.text = @"10 km";
            cellSearchRadius = 10;
            break;
        case 2:
            cell.textLabel.text = @"15 km";
            cellSearchRadius = 15;
            break;
        case 3:
            cell.textLabel.text = @"20 km";
            cellSearchRadius = 20;
            break;
        case 4:
            cell.textLabel.text = @"25 km";
            cellSearchRadius = 25;
            break;
        case 5:
            cell.textLabel.text = @"50 km";
            cellSearchRadius = 50;
            break;
        case 6:
            cell.textLabel.text = @"75 km";
            cellSearchRadius = 75;
            break;
        case 7:
            cell.textLabel.text = @"100 km";
            cellSearchRadius = 100;
            break;
        case 8:
            cell.textLabel.text = @"200 km";
            cellSearchRadius = 200;
            break;
        case 9:
            cell.textLabel.text = @"300 km";
            cellSearchRadius = 300;
            break;
            
        default:
            cellSearchRadius = 0;
            break;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int searchRadiusDefault = [[defaults valueForKey:@"searchRadius"] intValue];
    //NSLog(@"Seach Rad: %i, %i",searchRadius, searchRadiusDefault);
    if (cellSearchRadius == searchRadiusDefault) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            searchRadius = 5;
            break;
        case 1:
            searchRadius = 10;
            break;
        case 2:
            searchRadius = 15;
            break;
        case 3:
            searchRadius = 20;
            break;
        case 4:
            searchRadius = 25;
            break;
        case 5:
            searchRadius = 50;
            break;
        case 6:
            searchRadius = 75;
            break;
        case 7:
            searchRadius = 100;
            break;
        case 8:
            searchRadius = 200;
            break;
        case 9:
            searchRadius = 300;
            break;
            
        default:
            break;
    }
    
    NSLog(@"Set search radius to: %i km",searchRadius);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithInt:searchRadius] forKey:@"searchRadius"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
