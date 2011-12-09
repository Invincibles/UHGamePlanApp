//
//  FolderListViewController.m
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 10/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FolderListViewController.h"
#import "RootViewController.h"
#import "RootViewTableCell.h"
#import "ShareFilesViewController.h"
#import "GPNewFilePicker.h"

#import "File.h"
#import "CustomUIAlert.h"
#import "databaseManager.h"

@implementation FolderListViewController

@synthesize fileView,folderList,root, isFileSelected, isSharedFilePortrait;
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        folderList = [[NSMutableArray alloc] initWithCapacity:1];
        isSharedFilePortrait = 0;
        [self loadFolderList];
    }
    return self;
}

/*
 This function loads all the foldernames for database to folderList array.
 */
-(void) loadFolderList
{
    [folderList removeAllObjects]; //in order to avoid redundancy in adding foldernames, we empty this folder before we read all the files
    
    //we initialize the database manager
    databaseManager* dbmanager = [[databaseManager alloc] init];
    [dbmanager updateNames];
    dbmanager.db = [FMDatabase databaseWithPath:dbmanager.databasePath];
    NSLog(@"path - %@",dbmanager.databasePath);
    if(![dbmanager.db open]){
        NSLog(@"Error: Could not connect to database.");
        [dbmanager release];
        return;
    }
    
    //we get all the folder names form filesystem
    FMResultSet* rs = [dbmanager.db executeQuery:@"select * from filesystem where isfolder=1"];
    
    if(rs == nil){
        NSLog(@"Error: result set is nil.");
        [dbmanager release];
        return;
    }
    
    //we define a file object to read the folder properties from the database
    File* myfile;
    
    while ([rs next]) {
        //we read each file
        myfile = [[File alloc] init:[rs intForColumn:@"fid"] _filename:[rs stringForColumn:@"filename"] _isfolder:YES _foldername:[rs stringForColumn:@"foldername"] _date:[rs stringForColumn:@"creationdate"]];
        //we are adding it to the array
        [folderList addObject:myfile];
    }
    [dbmanager.db close];
    [dbmanager release];
}

-(void) dealloc
{
    [folderList release];
    [fileView release];
    [downloadBtn release];
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
    
    if(isSharedFilePortrait)
        isFileSelected = TRUE;
    else
        isFileSelected = FALSE;
    
    downloadBtn.enabled = NO;
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"celltexture.png"]];
}

- (void)viewDidUnload
{
    [downloadBtn release];
    downloadBtn = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
}

//this function is called when the alert view is dismissed
-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //we will press ok button
    if(buttonIndex != [alertView cancelButtonIndex])
    {
        //we get the new folder name from uialertview
        NSString* newfoldername = [(CustomUIAlert*)alertView enteredText];
        
        //check if the folder name is already present, if its present dont add, else add to table view
        for(File* obj in folderList){
            if([[obj foldername] isEqualToString:newfoldername]){
                UIAlertView* msg = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Folder with the given name already exists." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [msg show];
                [msg release];
                return;
            }
        }
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd" ];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        [dateFormatter release];
        //insert into database
        NSString* query = [NSString stringWithFormat:@"insert into filesystem (filename,isfolder,foldername,creationdate) values ('',1,'%@','%@')",newfoldername,dateString];
        
        databaseManager* dbmanager = [[databaseManager alloc] init];
        [dbmanager updateNames];
        dbmanager.db = [FMDatabase databaseWithPath:dbmanager.databasePath];
        //NSLog(@"path - %@",dbmanager.databasePath);
        if(![dbmanager.db open]){
            NSLog(@"Error: Could not connect to database.");
            [dbmanager release];
            return;
        }
        
        BOOL suc = [dbmanager.db executeUpdate:query];
        
        if(suc)
        {
            NSLog(@"Folder created successfully.");
        }
        else
        {
            NSLog(@"Error in creating file, please try again.");
        }
        [dbmanager.db close];
        [dbmanager release];
        
        [self loadFolderList];
        
        [self.tableView reloadData];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
		   editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSUInteger rownumber = [indexPath row];
    NSUInteger count = [folderList count];
	
    if (rownumber < count) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}


//this function is called when we delete a folder. When we delete a folder all the associations associated with the files in the foder should also be deleted from the tables
- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rownumber = [indexPath row];
    NSUInteger count = [folderList count];
    
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
        NSString* query1 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"select fid from filesystem where foldername='%@' and isfolder=0",[[folderList objectAtIndex:rownumber] foldername ]]];
        NSLog(@"%@", query1);
        FMResultSet *rs=[dbManager.db executeQuery:query1];
        
        NSString *query;
        
        //for each file
        while([rs next])
        {
         int fileID=[rs intForColumn:@"fid"];
            //we delete the contacts associated with it
            query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"delete from contactTable where fid='%d'",fileID]];
            NSLog(@"%@", query);
            [dbManager.db executeUpdate:query];
            [query release];
            
            //we delete the events associated with it
            query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"delete from eventTable where fid='%d'",fileID]];
            NSLog(@"%@", query);
            [dbManager.db executeUpdate:query];
            [query release];
            
            //we delete the geotags associated with it
            query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"delete from geotagTable where fid='%d'",fileID]];
            NSLog(@"%@", query);
            [dbManager.db executeUpdate:query];
            [query release];
            
            //we delete the history associated with it
            query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"delete from filehistory where fid='%d'",fileID]];
            NSLog(@"%@", query);
            [dbManager.db executeUpdate:query];
            [query release];
            
            //we delete the anotations associated with it
            query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"delete from anotationTable where fid='%d'",fileID]];
            NSLog(@"%@", query);
            [dbManager.db executeUpdate:query];
            [query release];
        }
        
        //delete the folder
        NSString* query2 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"delete from filesystem where foldername='%@'",[[folderList objectAtIndex:rownumber] foldername ]]];
        NSLog(@"%@", query2);
        
        if([dbManager.db executeUpdate:query2])
            NSLog(@"delete is successful.");
        else
            NSLog(@"delete failed.");
        
        [query2 release];
        [query1 release];
        [self loadFolderList];
        [dbManager release];
        
        //reloading the fileview after deleting the folder, it should be set to null because we don't have any file selected now
        fileView.foldername = @"";
        [fileView reloadFiles];
        [fileView reloadInputViews];
    }
}

- (void)tableView:(UITableView *)tableView 
didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView reloadData];
}

//this function is called when you want to download a file to your app
- (IBAction)downloadAction:(id)sender {
    
    GPNewFilePicker *picknewfile = [[GPNewFilePicker alloc] initWithNibName:@"GPNewFilePicker" bundle:[NSBundle mainBundle]];
    picknewfile.navigator.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:picknewfile.navigator animated:YES];
    [picknewfile release];
}

//this is called when you want to create a new folder
- (IBAction)newFolderAction:(id)sender {
    
    //read filename from user
    CustomUIAlert* myAlert = [[CustomUIAlert alloc] initWithTitle:@"Create Folder" message:@"Please Enter a Folder Name" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Ok"];
    [myAlert show];
    [myAlert release];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(!isFileSelected){
        NSLog(@"orientation = %d",fileView.isLandscape);
        if(fileView.isLandscape == 0){
            //[fileView.manageFolderBtn setEnabled:NO];
            [root loadHomePage];
            fileView.isFolderViewPresent = FALSE;
        }
    }
        //[root loadHomePage];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [folderList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    RootViewTableCell *cell = (RootViewTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[[RootViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    int i = indexPath.row;
    
    cell.iconImage.image = [UIImage imageNamed:@"folder_icon_small.png"];
    cell.titleLabel.text = [NSString stringWithString:[[folderList objectAtIndex:i] foldername]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(fileView != nil)
    {
        downloadBtn.enabled = YES;
        fileView.foldername = [NSString stringWithString:[[folderList objectAtIndex:indexPath.row] foldername]];
        [fileView reloadFiles];
    }
    else
    {
        NSLog(@"object is not known.");
    }
}

@end
