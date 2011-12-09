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
#include "ShareFilesViewController.h"
#include "FolderListViewController.h"

@implementation FileViewController
//@synthesize dbManager;
@synthesize lManager;
@synthesize fileWebView;
@synthesize toolbar;
@synthesize filename;
@synthesize presentSession, picker,fileID,openedDate, sharedFiles;

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
    
    fileWebView.scalesPageToFit=YES;
    
    //we get the file path from mainbundle
    NSString *urlAdd = [[NSBundle mainBundle] pathForResource:self.filename ofType: @"pdf"];
    
    //if its not present in mainbundle, we check in the documents directory
    if(urlAdd == nil){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        urlAdd = [NSString stringWithFormat:@"%@/%@.pdf",documentsDirectory,self.filename];
    }
    
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

    //reading the latitude value
    NSString *lat = [[NSString alloc] initWithFormat:@"%g",newLocation.coordinate.latitude];

    //reading the longitude value
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
    

    //checking if the location is previously used
    NSString* query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"select description from geotagTable where latitude='%@' and longitude='%@'",lat,lon]];
    
    FMResultSet *rs=[dbManager.db executeQuery:query];
    
    [manager stopUpdatingLocation];
    
    GeoTagScreenView* myView = [[GeoTagScreenView alloc] initWithNibName:@"GeoTagScreenView" bundle:[NSBundle mainBundle]];
    myView.fileVC=self;
    NSLog(@"lat = %@, long = %@",lat,lon);
    
    myView.navigator.modalPresentationStyle = UIModalPresentationFormSheet;
    
    //we present the view controller with latitude, longitude and description 
    [self presentModalViewController:myView.navigator animated:YES];
    

    //we are populating the values for latitude, longitude and description
    [myView.myLatitude setText:lat];
    [myView.myLongitude setText:lon];
    while([rs next]) {
        NSString* description=[rs stringForColumn:@"description"];
        myView.myTextView.text=description;
    }
    
    [lat release];
    [lon release];
    [query release];
    [myView release];
    [dbManager release];
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
    //the view controller is dismissed when the back button is pressed
    sharedFiles.folderListView.isFileSelected = FALSE;
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)calendarAction:(id)sender {
    //ViewFileEventsController is used to display all the events tagged to the file
    ViewFileEventsController *viewFileEventVC=[[ViewFileEventsController alloc] initWithNibName:@"ViewFileEventsController"bundle:[NSBundle mainBundle]];
    viewFileEventVC.fileVC=self;
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:viewFileEventVC];
    nav.navigationBar.tintColor=[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:nav animated:YES];
    [viewFileEventVC release]; 
}

- (IBAction)geoTagAction:(id)sender {
    //when we press the geotag button we start reading the latitude and longitude values
    lManager = [[CLLocationManager alloc] init];
    lManager.delegate=self;
    lManager.distanceFilter=kCLHeadingFilterNone;
    lManager.desiredAccuracy=0.1;
    [lManager startUpdatingLocation];
}

- (IBAction)shareFileAction:(id)sender {
    //BluetoothViewController is used to share the current file with other game plan users via bluetooth
    BluetoothViewController *bluetoothVC = [[BluetoothViewController alloc] initWithNibName:@"BluetoothViewController" bundle:[NSBundle mainBundle]];
    //we are setting the file we want to transfer
    bluetoothVC.transferedfile = [NSString stringWithFormat:@"%@.pdf",filename];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:bluetoothVC];
    
    nav.navigationBar.tintColor=[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:nav animated:YES];
    [bluetoothVC release];
}

- (IBAction)noteAction:(id)sender {
    
    //NotesTableViewController is used to display all the notes added to the file with the latest one first
    NotesTableViewController *notestableview=[[NotesTableViewController alloc] initWithNibName:@"NotesTableViewController"bundle:[NSBundle mainBundle]];
    notestableview.fileVC=self;
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:notestableview];
    nav.navigationBar.tintColor=[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:nav animated:YES];
    [notestableview release];
}

- (IBAction)historyAction:(id)sender {
    
    //FileHistoryTableViewContoller is used to display when a file is opened and where it it tagged. The latest one appears first
    FileHistoryTableViewController *filehistory=[[FileHistoryTableViewController alloc] initWithNibName:@"FileHistoryTableViewController"bundle:[NSBundle mainBundle]];
    filehistory.fileVC=self;
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:filehistory];
    nav.navigationBar.tintColor=[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:nav animated:YES];
    [filehistory release];
}

- (IBAction)contactAction:(id)sender {
    
    //AddContactToFileViewController displays list of all contacts present in the ipad, we can select one from them and tag it to file
    AddContactToFileViewController* myContacts = [[AddContactToFileViewController alloc] init];
    NSLog(@"this is being set. %d", self.fileID);
    myContacts.currentFileID = self.fileID;
    myContacts.mynav.modalPresentationStyle = UIModalPresentationFormSheet;
    [myContacts loadContactsList];
    [self presentModalViewController:myContacts.mynav animated:YES];
    [myContacts release];
}
@end
