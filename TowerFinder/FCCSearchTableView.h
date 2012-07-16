//
//  FCCSearchTableView.h
//  TowerFinder
//
//  Created by Kevin Vinck on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocationController.h"
#import "TWFAppDelegate.h"

@interface FCCSearchTableView : UITableViewController <CoreLocationControllerDelegate, NSURLConnectionDataDelegate> {
    int searchType;
    CLLocation *currentLoc;
    CoreLocationController *CLController;
    NSMutableArray *dataArray;
    bool alreadyUpdated;
    bool gettingTVstations;
}

- (id)initWithTV;
- (id)initWithFM;
- (id)initWithAM;
-(void)getTVStationsForLocation:(CLLocation *)location;

@end
