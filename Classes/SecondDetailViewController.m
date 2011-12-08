
#import "SecondDetailViewController.h"
#include "MapAnnotation.h"
#include "databaseManager.h"
#import "FMResultSet.h"
#import "FullMapViewController.h"
#include "AnnotatedFilesTableViewController.h"

@implementation SecondDetailViewController
@synthesize fullScreenBtn;
//@synthesize fullScreenBtnOutlet;
@synthesize navigationBar;

@synthesize mapView,arrayOfLocations,annotatedFTVC,latitude,longitude,anotationDescription;

#pragma mark -
#pragma mark View lifecycle

 
-(void)viewDidLoad{
    
    [super viewDidLoad];
    arrayOfLocations = [[NSMutableArray alloc] initWithCapacity:1];
    CLLocationCoordinate2D location;
       
    databaseManager *dbManager=[[databaseManager alloc] init];
    [dbManager updateNames];
    dbManager.db = [FMDatabase databaseWithPath:dbManager.databasePath];
    if(![dbManager.db open]){
        NSLog(@"Could not open db.");
        [dbManager release];
        return;
    }
    else{
        NSLog(@"database is open.");
    }
//below querry is used to select the distinct location where the files are tagged
    FMResultSet *rs=[dbManager.db executeQuery:@"select distinct latitude,longitude,description from geotagTable"];
    int no=0;
    while([rs next]) {
        NSString* lat=[rs stringForColumn:@"latitude"];
        
        [arrayOfLocations addObject:lat];       // storing the latitude in the array
      
         NSString* lon=[rs stringForColumn:@"longitude"];
        
        [arrayOfLocations addObject:lon];//storing the longitude in the array
       NSString* description=[rs stringForColumn:@"description"];
        [arrayOfLocations addObject:description];//storing the deascription in the array
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
        [self.mapView addAnnotation:newAnnotation];   // this function drops the pin at the location with that particualr latitude and longitude on to the map
        [newAnnotation display];
        [newAnnotation release];
    }
    
    [dbManager release];
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
    [self setNavigationBar:nil];
   // [self setFullScreenBtnOutlet:nil];
    [self setFullScreenBtn:nil];
	[super viewDidUnload];
	
	//self.navigationBar = nil;
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


//Sai Check : return type of the function and the returned value type did not match
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation   //this function is used to customise the pin dropped 
{
    annotatedFTVC.longitude=longitude;
    MKPinAnnotationView* pinView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"identifier"];
    pinView.animatesDrop=YES;
    pinView.canShowCallout=YES;
    pinView.pinColor=MKPinAnnotationColorGreen;  //setting properties to the pin dropped 
    
    UIButton* button=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button setTitle:annotation.title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(getInfo) forControlEvents:UIControlEventTouchUpInside]; //when we click on button placed on the pin getinfo function is called
    pinView.rightCalloutAccessoryView=button;
    
    //UIImageView* iconView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help.png"]];
    //pinView.leftCalloutAccessoryView=iconView;
    //[iconView release];
    return pinView;
    
    
}
-(void)getInfo      //when getinfo is called a table view contoller containing all the files tagged at that particular location is displayed in table view
{
    NSLog(@"animation clicked");
    AnnotatedFilesTableViewController *annotatedFilesTVC=[[AnnotatedFilesTableViewController alloc] initWithNibName:@"AnnotatedFilesTableViewController"bundle:[NSBundle mainBundle]];
    annotatedFilesTVC.detailMVC=self;
    annotatedFilesTVC.latitude=latitude;           //latittude,longirude,geodescription are passed to the next controller
    annotatedFilesTVC.longitude=longitude;
    annotatedFilesTVC.geoDescription= anotationDescription;
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:annotatedFilesTVC];
    nav.navigationBar.tintColor=[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:nav animated:YES];
    [annotatedFilesTVC release];
    
}

#pragma mark -
#pragma mark Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;//((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || 
            //(interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if(UIDeviceOrientationIsPortrait(toInterfaceOrientation))
        [fullScreenBtn setEnabled:NO];
    else
        [fullScreenBtn setEnabled:YES];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [arrayOfLocations release];
    [navigationBar release];
    //[fullScreenBtnOutlet release];
    [fullScreenBtn release];
    [super dealloc];
}	

- (IBAction)fullScreen:(id)sender {  //this function is used to switch to full screen mode

    FullMapViewController *fullmapVC = [[FullMapViewController alloc] initWithNibName:@"FullMapViewController" bundle:[NSBundle mainBundle]];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:fullmapVC];
    nav.navigationBar.tintColor=[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    [self presentModalViewController:nav animated:YES];
    [nav release];
    [fullmapVC release];
}
@end
