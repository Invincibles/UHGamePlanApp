//
//  MyEventManager.h
//  MultipleDetailViews
//
//  Created by Invincibles on 11/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface MyEventManager : UITableViewController <UINavigationBarDelegate, UITableViewDelegate, 
EKEventEditViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    UINavigationController* myNavigationController;
    
    //eventStore stores all the events in the default iPad Calendar
    EKEventStore *eventStore;
    //eventsList contains all the event id's of the events in the calendar
    NSMutableArray *eventsList;
    EKCalendar *defaultCalendar;
    //controller to simply view the events
    EKEventViewController *eventViewController;
    //the unique id of an event
    NSString *eventIdentifier;
    //controller which allows the user to edit an event
    EKEventEditViewController *eventEditController;
}

@property (nonatomic, retain) UINavigationController* myNavigationController;
@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) NSMutableArray *eventsList;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (nonatomic, retain) EKEventViewController *eventViewController;
@property (nonatomic, retain) EKEventEditViewController *eventEditController;
@property (nonatomic, readonly) NSString *eventIdentifier;

//fetches all the events in a particular date range
-(NSArray *) getEvents;
@end
