//
//  FullMapViewController.m
//  GamePlanApp
//
//  Created by Kowshik Gurram on 11/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#include "MapAnnotation.h"
#include "databaseManager.h"
#import "FMResultSet.h"
#import "FullMapViewController.h"

@implementation FullMapViewController

@synthesize arrayOfLocations;
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (void)cancel
{
    
     [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
   // UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target:self action:@selector(cancel)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.title=@"Map";
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    arrayOfLocations = [[NSMutableArray alloc] initWithCapacity:1];
    CLLocationCoordinate2D location;
    
    databaseManager *dbManager=[[databaseManager alloc] init];
    [dbManager updateNames];
    dbManager.db = [FMDatabase databaseWithPath:dbManager.databasePath];
    NSLog(@"path--- %@",dbManager.databasePath);
    if(![dbManager.db open]){
        NSLog(@"Could not open db.");
        return;
    }
    else{
        NSLog(@"database is open.");
    }
    
    FMResultSet *rs=[dbManager.db executeQuery:@"select distinct latitude,longitude,description from geotagTable"];
    int no=0;
    while([rs next]) {
        NSString* lat=[rs stringForColumn:@"latitude"];
        [arrayOfLocations addObject:lat];
        
        NSString* lon=[rs stringForColumn:@"longitude"];
        [arrayOfLocations addObject:lon];
        NSString* description=[rs stringForColumn:@"description"];
        [arrayOfLocations addObject:description];
        NSLog(@"%@",lat);
        NSLog(@"%@",lon);
        no++;
        
        
        
    }
    int pos=0;
    for(int i=0;i<no;i++){
        location.latitude = [[arrayOfLocations objectAtIndex:pos] doubleValue];
        pos++;
        location.longitude = [[arrayOfLocations objectAtIndex:pos] doubleValue];
        pos++;
        NSString *description = [arrayOfLocations objectAtIndex:pos] ;
        pos++;
        MapAnnotation *newAnnotation = [[MapAnnotation alloc] initWithTitle:description andCoordinate:location];
        [self.mapView addAnnotation:newAnnotation];
    }
   // MapAnnotation *newAnnotation = [[MapAnnotation alloc] initWithTitle:@"Buckingham Palace" andCoordinate:location];
  //  [self.mapView addAnnotation:newAnnotation];
    
    
    NSLog(@"out");
    
    
    [super viewDidLoad];
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
	MKAnnotationView *annotationView = [views objectAtIndex:0];
	id <MKAnnotation> mp = [annotationView annotation];
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 10000, 10000);
	[mv setRegion:region animated:YES];
	[mv selectAnnotation:mp animated:YES];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
    [mapView release];
    [super dealloc];
}
@end
