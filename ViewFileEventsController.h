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
    EKEventStore *eventStore;
    EKEventStore *fileEventStore;
    NSMutableArray *eventsList;
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

-(NSArray *)getEvents;
-(NSMutableArray *)getEventsOfFile;

@end
