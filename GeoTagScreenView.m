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

-(void) doneAction:(id)sender
{
  
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
    
    int fileid=self.fileVC.fileID;
    NSString* dt = [[NSString alloc] initWithString: @"11/11/2"];
    NSString* query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"insert into geotagTable (fid,latitude,longitude,description,geotagDate) values (%d,'%@','%@','%@','%@')",fileid,myLatitude.text,myLongitude.text,myTextView.text,dt]];
    NSLog(@"%@",query);
    BOOL suc = [dbManager.db executeUpdate:query];
    if(suc)
        NSLog(@"insert is successful.");
    else
        NSLog(@"insert failed.");
    
    [dbManager.db close];
    [self dismissModalViewControllerAnimated:YES]; 
   
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        navigator = [[UINavigationController alloc] initWithRootViewController:self];
        navigator.navigationBar.tintColor = [[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction:)];
        
        self.navigationItem.rightBarButtonItem = cancelButton;
        self.navigationItem.leftBarButtonItem = doneButton;
        
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
