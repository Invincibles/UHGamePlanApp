//
//  MyCalendarView.h
//  GamePlanApp
//
//  Created by Kowshik Gurram on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KalViewController;

@interface MyCalendarView : NSObject<UITableViewDelegate,UIApplicationDelegate>
{
    UIWindow *window;
    UINavigationController *navController;
    KalViewController *calendar;
    id dataSource;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
