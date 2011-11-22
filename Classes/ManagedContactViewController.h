//
//  ManagedContactViewController.h
//  MultipleDetailViews
//
//  Created by Invincibles on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ManagedContactViewController : UIViewController <SubstitutableDetailViewController, ABPeoplePickerNavigationControllerDelegate, ABNewPersonViewControllerDelegate, ABPersonViewControllerDelegate>{
    
    BOOL setEdit;
    UINavigationBar *navigationBar;
}
@property (nonatomic) BOOL setEdit;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
- (IBAction)addNewContact:(id)sender;
- (IBAction)viewContact:(id)sender;
- (IBAction)editContact:(id)sender;

@end
