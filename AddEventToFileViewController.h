//
//  AddEventToFileViewController.h
//  GamePlanApp
//
//  Created by Kowshik Gurram on 11/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "GPEventViewController.h"

@class ViewFileEventsController;

@interface AddEventToFileViewController : UITableViewController<UINavigationBarDelegate, UITableViewDelegate, 
EKEventEditViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    //eventStore stores all the events in the default iPad Calendar
    EKEventStore *eventStore;
    //eventsList contains all the event id's of the events in the calendar
    NSMutableArray *eventsList;
    EKCalendar *defaultCalendar;
    GPEventViewController *eventViewController;
    //the unique id of an event
    NSString *eventIdentifier;
    //controller which allows the user to edit an event
    EKEventEditViewController *eventEditController;
    NSString *eventID;
}
@property (nonatomic, retain) NSString* eventID;
@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) NSMutableArray *eventsList;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (nonatomic, retain) EKEventViewController *eventViewController;
@property (nonatomic, retain) EKEventEditViewController *eventEditController;
@property (nonatomic, readonly) NSString *eventIdentifier;
@property (nonatomic, assign) ViewFileEventsController* delegate;

-(NSArray *) getEventsFromNow;


@end
