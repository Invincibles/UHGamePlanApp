//
//  GPPersonViewController.m
//  GamePlanApp
//
//  Created by Roshan Reddy Mahareddy on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GPPersonViewController.h"
#import "AddContactToFileViewController.h"
#import "databaseManager.h"

@implementation GPPersonViewController 

@synthesize myNavigationController, delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        myNavigationController = [[UINavigationController alloc] initWithRootViewController:self];
    }
    
    return self;
}

-(void) addToFile:(id)sender
{
    //this the place for inserting into database
    for(NSNumber* cid in self.delegate.contactIDList){
        if([cid intValue] == (int)ABRecordGetRecordID(self.displayedPerson)){
            //contact is already added to the list
            NSLog(@"contact already tagged to the file.");
            [self dismissModalViewControllerAnimated:YES];
            return;
        }
    }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd" ];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];

    NSString *query = [NSString stringWithFormat:@"insert into contactTable (contactid, fid, taggedDate) values (%d, %d, '%@')",ABRecordGetRecordID(self.displayedPerson),self.delegate.currentFileID,dateString];
    
    [dateFormatter release];
    
    databaseManager *dbmanager = [[databaseManager alloc] init];
    [dbmanager updateNames];
    dbmanager.db = [FMDatabase databaseWithPath:dbmanager.databasePath];
    if(![dbmanager.db open])
    {
        NSLog(@"Eror: Could not connect to database.");
        [dbmanager release];
        [self dismissModalViewControllerAnimated:YES];
        return;
    }
    BOOL suc = [dbmanager.db executeUpdate:query];
    if(!suc){
        NSLog(@"Error: Inserting failed please try again.");
    }
    [dbmanager.db close];
    [dbmanager release];
    
    NSLog(@"query - %@",query);

    [self dismissModalViewControllerAnimated:YES];
    [self.delegate loadContactsList];
}

-(void) viewDidLoad{
    [super viewDidLoad];
    UIBarButtonItem* afBtn = [[UIBarButtonItem alloc] initWithTitle:@"Tag To File" style:UIBarButtonItemStylePlain target:self action:@selector(addToFile:)];
    self.navigationItem.rightBarButtonItem = afBtn;
    NSLog(@"coming to view did load...");
}

-(void) dealloc{
    [myNavigationController release];
    [super dealloc];
}

@end
