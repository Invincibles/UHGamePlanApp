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

@synthesize eventsList, eventStore, defaultCalendar, myNavigationController, eventViewController,fileVC, fileEventsList, fileEventStore;

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
    [fileEventStore release];
    [fileEventsList release];
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
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"celltexture.png"]];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEventAction:)];
    UIBarButtonItem *selectEventButton = [[UIBarButtonItem alloc] initWithTitle:@"Select Event" style:UIBarButtonItemStylePlain target:self action:@selector(selectEventAction:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = selectEventButton;
    
    [cancelButton release];
    [selectEventButton release];
    
    // Initialize an event store object with the init method. Initilize the array for events.
	self.eventStore = [[EKEventStore alloc] init];
    
    self.fileEventStore = [[EKEventStore alloc] init];
    
	self.eventsList = [[NSMutableArray alloc] initWithArray:0];
    
    self.fileEventsList = [[NSMutableArray alloc] initWithArray:0];
	
	// Get the default calendar from store.
	self.defaultCalendar = [self.eventStore defaultCalendarForNewEvents];
    
    //self.myNavigationController.delegate = self;
    
	// Fetch today's event on selected calendar and put them into the eventsList array
    [self.fileEventsList addObjectsFromArray:[self getEvents]];
    
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
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:CellIdentifier] autorelease];
	}

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

	// Get the event at the row selected and display it's title
    
	cell.textLabel.text = [[self.eventsList objectAtIndex:indexPath.row] title];
    cell.textLabel.textColor = [UIColor colorWithRed:(154.0/255.0f) green:(176.0/255.0f) blue:(44.0/255.0f) alpha:1.0f];
    //154,176,44
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

-(NSArray *)getEvents{
    
	NSDate *startDate = [NSDate date];
	
	// endDate is 1 day = 60*60*24 seconds = 86400 seconds from startDate
	NSDate *endDate = [NSDate distantFuture];
	
	// Create the predicate. Pass it the default calendar.
	NSArray *calendarArray = [NSArray arrayWithObject:defaultCalendar];
	NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:calendarArray]; 
	
	// Fetch all events that match the predicate.
	NSArray *events = [self.fileEventStore eventsMatchingPredicate:predicate];
    
	return events;
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
    /*
    NSString* query1 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"select count(*) as Count from eventTable where fid=%d",fileid]];
    NSLog(@"%@", query1);
    
    FMResultSet *rsCount=[dbManager.db executeQuery:query1];
    
    while([rsCount next])
    {
        rowcount=[rsCount intForColumn:@"Count"];
        NSLog(@"%d------rowcount",rowcount);  
    }
    */
    rowcount = 0;
    BOOL isPresent = FALSE;
    while([rs next]) 
    {
        
        id=[rs stringForColumn:@"eventid"];
        NSLog(@"%@----->1",id);
            
        NSLog(@"count of total events - %d",[fileEventsList count]);
            
        for(EKEvent *myEvent in fileEventsList)
        {
            NSString *myEventID = [myEvent eventIdentifier];
            NSLog(@"myEventID - %@",myEventID);
            if([myEventID isEqualToString:id])
            {
                NSLog(@"myEvent eventIdentifier....%@",[myEvent eventIdentifier]);
                isPresent = TRUE;
                break;
            }
        }
            
        if(isPresent){
            rowcount++;
            EKEvent *event=[self.eventStore eventWithIdentifier:id];
            [events addObject:event];
        }
        else{
            NSString* query1 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"delete from eventTable where eventid = '%@' and fid = '%d'",id,fileid]];
            NSLog(@"%@", query1);
            BOOL suc2 = [dbManager.db executeUpdate:query1];
        }
        isPresent = FALSE;
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
