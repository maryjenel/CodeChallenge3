//
//  StationsListViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "StationsListViewController.h"
#import "MapViewController.h"
#import "Stations.h"


@interface StationsListViewController () <UITabBarDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSArray *sortedArray;
@property NSArray *stationBeanListArray;
@property NSMutableArray *bikeStationArray;



@end

@implementation StationsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bikeStationArray = [NSMutableArray new];
    [self parseJson];
}


- (void)parseJson
{
    NSURL *url = [NSURL URLWithString:@"http://www.bayareabikeshare.com/stations/json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
             NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         self.stationBeanListArray = [jsonDict objectForKey:@"stationBeanList"];

         for (NSDictionary *jsonDictionary in self.stationBeanListArray)
         {
             Stations *station = [Stations new];
    //stationName
             NSString *stationName = [jsonDictionary objectForKey:@"location"];
             station.stationName = stationName;
    //available bikes
             NSString * availablebikes = [jsonDictionary objectForKey:@"availableBikes"];
             station.numberOfAvailableBikes = availablebikes;
    //bikeCoordinates
             NSString *longitude = [jsonDictionary objectForKey:@"longitude"];

             station.longitude = longitude;
    //bike coordinates latitude
             NSString *latitude = [jsonDictionary objectForKey:@"latitude"];
             station.latitude = latitude;
     //addres
             NSString *address= [jsonDictionary objectForKey:@"stAddress1"];
             station.bikeAddress = address;

             [self.bikeStationArray addObject:station];

         }
         NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distanceFromUser" ascending:YES];
         NSArray *sortedArray = [self.bikeStationArray sortedArrayUsingDescriptors:@[sortDescriptor]];
         self.bikeStationArray = [[NSArray arrayWithArray:sortedArray]mutableCopy];// makes the sorted array into a mutable copy... 
             [self.tableView reloadData];

         
     }];
    
}


#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bikeStationArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Stations *station = [self.bikeStationArray objectAtIndex:indexPath.row];
    cell.textLabel.text = station.stationName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ available bikes", station.numberOfAvailableBikes];
    cell.imageView.image = [UIImage imageNamed:@"bikeImage"];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    if ([segue.identifier isEqualToString:@"ToMapSegue"])
    {
        MapViewController *vc = segue.destinationViewController;
        vc.station = [self.bikeStationArray objectAtIndex:indexPath.row];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


@end
