//
//  FCCSearchTableView.m
//  TowerFinder
//
//  Created by Kevin Vinck on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FCCSearchTableView.h"


@implementation FCCSearchTableView

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTV {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        searchType = 0;
        self.title = @"TV Stations";
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                       target:self
                                                                                       action:@selector(refreshList)];
        self.navigationItem.rightBarButtonItem = refreshButton;
        gettingTVstations = NO;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        dataArray = [defaults objectForKey:@"lastTVSearch"];
        [defaults setInteger:0 forKey:@"lastSearchType"];
        alreadyUpdated = NO;
        CLController = [[CoreLocationController alloc] init];
        CLController.delegate = self;
        if (dataArray == nil) {
            gettingTVstations = YES;
            [CLController.locMgr startUpdatingLocation];
        }
    }
    return self;
}

- (id)initWithFM {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        searchType = 1;
        self.title = @"FM Stations";
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                       target:self
                                                                                       action:@selector(refreshList)];
        self.navigationItem.rightBarButtonItem = refreshButton;
        alreadyUpdated = NO;
        gettingTVstations = NO;
        CLController = [[CoreLocationController alloc] init];
        CLController.delegate = self;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        dataArray = [defaults objectForKey:@"lastFMSearch"];
        [defaults setInteger:1 forKey:@"lastSearchType"];
        alreadyUpdated = NO;
        CLController = [[CoreLocationController alloc] init];
        CLController.delegate = self;
        if (dataArray == nil) {
            gettingTVstations = YES;
            [CLController.locMgr startUpdatingLocation];
        }
    }
    return self;
}

- (id)initWithAM {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        searchType = 2;
        self.title = @"AM Stations";
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                       target:self
                                                                                       action:@selector(refreshList)];
        self.navigationItem.rightBarButtonItem = refreshButton;
        alreadyUpdated = NO;
        gettingTVstations = NO;
        CLController = [[CoreLocationController alloc] init];
        CLController.delegate = self;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        dataArray = [defaults objectForKey:@"lastAMSearch"];
        [defaults setInteger:2 forKey:@"lastSearchType"];
        alreadyUpdated = NO;
        CLController = [[CoreLocationController alloc] init];
        CLController.delegate = self;
        if (dataArray == nil) {
            gettingTVstations = YES;
            [CLController.locMgr startUpdatingLocation];
        }
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
    alreadyUpdated = NO;
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

- (void)refreshList {
    NSLog(@"Freshin' the list!");
    alreadyUpdated = NO;
    gettingTVstations = YES;
    [CLController.locMgr startUpdatingLocation];
    
}

- (void)locationUpdate:(CLLocation *)location {
    if (alreadyUpdated == NO) {
        [CLController.locMgr stopUpdatingLocation];
        currentLoc = CLController.currentLocation;
        NSLog(@"Got current location: %@",currentLoc);
        [self getTVStationsForLocation:currentLoc];
        alreadyUpdated = YES;
    }
}

- (void)locationError:(NSError *)error {
	NSLog(@"Location error: %@",error);
}

-(void)parseFCCData:(NSString *)data {
    NSArray *rawArray = [data componentsSeparatedByString:@"|"];
    NSLog(@"Raw data: %@",rawArray);
    dataArray = [NSMutableArray arrayWithCapacity:1];
    if (searchType == 0) {
        int numStations = ([rawArray count] - 1) / 39;
        NSLog(@"Stations found: %i",numStations);
        
        for (int x = 0; x < numStations; x++) {
            int latSign,lonSign;
            float lat,lon;
            
            
            NSMutableDictionary *station = [NSMutableDictionary dictionaryWithCapacity:3];
            NSString *stationName = [[rawArray objectAtIndex:((x*39)+1)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [station setValue:stationName forKey:@"stationName"];
            NSString *latSignS = [[rawArray objectAtIndex:((x*39)+19)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *lonSignS = [[rawArray objectAtIndex:((x*39)+23)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *latDegS = [[rawArray objectAtIndex:((x*39)+20)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *latMinS = [[rawArray objectAtIndex:((x*39)+21)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *latSecS = [[rawArray objectAtIndex:((x*39)+22)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *lonDegS = [[rawArray objectAtIndex:((x*39)+24)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *lonMinS = [[rawArray objectAtIndex:((x*39)+25)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *lonSecS = [[rawArray objectAtIndex:((x*39)+26)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if ([latSignS isEqualToString:@"S"])
                latSign = -1;
            else latSign = 1;
            if ([lonSignS isEqualToString:@"W"])
                lonSign = -1;
            else lonSign = 1;
            
            lat = ([latDegS doubleValue] + ([latMinS doubleValue] / 60.0) + (([latSecS doubleValue] / 60.0) / 60.0)) * latSign;
            lon = ([lonDegS doubleValue] + ([lonMinS doubleValue] / 60.0) + (([lonSecS doubleValue] / 60.0) / 60.0)) * lonSign;
            [station setValue:[NSNumber numberWithFloat:lat] forKey:@"latitude"];
            [station setValue:[NSNumber numberWithFloat:lon] forKey:@"longitude"];
            
            NSString *channel = [[rawArray objectAtIndex:((x*39)+4)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *power = [[rawArray objectAtIndex:((x*39)+14)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *psip = [[rawArray objectAtIndex:((x*39)+38)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            [station setValue:channel forKey:@"channel"];
            [station setValue:power forKey:@"power"];
            [station setValue:psip forKey:@"psip"];
            [dataArray addObject:station];
            NSLog(@"Station: %@",station);
        }
    } else if (searchType == 1) {
        int numStations = ([rawArray count] - 1) / 38;
        NSLog(@"Stations found: %i",numStations);
        
        for (int x = 0; x < numStations; x++) {
            int latSign,lonSign;
            float lat,lon;
            
            
            NSMutableDictionary *station = [NSMutableDictionary dictionaryWithCapacity:3];
            NSString *stationName = [[rawArray objectAtIndex:((x*38)+1)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [station setValue:stationName forKey:@"stationName"];
            NSString *latSignS = [[rawArray objectAtIndex:((x*38)+19)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *lonSignS = [[rawArray objectAtIndex:((x*38)+23)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *latDegS = [[rawArray objectAtIndex:((x*38)+20)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *latMinS = [[rawArray objectAtIndex:((x*38)+21)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *latSecS = [[rawArray objectAtIndex:((x*38)+22)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *lonDegS = [[rawArray objectAtIndex:((x*38)+24)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *lonMinS = [[rawArray objectAtIndex:((x*38)+25)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *lonSecS = [[rawArray objectAtIndex:((x*38)+26)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if ([latSignS isEqualToString:@"S"])
                latSign = -1;
            else latSign = 1;
            if ([lonSignS isEqualToString:@"W"])
                lonSign = -1;
            else lonSign = 1;
            
            lat = ([latDegS doubleValue] + ([latMinS doubleValue] / 60.0) + (([latSecS doubleValue] / 60.0) / 60.0)) * latSign;
            lon = ([lonDegS doubleValue] + ([lonMinS doubleValue] / 60.0) + (([lonSecS doubleValue] / 60.0) / 60.0)) * lonSign;
            [station setValue:[NSNumber numberWithFloat:lat] forKey:@"latitude"];
            [station setValue:[NSNumber numberWithFloat:lon] forKey:@"longitude"];
            
            NSString *frequency = [[rawArray objectAtIndex:((x*38)+2)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *power = [[rawArray objectAtIndex:((x*38)+14)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            [station setValue:frequency forKey:@"frequency"];
            [station setValue:power forKey:@"power"];
            [dataArray addObject:station];
            NSLog(@"Station: %@",station);
        }

    } else if (searchType == 2) {
        int numStations = ([rawArray count] - 8) / 36;
        NSLog(@"Stations found: %i",numStations);
        
        for (int x = 0; x < numStations; x++) {
            int latSign,lonSign;
            float lat,lon;
            
            
            NSMutableDictionary *station = [NSMutableDictionary dictionaryWithCapacity:3];
            NSString *stationName = [[rawArray objectAtIndex:((x*32)+1)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [station setValue:stationName forKey:@"stationName"];
            NSString *latSignS = [[rawArray objectAtIndex:((x*32)+19)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *lonSignS = [[rawArray objectAtIndex:((x*32)+23)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *latDegS = [[rawArray objectAtIndex:((x*32)+20)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *latMinS = [[rawArray objectAtIndex:((x*32)+21)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *latSecS = [[rawArray objectAtIndex:((x*32)+22)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *lonDegS = [[rawArray objectAtIndex:((x*32)+24)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *lonMinS = [[rawArray objectAtIndex:((x*32)+25)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *lonSecS = [[rawArray objectAtIndex:((x*32)+26)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if ([latSignS isEqualToString:@"S"])
                latSign = -1;
            else latSign = 1;
            if ([lonSignS isEqualToString:@"W"])
                lonSign = -1;
            else lonSign = 1;
            
            lat = ([latDegS doubleValue] + ([latMinS doubleValue] / 60.0) + (([latSecS doubleValue] / 60.0) / 60.0)) * latSign;
            lon = ([lonDegS doubleValue] + ([lonMinS doubleValue] / 60.0) + (([lonSecS doubleValue] / 60.0) / 60.0)) * lonSign;
            [station setValue:[NSNumber numberWithFloat:lat] forKey:@"latitude"];
            [station setValue:[NSNumber numberWithFloat:lon] forKey:@"longitude"];
            
            NSString *frequency = [[rawArray objectAtIndex:((x*32)+2)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *power = [[rawArray objectAtIndex:((x*32)+14)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            [station setValue:frequency forKey:@"frequency"];
            [station setValue:power forKey:@"power"];
            [dataArray addObject:station];
            NSLog(@"Station: %@",station);
        }
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dataArray forKey:@"lastTowerSearch"];
    if (searchType == 0)
        [defaults setObject:dataArray forKey:@"lastTVSearch"];
    else if (searchType == 1)
        [defaults setObject:dataArray forKey:@"lastFMSearch"];
    else if (searchType == 2)
        [defaults setObject:dataArray forKey:@"lastAMSearch"];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void) receivedData:(NSData *)data {
    gettingTVstations = NO;
    NSString *page = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
    [self parseFCCData:page];
}

-(void)getTVStationsForLocation:(CLLocation *)location {
    NSLog(@"Getting TV stations...");
    gettingTVstations = YES;
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    float signLat;
    float signLong;
    int latDeg;
    int latMin;
    double latSec;
    int longDeg;
    int longMin;
    double longSec;
    
    if (location.coordinate.latitude < 0)
        signLat = -1.0;
    else
        signLat = 1.0;
    
    if (location.coordinate.longitude < 0)
        signLong = -1.0;
    else
        signLong = 1.0;
    
    latDeg = floor(location.coordinate.latitude * signLat) * signLat;
    latMin = floor(((location.coordinate.latitude * signLat) - (latDeg * signLat)) * 60);
    latSec = ((((location.coordinate.latitude * signLat) - (latDeg * signLat)) * 60) - latMin) * 60;
    
    longDeg = floor(location.coordinate.longitude * signLong) * signLong;
    longMin = floor(((location.coordinate.longitude * signLong) - (longDeg * signLong)) * 60);
    longSec = ((((location.coordinate.longitude * signLong) - (longDeg * signLong)) * 60) - longMin) * 60;  
    
    //NSLog(@"Current location: %f, %f / %i, %i, %f / %i, %i, %f",location.coordinate.latitude,location.coordinate.longitude,latDeg,latMin,latSec,longDeg,longMin,longSec);
    NSString *urlString;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int searchRadiusDefault = [[defaults valueForKey:@"searchRadius"] intValue];
    if (searchType == 0) {
        urlString = [NSString stringWithFormat:@"http://transition.fcc.gov/fcc-bin/tvq?type=3&list=4&dist=%i&dlat2=%i&mlat2=%i&slat2=%f&dlon2=%i&mlon2=%i&slon2=%f",searchRadiusDefault,latDeg,latMin,latSec,longDeg,longMin,longSec];
    } else if (searchType == 1) {
        urlString = [NSString stringWithFormat:@"http://transition.fcc.gov/fcc-bin/fmq?&serv=FM&vac=3&list=4&dist=%i&dlat2=%i&mlat2=%i&slat2=%f&dlon2=%i&mlon2=%i&slon2=%f",searchRadiusDefault,latDeg,latMin,latSec,longDeg,longMin,longSec];
    } else if (searchType == 2) {
        urlString = [NSString stringWithFormat:@"http://transition.fcc.gov/fcc-bin/amq?type=2&list=4&dist=%i&dlat2=%i&mlat2=%i&slat2=%f&dlon2=%i&mlon2=%i&slon2=%f",searchRadiusDefault,latDeg,latMin,latSec,longDeg,longMin,longSec];
    }
    
    NSLog(@"URLString: %@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL: url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:30];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if ([data length] > 0 && error == nil)
            [self receivedData:data];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"Number of rows? %i",[dataArray count]);
    if ((dataArray == nil) || (gettingTVstations == YES)) {
        return 1;
    } else {
        return [dataArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSLog(@"Reloading data");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ((dataArray == nil) || (gettingTVstations == YES)) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = @"Searching for stations...";
        cell.detailTextLabel.text = @"";
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.frame = CGRectMake(0, 0, 24, 24);
        cell.accessoryView = spinner;
        [spinner startAnimating];
    } else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.text = [[dataArray objectAtIndex:indexPath.row] valueForKey:@"stationName"];
        if (searchType == 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Channel: %i (%@) / Power: %.1f kW",[[[dataArray objectAtIndex:indexPath.row] valueForKey:@"channel"] intValue],[[dataArray objectAtIndex:indexPath.row] valueForKey:@"psip"],[[[dataArray objectAtIndex:indexPath.row] valueForKey:@"power"] floatValue]];
        } else if (searchType == 1) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Frequency: %.1f MHz / Power: %.3f kW",[[[dataArray objectAtIndex:indexPath.row] valueForKey:@"frequency"] floatValue],[[[dataArray objectAtIndex:indexPath.row] valueForKey:@"power"] floatValue]];
        } else if (searchType == 2) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Frequency: %i kHz / Power: %.1f kW",[[[dataArray objectAtIndex:indexPath.row] valueForKey:@"frequency"] intValue],[[[dataArray objectAtIndex:indexPath.row] valueForKey:@"power"] floatValue]];
        }
        cell.accessoryView = nil;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[dataArray objectAtIndex:indexPath.row] forKey:@"defaultTower"];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
