//
//  EventManagerViewController.m
//  MultipleDetailViews
//
//  Created by Invincibles on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventManagerViewController.h"
#import "MyEventManager.h"
#import "EventKitDataSource.h"
#import "KalViewController.h"
#import "Kal.h"

#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@implementation EventManagerViewController
@synthesize navigationBar,calendar,mynav;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [calendar release];
    [navigationBar release];
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
    [self setNavigationBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    // Add the popover button to the left navigation item.
    [navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:NO];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    // Remove the popover button.
    [navigationBar.topItem setLeftBarButtonItem:nil animated:NO];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


- (IBAction)addEvent:(id)sender {
    MyEventManager *myObj = [[MyEventManager alloc] init];
    myObj.navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:myObj.navigationController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Display a details screen for the selected event/row.
    EKEventViewController *vc = [[[EKEventViewController alloc] init] autorelease];
    vc.event = [dataSource eventAtIndexPath:indexPath];
    vc.allowsEditing = NO;
    [mynav pushViewController:vc animated:YES];
}

- (IBAction)viewCalendar:(id)sender {
    NSLog(@"coming here....");
    calendar = [[[KalViewController alloc] init] autorelease];
   // MyCalendarView *calView = [[MyCalendarView alloc] init];
   
    calendar.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelCalendar)] autorelease];
    
     calendar.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStylePlain target:self action:@selector(showAndSelectToday)] autorelease];
    calendar.delegate = self;
    dataSource = [[EventKitDataSource alloc] init];
    calendar.dataSource = dataSource;
    
    mynav = [[UINavigationController alloc] initWithRootViewController:calendar];
    
    mynav.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentModalViewController:mynav animated:YES];

}

- (void)showAndSelectToday
{
    [calendar showAndSelectDate:[NSDate date]];
}

-(void)cancelCalendar
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
