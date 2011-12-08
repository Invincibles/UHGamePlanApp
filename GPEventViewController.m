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
     NSString* id =self.addVC.eventID;
    int fileid=self.addVC.delegate.fileVC.fileID;
     NSDate *openeddate=self.addVC.delegate.fileVC.openedDate;
    NSLog(@"%d---gp fileid",fileid);
    NSDate *now = [NSDate date]; 
    NSString* query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"insert into eventTable (eventid,fid,eventDate) values ('%@',%d,'%@')",id,fileid,now]];
    NSLog(@"%@", query);
    
    NSString* query1 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"UPDATE filehistory SET eventid='%d' WHERE fid='%d' and openeddate='%@'",id,fileid,openeddate]];
    
    NSLog(@"%@", query);
    NSLog(@"%@", query1);
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
    
    [addVC.delegate viewDidLoad];
    [addVC.delegate.tableView reloadData];
    [self dismissModalViewControllerAnimated:YES];
    
}

-(void) viewDidLoad{
    
    [super viewDidLoad];
    
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
    
    UIBarButtonItem* afBtn = [[UIBarButtonItem alloc] initWithTitle:@"Add To File" style:UIBarButtonItemStylePlain target:self action:@selector(addToFile:)];
    self.navigationItem.rightBarButtonItem = afBtn;
    
    NSString* query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"select eventid from eventTable where eventid='%@' and fid='%d'",id,fileid]];
    NSLog(@"%@", query);
    
    FMResultSet *rs=[dbManager.db executeQuery:query];
    
    if([rs next])
        [afBtn setEnabled:NO];
    else
        [afBtn setEnabled:YES];
    
    [rs close];
    [dbManager.db close];
    [dbManager release];
    [query release];
    [afBtn release];
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
