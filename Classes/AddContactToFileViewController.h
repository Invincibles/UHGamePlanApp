//
//  AddContactToFileViewController.h
//  GamePlanApp
//
//  Created by Roshan Reddy Mahareddy on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 This view controller is used to display all the contacts that are tagged to the file. When you click on the contact you can view the details of that contact, you can delete the tagged contact and tag new contact to the file.
 */

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface AddContactToFileViewController : UITableViewController <ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate> {
    ABAddressBookRef addressBook; //it is a reference to address book on ipad, we can get the contacts from this object
    UINavigationController *mynav;
    NSMutableArray *contactIDList; //it contains the list of contact ids that are already tagged to the file
    int currentFileID; //it contains the current file id
}

@property (nonatomic) ABAddressBookRef addressBook;
@property (nonatomic, retain) UINavigationController *mynav;
@property (nonatomic, retain) NSMutableArray *contactIDList;
@property (nonatomic) int currentFileID;

-(void) loadContactsList;

@end
