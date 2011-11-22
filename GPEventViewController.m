//
//  GPEventViewController.m
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 11/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GPEventViewController.h"
#import "AddEventToFileViewController.h"
#import "databaseManager.h"
#import "ViewFileEventsController.h"
#import "FileViewController.h"

@implementation GPEventViewController

@synthesize eventsList, eventStore, defaultCalendar, eventIdentifier, addVC;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) addToFile:(id)sender
{
    /*
    for(EKEvent* obj in self.addVC.eventsList){
        if([[obj eventIdentifier] isEqualToString:self.addVC.eventID]){
            //contact is already added to the list
            NSLog(@"event already tagged to the file.");
            [self dismissModalViewControllerAnimated:YES];
            return;
        }
    }
     */
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
     NSString* id =self.addVC.eventID;
    int fileid=self.addVC.delegate.fileVC.fileID;
    NSLog(@"%d---gp fileid",fileid);
    NSDate *now = [NSDate date]; 
    NSString* query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"insert into eventTable (eventid,fid,eventDate) values ('%@',%d,'%@')",id,fileid,now]];
    NSLog(@"%@", query);
    BOOL suc = [dbManager.db executeUpdate:query];
    if(suc)
        NSLog(@"insert is successful.");
    else
        NSLog(@"insert failed.");
    
    [dbManager.db close];
    [addVC.delegate viewDidLoad];
    [addVC.delegate.tableView reloadData];
    [self dismissModalViewControllerAnimated:YES];
    
    
    //EKEvent *event;
    
   // NSLog(@"GPEvent VC's current event ID = %@ ",addVC.eventIdentifier );
    
   
    
}

-(void) viewDidLoad{
    
   
    
    [super viewDidLoad];
    UIBarButtonItem* afBtn = [[UIBarButtonItem alloc] initWithTitle:@"Add To File" style:UIBarButtonItemStylePlain target:self action:@selector(addToFile:)];
    self.navigationItem.rightBarButtonItem = afBtn;
    NSLog(@"coming to view did load...");
}

- (void)dealloc
{
    //[addVC release];
    [eventStore release];
    [eventsList release];
    [defaultCalendar release];
    [eventIdentifier release];
    
    [super dealloc];
}


@end
