//
//  TWFFirstViewController.h
//  TowerFinder
//
//  Created by Kevin Vinck on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocationController.h"

@interface TWFFirstViewController : UIViewController <CoreLocationControllerDelegate> {
    CoreLocationController *CLController;
    CLLocation *currentLocation;
    float headingToTower;
    double headingAccuracy;
    float currentHeading;
    double distanceToTower;
    double locationAccuracy;
    double towerLatitude;
    double towerLongitude;
    NSTimer *refreshTimer;
}
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *curHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentStationLabel;

@end
