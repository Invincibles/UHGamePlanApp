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
        //self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"celltexture.png"]];
        folderList = [[NSMutableArray alloc] initWithCapacity:1];
        isSharedFilePortrait = 0;
    /*    
        //load all the folders here
        File* file1 = [[File alloc] init:1 _filename:@"" _isfolder:1 _foldername:@"Folder 1" _date:@"2011-11-06"];
        File* file2 = [[File alloc] init:1 _filename:@"" _isfolder:1 _foldername:@"Folder 2" _date:@"2011-11-06"];
        [folderList addObject:file1];
        [folderList addObject:file2];
     */
        [self loadFolderList];
    }
    return self;
}

-(void) loadFolderList
{
    [folderList removeAllObjects];
    
    databaseManager* dbmanager = [[databaseManager alloc] init];
    [dbmanager updateNames];
    dbmanager.db = [FMDatabase databaseWithPath:dbmanager.databasePath];
    NSLog(@"path - %@",dbmanager.databasePath);
    if(![dbmanager.db open]){
        NSLog(@"Error: Could not connect to database.");
        [dbmanager release];
        return;
    }
    
    FMResultSet* rs = [dbmanager.db executeQuery:@"select * from filesystem where isfolder=1"];
    
    if(rs == nil){
        NSLog(@"Error: result set is nil.");
        [dbmanager release];
        return;
    }
    
    File* myfile;
    
    while ([rs next]) {
        myfile = [[File alloc] init:[rs intForColumn:@"fid"] _filename:[rs stringForColumn:@"filename"] _isfolder:YES _foldername:[rs stringForColumn:@"foldername"] _date:[rs stringForColumn:@"creationdate"]];
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
    
    //Initialize the toolbar
        
    //Reload the table view
    
    [self.tableView reloadData];
    
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != [alertView cancelButtonIndex])
    {
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
        
        while([rs next])
        {
         int fileID=[rs intForColumn:@"fid"]; 
            query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"delete from contactTable where fid='%d'",fileID]];
            NSLog(@"%@", query);
            [dbManager.db executeUpdate:query];
            [query release];
            
            query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"delete from eventTable where fid='%d'",fileID]];
            NSLog(@"%@", query);
            [dbManager.db executeUpdate:query];
            [query release];
            
            query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"delete from geotagTable where fid='%d'",fileID]];
            NSLog(@"%@", query);
            [dbManager.db executeUpdate:query];
            [query release];
            
            query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"delete from filehistory where fid='%d'",fileID]];
            NSLog(@"%@", query);
            [dbManager.db executeUpdate:query];
            [query release];
            
            query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"delete from anotationTable where fid='%d'",fileID]];
            NSLog(@"%@", query);
            [dbManager.db executeUpdate:query];
            [query release];
        }
        
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
    }
}

- (void)tableView:(UITableView *)tableView 
didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView reloadData];
}

- (IBAction)createNewFolder:(id)sender
{
    //read filename from user
    CustomUIAlert* myAlert = [[CustomUIAlert alloc] initWithTitle:@"Create Folder" message:@"Please Enter a Folder Name" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Ok"];
    [myAlert show];
    [myAlert release];
}

- (IBAction)fileDownlaod:(id)sender {
    
    GPNewFilePicker *picknewfile = [[GPNewFilePicker alloc] initWithNibName:@"GPNewFilePicker" bundle:[NSBundle mainBundle]];
    picknewfile.navigator.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:picknewfile.navigator animated:YES];
    [picknewfile release];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(!isFileSelected)
        [root loadHomePage];
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
    /*
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text=@"";
            return cell;
        case 1:
            cell.titleLabel.text = @"TES Presentation";
            break;
        case 2:
            cell.titleLabel.text = @"FDIS Team";
            break;
        case 3:
            cell.titleLabel.text = @"Lastest";
            break;
        default:
            break;
    }
    */
    
    cell.iconImage.image = [UIImage imageNamed:@"folder_icon_small.png"];
    cell.titleLabel.text = [NSString stringWithString:[[folderList objectAtIndex:i] foldername]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(fileView != nil)
    {
        NSLog(@"object is assigned.");
        //[fileView.numberOfFiles setText:[NSString stringWithFormat:@"number of files : %d",indexPath.row]];
        /*
        switch (indexPath.row) {
            case 0:
                fileView.fileCount=0;
                break;
            case 1:
                fileView.fileCount = 10;
                break;
            case 2:
                fileView.fileCount = 20;
                break;
            case 3:
                fileView.fileCount = 30;
            default:
                break;
        }
        */
        
        NSLog(@"in did select row at index : %d",indexPath.row);
        
        downloadBtn.enabled = YES;
        
        NSLog(@"Folder Name : %@",[NSString stringWithString:[[folderList objectAtIndex:indexPath.row] foldername]]);
        
        fileView.foldername = [NSString stringWithString:[[folderList objectAtIndex:indexPath.row] foldername]];
        [fileView reloadFiles];
    }
    else
    {
        NSLog(@"object is not known.");
    }
}

@end
