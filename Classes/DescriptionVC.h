//
//  DescriptionVC.h
//  GamePlanApp
//
//  Created by Kowshik Gurram on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 This view controller is used to view the note and make changes to it.
 */

#import <UIKit/UIKit.h>
@class NotesTableViewController;
@interface DescriptionVC : UIViewController
{
    NSString* descriptionText; //contains the description string
    UINavigationController* myNav;
    UITextView *textView;
    NSString *description;
    int id;
}
@property (nonatomic, retain) NSString* descriptionText;
@property(nonatomic)int id;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) UINavigationController* myNav;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, assign) NotesTableViewController *delegate;
- (void)cancelAction;
@end
