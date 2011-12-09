//
//  GeoTagScreenView.m
//  MultipleDetailViews
//
//  Created by Invincibles on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GeoTagScreenView.h"
#import "databaseManager.h"
#import "FileViewController.h"

@implementation GeoTagScreenView
@synthesize myTextView;
@synthesize myLatitude;
@synthesize myLongitude;
@synthesize navigator;
@synthesize fileVC;
-(void) cancelAction:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) doneAction:(id)sender  // when we enter the description of the place a row is inserted into the table with the latitude,longitude and the place description
{

    BOOL descriptionGiven = FALSE;
    
    descriptionGiven = [myTextView hasText];
    
    int fileid=self.fileVC.fileID;
    NSDate* openedDate=self.fileVC.openedDate;
    NSDate* dt=[NSDate date];
    
    if(descriptionGiven){   // if description is given
        
        databaseManager *dbManager=[[databaseManager alloc] init];
        [dbManager updateNames];
        dbManager.db = [FMDatabase databaseWithPath:dbManager.databasePath];
        NSLog(@"path--- %@",dbManager.databasePath);
        if(![dbManager.db open]){
            NSLog(@"Could not open db.");
            [dbManager release];
            return;
        }
        else{
            NSLog(@"database is open.");
        }
        // below querry is used to insert a row into geotagtable with a description,latitute,longitude for that particular file
        NSString* query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"insert into geotagTable (fid,latitude,longitude,description,geotagDate) values (%d,'%@','%@','%@','%@')",fileid,myLatitude.text,myLongitude.text,myTextView.text,dt]];
        
        NSString* query1 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"UPDATE filehistory SET geodescription='%@' WHERE fid='%d' and openeddate='%@'",myTextView.text,fileid,openedDate]];
    
        BOOL suc1 = [dbManager.db executeUpdate:query1];
        BOOL suc = [dbManager.db executeUpdate:query];
        if(suc && suc1)
            NSLog(@"insert is successful.");
        else
            NSLog(@"insert failed.");
        
        [query release];
        [query1 release];
        [dbManager.db close];
        [dbManager release];
        [self dismissModalViewControllerAnimated:YES];
    }
    else  // if the description is not given then it should pop up an alert 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Description" message:@"Please Enter Description" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
     
   
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        navigator = [[UINavigationController alloc] initWithRootViewController:self];
        navigator.navigationBar.tintColor = [[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f] autorelease];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction:)];
        
        self.navigationItem.rightBarButtonItem = doneButton;
        self.navigationItem.leftBarButtonItem = cancelButton;
        
        [cancelButton release];
        [doneButton release];
    }
    return self;
}

- (void)dealloc
{
    [myLongitude release];
    [myLatitude release];
    [myLongitude release];
    [myTextView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setMyTextView:nil];
    [myLongitude release];
    myLongitude = nil;
    [self setMyLatitude:nil];
    [self setMyLongitude:nil];
    [self setMyLatitude:nil];
    [self setMyLongitude:nil];
    [self setMyTextView:nil];
    //[self setExampleTF:niil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    return YES;
}

@end
