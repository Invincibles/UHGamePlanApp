//
//  ViewFileEventsController.h
//  GamePlanApp
//
//  Created by Kowshik Gurram on 11/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEventToFileViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@class FileViewController;
@interface ViewFileEventsController : UITableViewController<EKEventEditViewDelegate>
{
    UINavigationController *myNavigationController;
    EKEventViewController *eventViewController;
    //eventStore corresponding to the events of a file
    EKEventStore *eventStore;
    //eventStore corresponding to all the events of the calendar
    EKEventStore *fileEventStore;
    //events corresponding to a file
    NSMutableArray *eventsList;
    //eventsList contains all the event id's of the events in the calendar
    NSMutableArray *fileEventsList;
    EKCalendar *defaultCalendar;
     int rowcount;
}
@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) EKEventStore *fileEventStore;
@property (nonatomic, retain) NSMutableArray *eventsList;
@property (nonatomic, retain) NSMutableArray *fileEventsList;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (nonatomic, retain) UINavigationController *myNavigationController;
@property (nonatomic, retain) EKEventViewController *eventViewController;
@property(nonatomic,retain)FileViewController *fileVC;

////fetches all the events in a particular date range
-(NSArray *)getEvents;
//fetches all the events corresponding to a file
-(NSMutableArray *)getEventsOfFile;

@end
