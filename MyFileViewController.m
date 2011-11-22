//
//  MyFileViewController.m
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 11/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyFileViewController.h"

#import "File.h"
#import "databaseManager.h"
#import "GPFilePicker.h"

#import "ShareFilesViewController.h"

@implementation MyFileViewController

@synthesize myNav, foldername, fileslist, delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        myNav = [[UINavigationController alloc] initWithRootViewController:self];
        myNav.navigationBar.tintColor = [[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
        self.navigationItem.leftBarButtonItem = cancelButton;
        [cancelButton release];
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addAction:)];
        self.navigationItem.rightBarButtonItem = addButton;
        [addButton release];
        
        fileslist = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

-(void) reloadfileslist
{
    [fileslist removeAllObjects];
    
    databaseManager* dbmanager = [[databaseManager alloc] init];
    [dbmanager updateNames];
    dbmanager.db = [FMDatabase databaseWithPath:dbmanager.databasePath];
    if(![dbmanager.db open]){
        NSLog(@"Error: Could not connect to database.");
        return;
    }
    
    NSString* query = [NSString stringWithFormat:@"select * from filesystem where isfolder=0 and foldername = '%@'",foldername];
    
    FMResultSet* rs = [dbmanager.db executeQuery:query];
    
    if(rs == nil){
        NSLog(@"Error: result set is nil.");
        return;
    }
    
    File* myfile;
    
    while ([rs next]) {
        myfile = [[File alloc] init:[rs intForColumn:@"fid"] _filename:[rs stringForColumn:@"filename"] _isfolder:YES _foldername:[rs stringForColumn:@"foldername"] _date:[rs stringForColumn:@"creationdate"]];
        NSLog(@"--- filename - %@",[myfile filename]);
        [fileslist addObject:myfile];
    }
    
    [dbmanager.db close];
    
    [self.tableView reloadData];
}

-(void) cancelAction:(id)sender
{
    [delegate reloadFiles];
    [self dismissModalViewControllerAnimated:YES];
}

-(void) addAction:(id)sender
{
    //present the GPFilePicker
    GPFilePicker* picker = [[GPFilePicker alloc] init];
    picker.delegate = self;
    picker.myNavigator.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:picker.myNavigator animated:YES];
    [picker release];
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
    self.title = foldername;
    [self reloadfileslist];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
		   editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSUInteger rownumber = [indexPath row];
    NSUInteger count = [fileslist count];
	
    if (rownumber < count) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}


- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rownumber = [indexPath row];
    NSUInteger count = [fileslist count];
    
    if (rownumber < count) {
        
        databaseManager *dbManager=[[databaseManager alloc] init];
        [dbManager updateNames];
        dbManager.db = [FMDatabase databaseWithPath:dbManager.databasePath];
        NSLog(@"path--- %@",dbManager.databasePath);
        if(![dbManager.db open]){
            NSLog(@"Could not open db.");
            
        }
        else{
            NSLog(@"database is open.");
        }
        NSString* query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"delete from filesystem where filename='%@'",[[fileslist objectAtIndex:rownumber] filename]]];
        NSLog(@"%@", query);
        BOOL suc = [dbManager.db executeUpdate:query];
        if(suc)
            NSLog(@"delete is successful.");
        else
            NSLog(@"delete failed.");
        
        [self reloadfileslist]; 
   
        
    }
}

- (void)tableView:(UITableView *)tableView 
didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView reloadData];
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
    return [fileslist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [[fileslist objectAtIndex:indexPath.row] filename];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
