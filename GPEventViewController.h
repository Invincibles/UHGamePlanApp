//
//  GPEventViewController.h
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 11/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>


@class AddEventToFileViewController;
//@class ViewFileEventsController;

@interface GPEventViewController : EKEventViewController
{
    //AddEventToFileViewController *addVC;
   /*
    EKEventStore *eventStore;
    NSMutableArray *eventsList;
    EKCalendar *defaultCalendar;
    NSString *eventIdentifier; 
    */
}
@property (nonatomic, assign) AddEventToFileViewController *addVC;
@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) NSMutableArray *eventsList;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (nonatomic, readonly) NSString *eventIdentifier;
//@property (nonatomic, assign) ViewFileEventsController* delegate;

@end
