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
<<<<<<< HEAD

//Method to Add an Event - called when clicked on the icon in the details view
=======
@property (nonatomic, retain) KalViewController *calendar;
>>>>>>> 1e49b79f50e5b7d24b20cac1319fca8438552d04
- (IBAction)addEvent:(id)sender;
- (IBAction)viewCalendar:(id)sender;
@end
