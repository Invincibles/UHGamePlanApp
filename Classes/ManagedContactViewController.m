//
//  ManagedContactViewController.m
//  MultipleDetailViews
//
//  Created by Invincibles on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 All the methods of the three delegates are implemented here.
 */

#import "ManagedContactViewController.h"


@implementation ManagedContactViewController
@synthesize navigationBar,setEdit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        setEdit = FALSE;
    }
    return self;
}

- (void)dealloc
{
    [navigationBar release];
    [super dealloc];
}

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    // Add the popover button to the left navigation item.
    [navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:NO];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    // Remove the popover button.
    [navigationBar.topItem setLeftBarButtonItem:nil animated:NO];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setNavigationBar:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


//this function handles the new contact functionality
- (IBAction)addNewContact:(id)sender {
    
    //ABNewPersonViewController displays the screen to read a new contact
    ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
    picker.newPersonViewDelegate = self;
    
    //creating a naviation controller to present the view controller
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:picker];
    //setting the navigation bar to requried color
    navigation.navigationBar.tintColor = [[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    //defining style for presenting it
    navigation.modalPresentationStyle=UIModalPresentationFormSheet;
    //presenting the view controller
    [self presentModalViewController:navigation animated:YES];
    [picker release];
    [navigation release];
    [picker release];
}

//this method is called when cancel button is pressed
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
    //we are dismissing the controller here
    [self dismissModalViewControllerAnimated:YES];
}

//this function handles the view contact functionality
- (IBAction)viewContact:(id)sender {
    
    self.setEdit = FALSE; //in order to get the mode to view we should have setEdit to false
    
    //ABPeoplePickerNavigationController displays list of all contacts
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    //we sent the color of navigation bar here
    picker.navigationBar.tintColor = [[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    picker.peoplePickerDelegate = self;
    picker.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [picker setEditing:YES animated:YES];
    //presenting the picker here
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

//this function handles the edit contact functionality
- (IBAction)editContact:(id)sender {
    
    self.setEdit = TRUE; //in order to get the mode to edit we should have setEdit to true
    
    //ABPeoplePickerNavigationController displays list of all contacts
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.navigationBar.tintColor = [[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    picker.peoplePickerDelegate = self;
    picker.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

//comes here when we press cancel button
- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker {
    //we dismiss the controller here
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    //this method is common to both view and edit contact, this is called when we select a contact, if setEdit is true then edit button appear to the right top of the controller
    if(self.setEdit)
    {
        NSString* name = (NSString*)ABRecordCopyCompositeName(person); // we are reading the name of selected contact
        NSLog(@"Full Name : %@", name);    
        [name release];
        
        //ABPersonViewController will show the details of the contact
        ABPersonViewController *controller = [[ABPersonViewController alloc] init];
        controller.displayedPerson = person;
        controller.allowsEditing = TRUE; //inorder to have edit button
        controller.personViewDelegate = self;
        [peoplePicker pushViewController:controller animated:YES]; //pushing view controller on to peoplePicker
        [controller release];
    
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier{
    return YES;
}

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person 
                    property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
    ABPeoplePickerNavigationController *peoplePicker = (ABPeoplePickerNavigationController *)personViewController.navigationController;
    [peoplePicker dismissModalViewControllerAnimated:YES];
    
    return YES;
}

@end