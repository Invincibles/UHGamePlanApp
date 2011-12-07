//
//  MyEventManager.m
//  MultipleDetailViews
//
//  Created by Invincibles on 11/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddEventToFileViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "ViewFileEventsController.h"
#import "GPEventViewController.h"

@implementation AddEventToFileViewController

@synthesize eventsList, eventStore, defaultCalendar, eventViewController, eventIdentifier, eventEditController,eventID, delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}


- (void)dealloc
{
    [eventStore release];
    [eventsList release];
    [defaultCalendar release];
    [eventViewController release];
    [eventIdentifier release];
    [eventEditController release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(EKEvent *)eventWithIdentifier:(NSString *)eventID{
    
    EKEvent *myEvent = [[EKEvent alloc] init];
    
    return myEvent;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.title = @"Events List";
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"celltexture.png"]];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"File Events" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEventAction:)];
    UIBarButtonItem *addEventButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                       UIBarButtonSystemItemAdd target:self action:@selector(addEventAction:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = addEventButton;
    [cancelButton release];
    [addEventButton release];
	
	// Initialize an event store object with the init method. Initilize the array for events.
	self.eventStore = [[EKEventStore alloc] init];
        
	self.eventsList = [[NSMutableArray alloc] initWithArray:0];
	
	// Get the default calendar from store.
	self.defaultCalendar = [self.eventStore defaultCalendarForNewEvents];
    
    //self.myNavigationController.delegate = self;
    
	// Fetch today's event on selected calendar and put them into the eventsList array
	[self.eventsList addObjectsFromArray:[self getEventsFromNow]];

	[self.tableView reloadData];
    
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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


#pragma mark -
#pragma mark Navigation Controller delegate

- (void)navigationController:(UINavigationController *)navigationController 
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	// if we are navigating back to the rootViewController, and the detailViewController's event
	// has been deleted -  with title being NULL, then remove the events from the eventsList
	// and reload the table view. This takes care of reloading the table view after adding an event too.
    
	if (viewController == self && self.eventViewController.event.title == NULL) {
		[self.eventsList removeObject:self.eventViewController.event];
		[self.tableView reloadData];
	}
    else{
        
    }
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
    return eventsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	
	// Add disclosure triangle to cell
	//UITableViewCellAccessoryType editableCellAccessoryType =UITableViewCellAccessoryDisclosureIndicator;
    
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:CellIdentifier] autorelease];
	}
	
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	// Get the event at the row selected and display it's title
	cell.textLabel.text = [[self.eventsList objectAtIndex:indexPath.row] title];
    
    cell.textLabel.textColor = [UIColor colorWithRed:(154.0/255.0f) green:(176.0/255.0f) blue:(44.0/255.0f) alpha:1.0f];
    
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
    
    eventViewController = [[GPEventViewController alloc] initWithNibName:@"nil" bundle:nil];
    
    
    eventViewController.addVC=self;
    
    eventViewController.event = [self.eventsList objectAtIndex:indexPath.row];
    
    
    eventID = eventViewController.event.eventIdentifier;
            
    eventViewController.allowsEditing = YES;
    
    eventViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    eventViewController.addVC = self;
    //eventViewController.delegate = self.delegate;
    [self.navigationController pushViewController:eventViewController animated:YES];
    
    [eventViewController release];
        
}


-(void) eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action{
    
    NSError *error = nil;
    EKEvent *currentEvent = controller.event;
    
    switch (action) {
		case EKEventEditViewActionCanceled:
			// Edit action canceled, do nothing. 
			break;
			
		case EKEventEditViewActionSaved:
			// When user hit "Done" button, save the newly created event to the event store, 
			// and reload table view.
			// If the new event is being added to the default calendar, then update its 
			// eventsList.
			if (self.defaultCalendar ==  currentEvent.calendar) {
				[self.eventsList addObject:currentEvent];
			}
			[controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
			[self.tableView reloadData];
			break;
			
		case EKEventEditViewActionDeleted:
			// When deleting an event, remove the event from the event store, 
			// and reload table view.
			// If deleting an event from the current default calendar, then update its 
			// eventsList.
			if (self.defaultCalendar ==  currentEvent.calendar) {
				[self.eventsList removeObject:currentEvent];
			}
			[controller.eventStore removeEvent:currentEvent span:EKSpanThisEvent error:&error];
			[self.tableView reloadData];
			break;
			
		default:
			break;
	}
	// Dismiss the modal view controller
	[controller dismissModalViewControllerAnimated:YES];
    
}

// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller {
	EKCalendar *calendarForEdit = self.defaultCalendar;
	return calendarForEdit;
}

-(NSArray *)getEventsFromNow{
    
	NSDate *startDate = [NSDate date];
	
	// endDate is 1 day = 60*60*24 seconds = 86400 seconds from startDate
	//NSDate *endDate = [NSDate distantFuture];
	
	// Create the predicate. Pass it the default calendar.
	NSArray *calendarArray = [NSArray arrayWithObject:defaultCalendar];
  
    //Getting the event wrt to the event identifier into myEvents array
    //NSArray *myEvents = [self.eventStore eventWithIdentifier:eventIdentifier];
	
    
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate endDate:[NSDate distantFuture] calendars:calendarArray]; 
	
	// Fetch all events that match the predicate.
	NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];
    
	return events;
}

-(void) addEventAction:(id)sender
{
    EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
	
	// set the addController's event store to the current event store.
	addController.eventStore = self.eventStore;
	
    addController.navigationBar.tintColor = [[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    
	// present EventsAddViewController as a modal view controller
    addController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentModalViewController:addController animated:YES];
	
	addController.editViewDelegate = self;
	[addController release];
    
}

-(void) editEventAction:(id) sender{
    EKEventEditViewController *editController = [[EKEventEditViewController alloc]initWithNibName:nil bundle:nil];
    
    editController.navigationBar.tintColor = [[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    
    
}

-(void) cancelEventAction:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
