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


//this function is called when you tag a contact to file
-(void) addToFile:(id)sender
{
    //we are checking if the contact is already tagged to the file
    for(NSNumber* cid in self.delegate.contactIDList){
        if([cid intValue] == (int)ABRecordGetRecordID(self.displayedPerson)){
            //contact is already added to the list
            NSLog(@"contact already tagged to the file.");
            [self dismissModalViewControllerAnimated:YES];
            return;
        }
    }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd" ];//get today date
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];

    //inseting the contact to database
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
    //dismiss the control once the tagging is done
    [self dismissModalViewControllerAnimated:YES];
    //reload the contacts list because we made changes to the list
    [self.delegate loadContactsList];
}

-(void) viewDidLoad{
    [super viewDidLoad];
    //creating a button
    UIBarButtonItem* afBtn = [[UIBarButtonItem alloc] initWithTitle:@"Tag To File" style:UIBarButtonItemStylePlain target:self action:@selector(addToFile:)];
    //adding it to navigation bar
    self.navigationItem.rightBarButtonItem = afBtn;
    [afBtn release];
}

-(void) dealloc{
    [myNavigationController release];
    [super dealloc];
}

@end
