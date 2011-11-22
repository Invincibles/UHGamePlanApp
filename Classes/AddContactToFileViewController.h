//
//  AddContactToFileViewController.h
//  GamePlanApp
//
//  Created by Roshan Reddy Mahareddy on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface AddContactToFileViewController : UITableViewController <ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate> {
    ABAddressBookRef addressBook;
    UINavigationController *mynav;
    NSMutableArray *contactIDList;
    int currentFileID;
}

@property (nonatomic) ABAddressBookRef addressBook;
@property (nonatomic, retain) UINavigationController *mynav;
@property (nonatomic, retain) NSMutableArray *contactIDList;
@property (nonatomic) int currentFileID;

-(void) loadContactsList;

@end
