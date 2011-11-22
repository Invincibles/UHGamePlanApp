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
    
    EKEventStore *eventStore;
    NSMutableArray *eventsList;
    EKCalendar *defaultCalendar;
    EKEventViewController *eventViewController;
    NSString *eventIdentifier;
    EKEventEditViewController *eventEditController;
}

@property (nonatomic, retain) UINavigationController* myNavigationController;
@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) NSMutableArray *eventsList;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (nonatomic, retain) EKEventViewController *eventViewController;
@property (nonatomic, retain) EKEventEditViewController *eventEditController;
@property (nonatomic, readonly) NSString *eventIdentifier;

-(NSArray *) getEvents;
@end
