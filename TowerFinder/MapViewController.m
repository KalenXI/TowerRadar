//
//  MapViewController.m
//  TowerFinder
//
//  Created by Kevin Vinck on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapView;
@synthesize mapToolbar;
@synthesize mapTypeSelector;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Map";
        self.tabBarItem.image = [UIImage imageNamed:@"103-map"];
        alreadyUpdated = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [mapView setDelegate:self];
    self.mapView.mapType = MKMapTypeStandard;
    MKUserTrackingBarButtonItem *trackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:mapView];
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:self.mapToolbar.items];
    [items insertObject:trackingButton atIndex:0];
    //NSLog(@"Items: %@",items);
    [self.mapToolbar setItems:items];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setMapToolbar:nil];
    [self setMapTypeSelector:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)mapView:(MKMapView *)map didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (!alreadyUpdated) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        double radius = [[defaults valueForKey:@"searchRadius"] doubleValue];
        //NSLog(@"Search radius: %f",miles);
        double scalingFactor = ABS( (cos(2 * M_PI * userLocation.location.coordinate.latitude / 360.0) ));
        
        MKCoordinateSpan span;
        
        span.latitudeDelta = (radius*2)/110.57;
        span.longitudeDelta = (radius*2)/(scalingFactor * 111.3);
        
        MKCoordinateRegion region;
        region.span = span;
        region.center = userLocation.location.coordinate;
        //NSLog(@"Map Center: %@",userLocation.location.coordinate);
        
        [map setRegion:region animated:YES];
        alreadyUpdated = YES;
    }
    //NSLog(@"User location updated");
    if (self.mapView.userTrackingMode == MKUserTrackingModeFollow) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *defaultTower = [defaults objectForKey:@"defaultTower"];
        //NSLog(@"Search radius: %f",miles);
        double scalingFactor = ABS( (cos(2 * M_PI * self.mapView.userLocation.location.coordinate.latitude / 360.0) ));
        
        CLLocation *towerLoc = [[CLLocation alloc] initWithLatitude:[[defaultTower valueForKey:@"latitude"] floatValue] longitude:[[defaultTower valueForKey:@"longitude"] floatValue]];
        
        double radius = [towerLoc distanceFromLocation:self.mapView.userLocation.location] / 1000.0;
        
        MKCoordinateSpan span;
        
        span.latitudeDelta = (radius*2)/110.57;
        span.longitudeDelta = (radius*2)/(scalingFactor * 111.3);
        
        MKCoordinateRegion region;
        region.span = span;
        region.center = self.mapView.userLocation.location.coordinate;
        //NSLog(@"Map Center: %@",userLocation.location.coordinate);
        
        [self.mapView setRegion:region animated:YES];
        self.mapView.showsUserLocation = YES;
    }
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    //NSLog(@"Region will change.");
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated {
    if ((mode == MKUserTrackingModeFollow) || (mode == MKUserTrackingModeFollowWithHeading)) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *defaultTower = [defaults objectForKey:@"defaultTower"];
        //NSLog(@"Search radius: %f",miles);
        double scalingFactor = ABS( (cos(2 * M_PI * self.mapView.userLocation.location.coordinate.latitude / 360.0) ));
        
        CLLocation *towerLoc = [[CLLocation alloc] initWithLatitude:[[defaultTower valueForKey:@"latitude"] floatValue] longitude:[[defaultTower valueForKey:@"longitude"] floatValue]];
        
        double radius = [towerLoc distanceFromLocation:self.mapView.userLocation.location] / 1000.0;
        
        MKCoordinateSpan span;
        
        span.latitudeDelta = (radius*2)/110.57;
        span.longitudeDelta = (radius*2)/(scalingFactor * 111.3);
        
        MKCoordinateRegion region;
        region.span = span;
        region.center = self.mapView.userLocation.location.coordinate;
        //NSLog(@"Map Center: %@",userLocation.location.coordinate);
        
        [self.mapView setRegion:region animated:YES];
        self.mapView.showsUserLocation = YES;
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        double radius = [[defaults valueForKey:@"searchRadius"] doubleValue];
        //NSLog(@"Search radius: %f",miles);
        double scalingFactor = ABS( (cos(2 * M_PI * self.mapView.userLocation.location.coordinate.latitude / 360.0) ));
        
        MKCoordinateSpan span;
        
        span.latitudeDelta = (radius*2)/110.57;
        span.longitudeDelta = (radius*2)/(scalingFactor * 111.3);
        
        MKCoordinateRegion region;
        region.span = span;
        region.center = self.mapView.userLocation.location.coordinate;
        //NSLog(@"Map Center: %@",userLocation.location.coordinate);
        
        [self.mapView setRegion:region animated:YES];
        self.mapView.showsUserLocation = YES;
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString* TowerAnnotationIdentifier = @"towerAnnotationIdentifier";
    //MKPinAnnotationView* pinView = (MKPinAnnotationView *)
    [mapView dequeueReusableAnnotationViewWithIdentifier:TowerAnnotationIdentifier];
    // if an existing pin view was not available, create one
    MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                          initWithAnnotation:annotation reuseIdentifier:TowerAnnotationIdentifier];
    
    TowerAnnotation *currentTower = annotation;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *defaultTower = [defaults objectForKey:@"defaultTower"];
    
    //NSLog(@"Default Tower: %@ / %@",[defaultTower valueForKey:@"stationName"],currentTower.title);
    
    if ([[defaultTower valueForKey:@"stationName"] isEqualToString:currentTower.title]) {
        customPinView.pinColor = MKPinAnnotationColorRed;
        //NSLog(@"Red Tower:: %@ / %@",[defaultTower valueForKey:@"stationName"],currentTower.title);
    } else {
        customPinView.pinColor = MKPinAnnotationColorPurple;
    }
    customPinView.animatesDrop = NO;
    customPinView.canShowCallout = YES;
    
    // add a detail disclosure button to the callout which will open a new view controller page
    //
    // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
    //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
    //
    //UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButton.titleLabel.text = @"Set Tower";
    
    UIButton *myDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myDetailButton.frame = CGRectMake(0, 0, 30, 30);
    myDetailButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    myDetailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [myDetailButton setBackgroundImage:[[UIImage imageNamed:@"annotationButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)] forState:UIControlStateNormal];
    [myDetailButton setBackgroundImage:[[UIImage imageNamed:@"annotationButtonPressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)] forState:UIControlStateHighlighted];
    [myDetailButton setImage:[UIImage imageNamed:@"74-location"] forState:UIControlStateNormal];
    [myDetailButton setImage:[UIImage imageNamed:@"74-location"] forState:UIControlStateHighlighted];
    //[myDetailButton setTitle:@"Set Tower" forState:UIControlStateNormal];
    //[myDetailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //myDetailButton.titleLabel.text = @"Set Tower";
    
    //[rightButton addTarget:self
    //                action:@selector(showDetails:)
    //      forControlEvents:UIControlEventTouchUpInside];
    customPinView.rightCalloutAccessoryView = myDetailButton;
    
    return customPinView;
}

- (void)showDetails:(TowerAnnotation *)tower {
    NSLog(@"Title: %@",tower.title);
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    TowerAnnotation *tower = view.annotation;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:tower.tower forKey:@"defaultTower"];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    NSArray *towerArray;
    switch ([defaults integerForKey:@"lastSearchType"]) {
        case 0:
            towerArray = [defaults objectForKey:@"lastTVSearch"];
            break;
        case 1:
            towerArray = [defaults objectForKey:@"lastFMSearch"];
            break;
        case 2:
            towerArray = [defaults objectForKey:@"lastAMSearch"];
            break;
            
        default:
            break;
    }

    NSMutableArray *towers = [NSMutableArray arrayWithCapacity:[towerArray count]];
    
    for (int i=0; i < [towerArray count]; i++) {
        TowerAnnotation *tower = [[TowerAnnotation alloc] init];
        NSDictionary *towerDict = [towerArray objectAtIndex:i];
        CLLocationCoordinate2D towerCoord;
        towerCoord.latitude = [[towerDict valueForKey:@"latitude"] doubleValue];
        towerCoord.longitude = [[towerDict valueForKey:@"longitude"] doubleValue];
        tower.coordinate = towerCoord;
        tower.title = [towerDict valueForKey:@"stationName"];
        tower.tower = towerDict;
        [towers addObject:tower];
    }
    
    [self.mapView addAnnotations:towers];
}

- (void)viewDidAppear:(BOOL)animated
{
    //alreadyUpdated = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (mapView.userLocation != nil) {
        if ((self.mapView.userTrackingMode == MKUserTrackingModeFollow) || (self.mapView.userTrackingMode == MKUserTrackingModeFollowWithHeading)) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *defaultTower = [defaults objectForKey:@"defaultTower"];
            //NSLog(@"Search radius: %f",miles);
            double scalingFactor = ABS( (cos(2 * M_PI * self.mapView.userLocation.location.coordinate.latitude / 360.0) ));
            
            CLLocation *towerLoc = [[CLLocation alloc] initWithLatitude:[[defaultTower valueForKey:@"latitude"] floatValue] longitude:[[defaultTower valueForKey:@"longitude"] floatValue]];
            
            double radius = [towerLoc distanceFromLocation:self.mapView.userLocation.location] / 1000.0;
            
            MKCoordinateSpan span;
            
            span.latitudeDelta = (radius*2)/110.57;
            span.longitudeDelta = (radius*2)/(scalingFactor * 111.3);
            
            MKCoordinateRegion region;
            region.span = span;
            region.center = self.mapView.userLocation.location.coordinate;
            //NSLog(@"Map Center: %@",userLocation.location.coordinate);
            
            [self.mapView setRegion:region animated:YES];
            self.mapView.showsUserLocation = YES;
        } else {
            double radius = [[defaults valueForKey:@"searchRadius"] doubleValue];
            //NSLog(@"Search radius: %f",miles);
            double scalingFactor = ABS( (cos(2 * M_PI * mapView.userLocation.location.coordinate.latitude / 360.0) ));
            
            MKCoordinateSpan span;
            
            span.latitudeDelta = (radius*2)/110.57;
            span.longitudeDelta = (radius*2)/(scalingFactor * 111.3);
            
            MKCoordinateRegion region;
            region.span = span;
            region.center = mapView.userLocation.location.coordinate;
            //NSLog(@"Map Center: %@",userLocation.location.coordinate);
            
            [mapView setRegion:region animated:YES];
        }
    }
    
    NSArray *towerArray;
    
    switch ([defaults integerForKey:@"lastSearchType"]) {
        case 0:
            towerArray = [defaults objectForKey:@"lastTVSearch"];
            break;
        case 1:
            towerArray = [defaults objectForKey:@"lastFMSearch"];
            break;
        case 2:
            towerArray = [defaults objectForKey:@"lastAMSearch"];
            break;
            
        default:
            break;
    }
    
    if (towerArray != nil) {
        [mapView removeAnnotations:self.mapView.annotations];
        NSMutableArray *towers = [NSMutableArray arrayWithCapacity:[towerArray count]];
        
        for (int i=0; i < [towerArray count]; i++) {
            TowerAnnotation *tower = [[TowerAnnotation alloc] init];
            NSDictionary *towerDict = [towerArray objectAtIndex:i];
            CLLocationCoordinate2D towerCoord;
            towerCoord.latitude = [[towerDict valueForKey:@"latitude"] doubleValue];
            towerCoord.longitude = [[towerDict valueForKey:@"longitude"] doubleValue];
            tower.coordinate = towerCoord;
            tower.title = [towerDict valueForKey:@"stationName"];
            tower.tower = towerDict;
            [towers addObject:tower];
        }
        
        [mapView addAnnotations:towers];
    }
    
    [super viewDidAppear:animated];
    
}

- (IBAction)mapTypeChanged:(id)sender {
    switch (self.mapTypeSelector.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
            
        default:
            break;
    }
    
}
@end
