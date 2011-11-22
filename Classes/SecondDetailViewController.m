
#import "SecondDetailViewController.h"
#include "MapAnnotation.h"
#include "databaseManager.h"
#import "FMResultSet.h"
#import "FullMapViewController.h"

@implementation SecondDetailViewController

@synthesize navigationBar,mapView,arrayOfLocations;

#pragma mark -
#pragma mark View lifecycle

-(void)fullView
{
    FullMapViewController *fullmapVC = [[FullMapViewController alloc] initWithNibName:@"FullMapViewController" bundle:[NSBundle mainBundle]];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:fullmapVC];
    nav.navigationBar.tintColor=[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    [self presentModalViewController:nav animated:YES];
}

-(void)viewDidLoad{
    
    //UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target:self action:@selector(fullView)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Full Screen" style:UIBarButtonItemStylePlain target:self action:@selector(fullView)];
    
    self.title=@"Map";
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
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
        [newAnnotation display];
    }
    //MapAnnotation *newAnnotation = [[MapAnnotation alloc] initWithTitle:@"Buckingham Palace" andCoordinate:location];
    //[self.mapView addAnnotation:newAnnotation];
    
    
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


-(void) viewDidUnload {
	[super viewDidUnload];
	
	self.navigationBar = nil;
}

#pragma mark -
#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    // Add the popover button to the left navigation item.
    [navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:NO];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    // Remove the popover button.
    [navigationBar.topItem setLeftBarButtonItem:nil animated:NO];
}


#pragma mark -
#pragma mark Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [arrayOfLocations release];
    //[mapView release];
    [navigationBar release];
    [super dealloc];
}	


@end
