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
    EKEventStore *eventStore;
    NSMutableArray *eventsList;
    EKCalendar *defaultCalendar;
    GPEventViewController *eventViewController;
    NSString *eventIdentifier;
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
