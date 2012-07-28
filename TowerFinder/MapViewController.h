//
//  MapViewController.h
//  TowerFinder
//
//  Created by Kevin Vinck on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TowerAnnotation.h"

@interface MapViewController : UIViewController <MKMapViewDelegate> {
    bool alreadyUpdated;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIToolbar *mapToolbar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSelector;
- (IBAction)mapTypeChanged:(id)sender;

@end
