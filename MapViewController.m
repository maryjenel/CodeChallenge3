//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "StationsListViewController.h"

@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *myLocationManager;
@property MKPointAnnotation *bikeAnnotation;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.station.stationName;

    self.myLocationManager = [[CLLocationManager alloc]init];
    [self.myLocationManager requestAlwaysAuthorization];
    self.myLocationManager.delegate = self;

    [self.myLocationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;

    [self bikeStationPin];

    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;

    [self settingRegionForSpan:span];



}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
  
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];


    if (![[annotation title]isEqualToString:@"Current Location"]) {
    pin.image = [UIImage imageNamed:@"bikeImage"];
    }
    return pin;
}

-(void)bikeStationPin
{
    
        CLLocationDegrees longitude = [self.station.longitude doubleValue];
        CLLocationDegrees latitude = [self.station.latitude doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);

        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        annotation.coordinate = coordinate;
        annotation.title = self.station.stationName;
        annotation.subtitle = [NSString stringWithFormat:@" %@ bikes available", self.station.numberOfAvailableBikes];
        [self.mapView addAnnotation:annotation];


}


-(void)settingRegionForSpan: (MKCoordinateSpan)span
{
    MKCoordinateRegion region;
    region.center = CLLocationCoordinate2DMake([self.station.latitude doubleValue], [self.station.longitude doubleValue]);
    region.span = span;

    [self.mapView setRegion:region animated:YES];
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    UIAlertView *alertView = [[UIAlertView alloc]init];
    alertView.delegate = self;

    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder geocodeAddressString:self.station.bikeAddress completionHandler:^(NSArray *placemarks, NSError *error)
     {

         MKDirectionsRequest *request = [MKDirectionsRequest new];
         MKPlacemark *placemark = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake([self.station.latitude doubleValue], [self.station.longitude doubleValue]) addressDictionary:nil];
         request.source = [MKMapItem mapItemForCurrentLocation];
         request.destination = [[MKMapItem alloc]initWithPlacemark:placemark];
         request.transportType = MKDirectionsTransportTypeWalking;
         MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
         [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
          {
              NSArray *routes = response.routes;
              MKRoute *route = routes.firstObject;
              int x = 1;
              NSMutableString *directionString = [NSMutableString string];
              for (MKRouteStep *step in route.steps)
              {
             [directionString appendFormat:@"%d: %@\n", x, step.instructions];
                  x++;
              }
              alertView.message = directionString;
              [alertView show];

          }];
     }];


}



@end
