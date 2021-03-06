//
//  AddContactToFileViewController.m
//  GamePlanApp
//
//  Created by Roshan Reddy Mahareddy on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddContactToFileViewController.h"
#import "GPPersonViewController.h"

#import "databaseManager.h"

@implementation AddContactToFileViewController

@synthesize addressBook,mynav, contactIDList, currentFileID;

-(void) cancelEventAction:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) selectAContactAction:(id)sender
{
    NSLog(@"coming to select a contact........");
    
    NSLog(@"this is my change");
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    //changing the tint color
    picker.navigationBar.tintColor = [[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f] autorelease];
    
    picker.peoplePickerDelegate = self;
    picker.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [picker setEditing:YES animated:YES];
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
    NSLog(@"this is my change");
}

- (id)initWithStyle:(UITableViewStyle)style
{
    
    NSLog(@"in initWithStyle method.");
    
    self = [super initWithStyle:style];
    if (self) {
        
        contactIDList = [[NSMutableArray alloc] initWithCapacity:1];
        
        //initializing the addressbook object
        addressBook = ABAddressBookCreate();
        mynav = [[UINavigationController alloc] initWithRootViewController:self];
        mynav.navigationBar.tintColor = [[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f] autorelease];
        
        //left bar button item
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEventAction:)];
        
        //right bar button item
        UIBarButtonItem *selectAContactBtn = [[UIBarButtonItem alloc] initWithTitle:@"Select Contact" style:UIBarButtonItemStylePlain target:self action:@selector(selectAContactAction:)];
        
        self.navigationItem.leftBarButtonItem = cancelButton;
        self.navigationItem.rightBarButtonItem = selectAContactBtn;
        
        [selectAContactBtn release];
        [cancelButton release];
        
        //[self loadContactsList];
    }
    return self;
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
		   editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSUInteger rownumber = [indexPath row];
    NSUInteger count = [contactIDList count];
	
    if (rownumber < count) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

//this function is called when you delete a tagged contact, swipe on any cell delete button appears
- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rownumber = [indexPath row];
    NSUInteger count = [contactIDList count];
    
    //checking if the swip operation is on the currect table cell
    if (rownumber < count) {
        
        databaseManager *dbManager=[[databaseManager alloc] init];
        [dbManager updateNames];
        dbManager.db = [FMDatabase databaseWithPath:dbManager.databasePath];
        NSLog(@"path--- %@",dbManager.databasePath);
        if(![dbManager.db open]){
            NSLog(@"Could not open db.");
            [dbManager release];
            return;
        }
        else{
            NSLog(@"database is open.");
        }
        //delete contact from database
        NSString* query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"delete from contactTable where contactid=%d",[[contactIDList objectAtIndex:rownumber] intValue]]];
        NSLog(@"%@", query);
        BOOL suc = [dbManager.db executeUpdate:query];
        if(suc)
            NSLog(@"delete is successful.");
        else
            NSLog(@"delete failed.");
        
        [query release];
        [dbManager.db close];
        [dbManager release];
        
        [self loadContactsList];
        
    }
}

- (void)tableView:(UITableView *)tableView 
didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView reloadData];
}


//this function is used to read contact ids of contacts already tagged to this file
-(void) loadContactsList
{
    //remove exisiting contacts
    [contactIDList removeAllObjects];
    
    //get contacts from database
    NSString* query = [NSString stringWithFormat:@"select contactid from contactTable where fid = %d",self.currentFileID];
    NSLog(@"select query - %@",query);
    
    databaseManager* dbmanager = [[databaseManager alloc] init];
    [dbmanager updateNames];
    dbmanager.db = [FMDatabase databaseWithPath:dbmanager.databasePath];
    if(![dbmanager.db open]){
        NSLog(@"Error: Could not connect to database.");
        [dbmanager release];
        return;
    }
    
    FMResultSet* rs = [dbmanager.db executeQuery:query];
    
    if(rs == nil){
        NSLog(@"Error: result set is nil.");
        [dbmanager release];
        return;
    }

    while([rs next]){
        //storing them to the array
        [contactIDList addObject:[[[NSNumber alloc] initWithInt:[rs intForColumn:@"contactid"]] autorelease]];
    }
    
    [dbmanager.db close];
    [dbmanager release];
    
    [self.tableView reloadData];
    
}

- (void)dealloc
{
    [mynav release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"celltexture.png"]];
    
    self.title = @"Tagged Contacts";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return ABAddressBookGetPersonCount(addressBook);
    return [contactIDList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ABRecordRef person1 = ABAddressBookGetPersonWithRecordID(addressBook, (ABRecordID)[[contactIDList objectAtIndex:indexPath.row] intValue]);
    
    // Configure the cell...
    NSString* name = @"";
    if(person1 != nil)
        name = (NSString*)ABRecordCopyCompositeName(person1);
    cell.textLabel.text = [NSString stringWithString:name];
    cell.textLabel.textColor = [[UIColor colorWithRed:(154.0/255.0f) green:(176.0/255.0f) blue:(44.0/255.0f) alpha:1.0f] autorelease];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, (ABRecordID)[[contactIDList objectAtIndex:indexPath.row] intValue]);
    
    ABPersonViewController *controller = [[ABPersonViewController alloc] init];
    controller.displayedPerson = person;
    controller.personViewDelegate = self;
        
    [self.mynav pushViewController:controller animated:YES]; //pushing view controller on to peoplePicker
    [controller release];
    
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
        ABRecordID uid = ABRecordGetRecordID(person);
        NSLog(@"uid = %d",uid);
        
        NSString* name = (NSString*)ABRecordCopyCompositeName(person);
        NSLog(@"Full Name : %@", name);    
        [name release];
        
        GPPersonViewController *controller = [[GPPersonViewController alloc] init];
        controller.displayedPerson = person;
        controller.personViewDelegate = self;
        controller.delegate = self;
        [peoplePicker pushViewController:controller animated:YES]; //pushing view controller on to peoplePicker
        [controller release];
        
        return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier{
    return YES;
}

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
    ABPeoplePickerNavigationController *peoplePicker = (ABPeoplePickerNavigationController *)personViewController.navigationController;
    [peoplePicker dismissModalViewControllerAnimated:YES];
    
    return YES;
}

@end
