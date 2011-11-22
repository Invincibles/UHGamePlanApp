//
//  ViewFileEventsController.m
//  GamePlanApp
//
//  Created by Kowshik Gurram on 11/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewFileEventsController.h"
#import "AddEventToFileViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "databaseManager.h"
#import "FileViewController.h"

@implementation ViewFileEventsController

@synthesize eventsList, eventStore, defaultCalendar, myNavigationController, eventViewController,fileVC;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
       
        
    }
    return self;
}

-(void)dealloc
{
    [eventStore release];
    [eventsList release];
    [defaultCalendar release];
    [myNavigationController release];
    [eventViewController release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(EKEvent *)eventWithIdentifier:(NSString *)eventID{
    EKEvent *myEvent = [[EKEvent alloc] init];
    
    return myEvent;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Custom initialization
    self.title = @"File Events";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEventAction:)];
    UIBarButtonItem *selectEventButton = [[UIBarButtonItem alloc] initWithTitle:@"Select Event" style:UIBarButtonItemStylePlain target:self action:@selector(selectEventAction:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = selectEventButton;
    
    [cancelButton release];
    [selectEventButton release];
    
    // Initialize an event store object with the init method. Initilize the array for events.
	self.eventStore = [[EKEventStore alloc] init];
    
	self.eventsList = [[NSMutableArray alloc] initWithArray:0];
	
	// Get the default calendar from store.
	self.defaultCalendar = [self.eventStore defaultCalendarForNewEvents];
    
    //self.myNavigationController.delegate = self;
    
	// Fetch today's event on selected calendar and put them into the eventsList array
	[self.eventsList addObjectsFromArray:[self getEventsOfFile]];
    
    //loop over with the number of eventID in the eventTable for the file and get those events into an an array in getEventOfFile method and then call that method above to copy that array values into eventsList
    /*
    NSString *eventID = @"3AF9461C-FE42-496D-9096-9B0AE00C1C2A:1A42197B-C8EB-47E9-8AF7-7BEA995E4119";
    EKEvent *event = [self.eventStore eventWithIdentifier:eventID];
    
    NSLog(@"%@ = event in view files",event);
    */

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return rowcount;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	
	// Add disclosure triangle to cell
	UITableViewCellAccessoryType editableCellAccessoryType =UITableViewCellAccessoryDisclosureIndicator;
    
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.accessoryType = editableCellAccessoryType;
    
	// Get the event at the row selected and display it's title
  //  NSLog(@"%@ in cell",[[self.eventsList objectAtIndex:indexPath.row] title]);
	cell.textLabel.text = [[self.eventsList objectAtIndex:indexPath.row] title];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    eventViewController = [[EKEventViewController alloc] initWithNibName:@"nil" bundle:nil];
    
    eventViewController.event = [self.eventsList objectAtIndex:indexPath.row];
    
    eventViewController.allowsEditing = NO;
    
    eventViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self.navigationController pushViewController:eventViewController animated:YES];
    
    [eventViewController release];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
		   editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSUInteger rownumber = [indexPath row];
    NSUInteger count = [eventsList count];
	
    if (rownumber < count) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}


- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rownumber = [indexPath row];
    NSUInteger count = [eventsList count];
    
    
    if (rownumber < count) {
        
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
        NSLog(@"%@---event id",[eventsList objectAtIndex:rownumber]);
        EKEvent *event = [eventsList objectAtIndex:rownumber];
        NSString* query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"delete from eventTable where eventid='%@'",event.eventIdentifier]];
        NSLog(@"%@", query);
        BOOL suc = [dbManager.db executeUpdate:query];
        if(suc)
            NSLog(@"delete is successful.");
        else
            NSLog(@"delete failed.");
        
        
        
    }
    [self viewDidLoad];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView 
didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView reloadData];
}



-(NSMutableArray *)getEventsOfFile{
    
    NSLog(@"coming---");
   
   NSMutableArray *events=[[NSMutableArray alloc] init]; 
    
    NSString* id;
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
    
    int fileid=self.fileVC.fileID;
    NSString* query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"select eventid from eventTable where fid='%d'",fileid]];
    NSLog(@"%@", query);
    //BOOL suc = [dbManager.db executeUpdate:query];
    
    FMResultSet *rs=[dbManager.db executeQuery:query];
    
   //should include file id in the querry below
    
    NSString* query1 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"select count(*) as Count from eventTable where fid=%d",fileid]];
    NSLog(@"%@", query1);
    
    FMResultSet *rsCount=[dbManager.db executeQuery:query1];
    
    while([rsCount next])
    {
        rowcount=[rsCount intForColumn:@"Count"];
        NSLog(@"%d------rowcount",rowcount);  
    }
    
    
    while([rs next]) {
        id=[rs stringForColumn:@"eventid"];
        NSLog(@"%@----->1",id);
        EKEvent *event=[self.eventStore eventWithIdentifier:id];
       // NSLog(@"%@ --- EVENT",event);
        [events addObject:event];
        
  
    }
    [dbManager.db close];
    
    [self.tableView reloadData];
    

    NSLog(@"%d = event count",events.count);
    return events;
}


-(void)cancelEventAction:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)selectEventAction:(id)sender{
    AddEventToFileViewController *addEventVC=[[AddEventToFileViewController alloc] initWithNibName:@"AddEventToFileViewController"bundle:[NSBundle mainBundle]];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:addEventVC];
    nav.navigationBar.tintColor=[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    addEventVC.delegate = self;
    [self presentModalViewController:nav animated:YES];
    [addEventVC release]; 
}

@end
