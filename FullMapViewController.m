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
#import "AnnotatedFilesTableViewController.h"

@implementation FullMapViewController
@synthesize anotationDescription;
@synthesize arrayOfLocations;
@synthesize mapView,annotatedFTVC,pinView,latitude,longitude;


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
        NSLog(@"%@...lat",lat);
        [arrayOfLocations addObject:lat];
        
        NSString* lon=[rs stringForColumn:@"longitude"];
        [arrayOfLocations addObject:lon];
        NSLog(@"%@...lat",lon);
        NSString* description=[rs stringForColumn:@"description"];
        [arrayOfLocations addObject:description];
        NSLog(@"%@",lat);
        NSLog(@"%@",lon);
        no++;
        
        
        
    }
    int pos=0;
    for(int i=0;i<no;i++){
          location.latitude = [[arrayOfLocations objectAtIndex:pos] doubleValue];
          latitude=[arrayOfLocations objectAtIndex:pos];
        pos++;
      location.longitude = [[arrayOfLocations objectAtIndex:pos] doubleValue];
        
        longitude=[arrayOfLocations objectAtIndex:pos];
        pos++;
        NSString *description = [arrayOfLocations objectAtIndex:pos] ;
        anotationDescription=description;
        
      
        
        
        pos++;
        MapAnnotation *newAnnotation = [[MapAnnotation alloc] initWithTitle:description andCoordinate:location];
        [self.mapView addAnnotation:newAnnotation];
    }
   // MapAnnotation *newAnnotation = [[MapAnnotation alloc] initWithTitle:@"Buckingham Palace" andCoordinate:location];
  //  [self.mapView addAnnotation:newAnnotation];
    
    
    NSLog(@"out");
    
    
    [super viewDidLoad];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation    
{
    annotatedFTVC=[[AnnotatedFilesTableViewController alloc]init];
    annotatedFTVC.longitude=longitude;
    annotatedFTVC.latitude=latitude;
    pinView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"identifier"];
    pinView.animatesDrop=YES;
    pinView.canShowCallout=YES;
    pinView.pinColor=MKPinAnnotationColorGreen;
    UIButton* button=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button setTitle:annotation.title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(getInfo) forControlEvents:UIControlEventTouchUpInside];
    pinView.rightCalloutAccessoryView=button;
    
    //UIImageView* iconView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help.png"]];
    //pinView.leftCalloutAccessoryView=iconView;
    //[iconView release];
    return pinView;
                           
     
}
-(void)getInfo
{
    NSLog(@"animation clicked");
   AnnotatedFilesTableViewController *annotatedFilesTVC=[[AnnotatedFilesTableViewController alloc] initWithNibName:@"AnnotatedFilesTableViewController"bundle:[NSBundle mainBundle]];
   annotatedFilesTVC.fullMapVC=self;
    annotatedFilesTVC.geoDescription= anotationDescription;
    annotatedFilesTVC.latitude=latitude;
    annotatedFilesTVC.longitude=longitude;
    
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:annotatedFilesTVC];
    nav.navigationBar.tintColor=[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
   // pinView = annotatedFilesTVC.view;
    [self presentModalViewController:nav animated:YES];
    //[self.navigationController pushViewController:annotatedFilesTVC animated:YES];
    [annotatedFilesTVC release]; 
    
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;//((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || 
//            (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

- (void)dealloc {
    [pinView release];
    [mapView release];
    [super dealloc];
}
@end
