//
//  CustomAnnotation.h
//  CodeChallenge3
//
//  Created by Mary Jenel Myers on 1/23/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Stations.h"

@interface CustomAnnotation : MKPointAnnotation

@property Stations *station;
@end
