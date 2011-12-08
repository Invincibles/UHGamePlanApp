//
//  ManagedContactViewController.h
//  MultipleDetailViews
//
//  Created by Invincibles on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 This UIViewController appears when a user clicks contacts in the root view.
 It makes use of built in delegates ABPeoplePickerNavigationControllerDelegate to handle editing an exisiting contact,
 ABNewPersonViewControllerDelegate to handle adding a new contact,
 ABPersonViewControllerDelegate to handle viewing a contact
 */

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
- (IBAction)addNewContact:(id)sender; //this method is called when you click on add contacts
- (IBAction)viewContact:(id)sender; //this method is called when you click on view contacts
- (IBAction)editContact:(id)sender; //this method is called when you click on manage contacts

@end
