//
//  TWFFirstViewController.m
//  TowerFinder
//
//  Created by Kevin Vinck on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TWFFirstViewController.h"

@implementation TWFFirstViewController
@synthesize arrowView;
@synthesize headingLabel;
@synthesize distanceLabel;
@synthesize accuracyLabel;
@synthesize curHeadingLabel;
@synthesize currentStationLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Compass", @"Compass");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (double) degtorad:(double)deg {
    return deg * (M_PI/180);
}

- (double) radtodeg:(double)rad {
    return rad * (180.0 / M_PI);
}

- (double) getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc
{
    double lat1 = [self degtorad:fromLoc.latitude];
    double lat2 = [self degtorad:toLoc.latitude];
    double dlon = [self degtorad:(toLoc.longitude - fromLoc.longitude)];
    
    //NSLog(@"%f / %f / %f",lat1,lat2,dlon);
    
    double y = sin(dlon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dlon);
    double brng = atan2(y, x);
    
    //NSLog(@"Bearing: %f",[self radtodeg:brng]+360);
    //NSLog(@"Bearing 2: %f",fmod([self radtodeg:brng]+360, 360));
    
    return fmod(([self radtodeg:brng]+360), 360);
    
    //return atan2(sin(fLng-tLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(fLng-tLng));         
}

- (void)locationUpdate:(CLLocation *)location {
    
    //NSLog(@"Location update!");
    
    CLLocationCoordinate2D toCoord;    
    
    toCoord.latitude = towerLatitude;
    toCoord.longitude = towerLongitude;
    
    NSLog(@"Tower: %f / %f",towerLatitude,towerLongitude);
    NSLog(@"Current Loc: %f / %f",location.coordinate.latitude,location.coordinate.longitude);
    
    CLLocation *towerLoc = [[CLLocation alloc] initWithLatitude:towerLatitude longitude:towerLongitude];
    headingToTower = [self getHeadingForDirectionFromCoordinate:location.coordinate toCoordinate:toCoord];
    distanceToTower = [location distanceFromLocation:towerLoc] / 1000.0;
    locationAccuracy = location.horizontalAccuracy;
    
    accuracyLabel.text = [NSString stringWithFormat:@"Accuracy: %.0f° / %.0f meters",headingAccuracy,locationAccuracy];
    headingLabel.text = [NSString stringWithFormat:@"%.0f°",headingToTower];
    if (distanceToTower >= 10.0) {
        distanceLabel.text = [NSString stringWithFormat:@"%.0f",distanceToTower];
    } else {
        distanceLabel.text = [NSString stringWithFormat:@"%.1f",distanceToTower];
    }
}

- (void)headingUpdate:(CLHeading *)heading {
    
    currentHeading = heading.trueHeading;
    headingAccuracy = heading.headingAccuracy;
    curHeadingLabel.text = [NSString stringWithFormat:@"%.0f°",heading.trueHeading];
    accuracyLabel.text = [NSString stringWithFormat:@"Accuracy: %.0f° / %.0f meters",headingAccuracy,locationAccuracy];
    self.arrowView.transform = CGAffineTransformMakeRotation([self degtorad:((headingToTower - currentHeading)+2)]);
    
}

- (void)locationError:(NSError *)error {
	NSLog(@"Location error: %@",error);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CLController = [[CoreLocationController alloc] init];
	CLController.delegate = self;
    currentLocation = [[CLLocation alloc] init];
}

- (void)viewDidUnload
{
    [self setArrowView:nil];
    [self setHeadingLabel:nil];
    [self setDistanceLabel:nil];
    [self setAccuracyLabel:nil];
    [self setCurHeadingLabel:nil];
    [self setCurrentStationLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *defaultTower = [defaults dictionaryForKey:@"defaultTower"];
    towerLatitude = [[defaultTower valueForKey:@"latitude"] floatValue];
    towerLongitude = [[defaultTower valueForKey:@"longitude"] floatValue];
    currentStationLabel.text = [defaultTower valueForKey:@"stationName"];
    [CLController.locMgr startUpdatingLocation];
    [CLController.locMgr startUpdatingHeading];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [CLController.locMgr stopUpdatingLocation];
    [CLController.locMgr stopUpdatingHeading];
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
