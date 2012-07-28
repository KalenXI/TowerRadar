//
//  TowerAnnotation.h
//  TowerFinder
//
//  Created by Kevin Vinck on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TowerAnnotation : NSObject <MKAnnotation> {
    UIImage *image;
    NSNumber *latitude;
    NSNumber *longitude;
    NSDictionary *tower;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSDictionary *tower;

@end
