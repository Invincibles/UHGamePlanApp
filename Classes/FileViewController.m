//
//  FileViewController.m
//  MultipleDetailViews
//
//  Created by Invincibles on 10/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileViewController.h"
#import <GameKit/GameKit.h>
#import "databaseManager.h"
#import "GeoTagScreenView.h"
#import "NotesTableViewController.h"
#import "AddEventToFileViewController.h"
#import "ViewFileEventsController.h"
#import "AddContactToFileViewController.h"
#import "FileHistoryTableViewController.h"
#include "databaseManager.h"

@implementation FileViewController
//@synthesize dbManager;
@synthesize lManager;
@synthesize fileWebView;
@synthesize toolbar;
@synthesize filename;
@synthesize presentSession, picker,fileID,openedDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        filename=[[NSString alloc] init];
    }
    return self;
}

-(void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem{
    
}

-(void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem{
    
}

- (void)dealloc
{
    [presentSession release];
    [picker release];
    
    [fileWebView release];
    [filename release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        
        ispotrait=UIDeviceOrientationIsPortrait(self.interfaceOrientation);
        NSLog(@"rotated in detail");
        NSLog(@"%d",ispotrait);
        if(!ispotrait)
        {
//            [toolbar removeFromSuperview];
//            UIToolbar *toolbar1;
//            toolbar1 = [UIToolbar new];
//            toolbar1.barStyle = UIBarStyleBlackTranslucent;
//            [toolbar1 sizeToFit];
//            toolbar1.frame = CGRectMake(0,955, 1100, 50);
//            [self.view addSubview:toolbar1];
//            UIBarButtonItem *button1= [[UIBarButtonItem alloc] 
//                                       initWithTitle:@"Back" style:UIBarButtonItemStyleBordered 
//                                       target:self action:@selector(gotoSplitView)];
//            NSArray *items = [NSArray arrayWithObjects:  button1,  nil];
//            [button1 release];
//            [toolbar1 setItems:items animated:NO];
//            self.toolbar.frame = CGRectMake(0,955, 1100, 50);
        }
        else{
            
            //[self.view addSubview: toolbar];
            
        }    

    }];

}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
       
}
-(void)gotoSplitView
{
    //  [self presentModalViewController:fullNV animated:YES];
    
    [self dismissModalViewControllerAnimated:YES];
}



- (void)viewDidLoad
{
    toolbar.tintColor = [[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    NSLog(@"start of full");
    

  
    
    
//    toolbar = [UIToolbar new];
//	toolbar.barStyle = UIBarStyleBlackTranslucent;
//	[toolbar sizeToFit];
//    toolbar.frame = CGRectMake(0,0, 100, 100);
//    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//	
//	[self.view addSubview:toolbar];
    
//	UIBarButtonItem *button1 = [[UIBarButtonItem alloc]
//                                initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
//                                target:self action:@selector(action:)];
//	UIBarButtonItem *button2= [[UIBarButtonItem alloc] 
//                               initWithTitle:@"Back" style:UIBarButtonItemStyleBordered 
//                               target:self action:@selector(gotoSplitView)];
//	NSArray *items = [NSArray arrayWithObjects:  button1,  button2,  nil];
//	[button1 release];
//	[button2 release];
//	[toolbar setItems:items animated:NO];
    
    
    fileWebView.scalesPageToFit=YES;
    
    NSLog(@"file name..%@",self.filename);
 
    NSString *urlAdd = [[NSBundle mainBundle] pathForResource:self.filename ofType: @"pdf"];
    
    NSURL *ur = [NSURL fileURLWithPath:urlAdd]; 
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:ur]; 
    [fileWebView loadRequest:requestObj];
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) locationManager: (CLLocationManager *) manager
     didUpdateToLocation: (CLLocation *) newLocation
            fromLocation: (CLLocation *) oldLocation
{
    NSLog(@"IN LOCATION");
  
    int degrees=newLocation.coordinate.latitude;
    double decimal=fabs(newLocation.coordinate.latitude - degrees);
    int minutes=decimal*60;
    double seconds=decimal*3600 - minutes*60;
    //NSString *lat = [NSString stringWithFormat:@"%d %d %1.4f",degrees,minutes,seconds];degrees=newLocation.coordinate.longitude;
    NSString *lat = [[NSString alloc] initWithFormat:@"%g",newLocation.coordinate.latitude];
    decimal=fabs(newLocation.coordinate.longitude - degrees);
    minutes=decimal*60;
    seconds=decimal*3600 - minutes*60;
    //NSString *lon = [NSString stringWithFormat:@"%d %d %1.4f",degrees,minutes,seconds];
    NSString *lon = [[NSString alloc] initWithFormat:@"%g",newLocation.coordinate.longitude];
    
    databaseManager *dbManager=[[databaseManager alloc] init];
    [dbManager updateNames];
    dbManager.db = [FMDatabase databaseWithPath:dbManager.databasePath];
    NSLog(@"path--- %@",dbManager.databasePath);
    if(![dbManager.db open]){
        NSLog(@"Could not open db.");
        
    }
    else{
        NSLog(@"database is open.");
    }
    
    
    NSString* query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"select description from geotagTable where latitude='%@' and longitude='%@'",lat,lon]];
    NSLog(@"%@", query);
    //BOOL suc = [dbManager.db executeUpdate:query];
    
    FMResultSet *rs=[dbManager.db executeQuery:query];
    
  
    
    [manager stopUpdatingLocation];
    
    GeoTagScreenView* myView = [[GeoTagScreenView alloc] initWithNibName:@"GeoTagScreenView" bundle:[NSBundle mainBundle]];
    myView.fileVC=self;
    NSLog(@"lat = %@, long = %@",lat,lon);
    
    myView.navigator.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentModalViewController:myView.navigator animated:YES];
    [myView.myLatitude setText:lat];
    [myView.myLongitude setText:lon];
    while([rs next]) {
        NSString* description=[rs stringForColumn:@"description"];
        myView.myTextView.text=description;
    }
    
    
    
    
    
}





- (void)viewDidUnload
{
    [self setFileWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)backButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)calenderButton:(id)sender {
    
    
    ViewFileEventsController *viewFileEventVC=[[ViewFileEventsController alloc] initWithNibName:@"ViewFileEventsController"bundle:[NSBundle mainBundle]];
   viewFileEventVC.fileVC=self;
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:viewFileEventVC];
    nav.navigationBar.tintColor=[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:nav animated:YES];
    [viewFileEventVC release]; 
    

}

- (IBAction)geotagButton:(id)sender {
    
    //fileID=10;
    lManager = [[CLLocationManager alloc] init];
    lManager.delegate=self;
    lManager.distanceFilter=kCLHeadingFilterNone;
    lManager.desiredAccuracy=0.1;
    [lManager startUpdatingLocation];
    

}

- (IBAction)shareButton:(id)sender {
    
    BluetoothViewController *bluetoothVC = [[BluetoothViewController alloc] initWithNibName:@"BluetoothViewController" bundle:[NSBundle mainBundle]];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:bluetoothVC];
    
    nav.navigationBar.tintColor=[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:nav animated:YES];
    nav.view.superview.frame = CGRectMake(312, 242, 400, 211);
    [bluetoothVC release];
    
}

- (IBAction)contactButton:(id)sender {
    AddContactToFileViewController* myContacts = [[AddContactToFileViewController alloc] init];
    NSLog(@"this is being set. %d", self.fileID);
    myContacts.currentFileID = self.fileID;
    myContacts.mynav.modalPresentationStyle = UIModalPresentationFormSheet;
    [myContacts loadContactsList];
    [self presentModalViewController:myContacts.mynav animated:YES];
    [myContacts release];
}

- (IBAction)noteButton:(id)sender {
    
    //fileID=10;
    NotesTableViewController *notestableview=[[NotesTableViewController alloc] initWithNibName:@"NotesTableViewController"bundle:[NSBundle mainBundle]];
    notestableview.fileVC=self;
      UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:notestableview];
    nav.navigationBar.tintColor=[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:nav animated:YES];
    [notestableview release];
    
   /* 
    addTextFile *addText = [[addTextFile alloc] initWithNibName:@"addTextFile" bundle:[NSBundle mainBundle]];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:addText];
    nav.navigationBar.tintColor=[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:nav animated:YES];
    [addText release];*/
}

- (IBAction)historyButton:(id)sender {
   FileHistoryTableViewController *filehistory=[[FileHistoryTableViewController alloc] initWithNibName:@"FileHistoryTableViewController"bundle:[NSBundle mainBundle]];
    filehistory.fileVC=self;
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:filehistory];
    nav.navigationBar.tintColor=[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:nav animated:YES];
    [filehistory release];
    
    
    
}
@end
