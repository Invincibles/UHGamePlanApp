//
//  MyCalendarView.m
//  GamePlanApp
//
//  Created by Kowshik Gurram on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyCalendarView.h"
#import "EventKitDataSource.h"
#import "Kal.h"

#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@implementation MyCalendarView

@synthesize window;
- (id)init
{
    self = [super init];
    if (self) {
        /*
         *    Kal Initialization
         *
         * When the calendar is first displayed to the user, Kal will automatically select today's date.
         * If your application requires an arbitrary starting date, use -[KalViewController initWithSelectedDate:]
         * instead of -[KalViewController init].
         */
        calendar = [[KalViewController alloc] init];
        calendar.title = @"NativeCal";
        
        /*
         *    Kal Configuration
         *
         */
        calendar.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStyleBordered target:self action:@selector(showAndSelectToday)] autorelease];
        
        calendar.delegate = self;
        dataSource = [[EventKitDataSource alloc] init];
        calendar.dataSource = dataSource;
        
        // Setup the navigation stack and display it.
        navController = [[UINavigationController alloc] initWithRootViewController:calendar];
        [window addSubview:navController.view];
        [window makeKeyAndVisible];
//        [calendar presentModalViewController:calendar animated:YES];
        // Initialization code here.
    }
    
    return self;
}

// Action handler for the navigation bar's right bar button item.
- (void)showAndSelectToday
{
    [calendar showAndSelectDate:[NSDate date]];
}

#pragma mark UITableViewDelegate protocol conformance

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Display a details screen for the selected event/row.
    EKEventViewController *vc = [[[EKEventViewController alloc] init] autorelease];
    vc.event = [dataSource eventAtIndexPath:indexPath];
    vc.allowsEditing = NO;
    [navController pushViewController:vc animated:YES];
}

- (void)dealloc
{
    [calendar release];
    [dataSource release];
    [window release];
    [navController release];
    [super dealloc];
}



@end
