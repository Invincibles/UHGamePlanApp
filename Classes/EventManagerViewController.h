//
//  EventManagerViewController.h
//  MultipleDetailViews
//
//  Created by Invincibles on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface EventManagerViewController : UIViewController <SubstitutableDetailViewController, UINavigationBarDelegate>{
    
    UINavigationBar *navigationBar;
}
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;

//Method to Add an Event - called when clicked on the icon in the details view
- (IBAction)addEvent:(id)sender;
@end
