//
//  Stations.h
//  CodeChallenge3
//
//  Created by Mary Jenel Myers on 1/23/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Stations : NSObject

@property NSString *stationName;
@property NSString *numberOfAvailableBikes;
@property NSString *longitude;
@property NSString *latitude;
@property NSInteger distanceFromUser;
@property NSString *bikeAddress;


@end
