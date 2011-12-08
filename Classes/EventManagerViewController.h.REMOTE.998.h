//
//  EventManagerViewController.h
//  MultipleDetailViews
//
//  Created by Invincibles on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@class KalViewController;

@interface EventManagerViewController : UIViewController <SubstitutableDetailViewController, UINavigationBarDelegate,UITableViewDelegate>{
    UINavigationController *mynav;
    UINavigationBar *navigationBar;
    KalViewController *calendar;
    id dataSource;
    
}
@property (nonatomic, retain) UINavigationController *mynav;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) KalViewController *calendar;
- (IBAction)addEvent:(id)sender;
- (IBAction)viewCalendar:(id)sender;
@end
