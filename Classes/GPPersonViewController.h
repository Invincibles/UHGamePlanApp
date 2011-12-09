//
//  GPPersonViewController.h
//  GamePlanApp
//
//  Created by Roshan Reddy Mahareddy on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 In this class we inherit the ABPersonViewController to customize it according to our requirement. We need a tag to file button instead of an edit button.
 */

#import <Foundation/Foundation.h>
#import "AddressBook/AddressBook.h"
#import "AddressBookUI/AddressBookUI.h"

@class AddContactToFileViewController;
@interface GPPersonViewController : ABPersonViewController {
    UINavigationController *myNavigationController;
}

@property (nonatomic, retain) UINavigationController *myNavigationController;
@property (nonatomic, retain) AddContactToFileViewController *delegate;

-(void) addToFile:(id)sender;

@end
