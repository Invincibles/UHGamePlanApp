//
//  GPFilePicker.m
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 11/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GPFilePicker.h"
#import "MyFileViewController.h"
#import "databaseManager.h"
#import "File.h"

@implementation GPFilePicker

@synthesize myNavigator, filesList, delegate;

-(void) cancelAction:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        myNavigator = [[UINavigationController alloc] initWithRootViewController:self];
        
        myNavigator.navigationBar.tintColor = [[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
        
        self.navigationItem.leftBarButtonItem = cancelButton;
        
        [cancelButton release];
        
        filesList = [[NSMutableArray alloc] initWithCapacity:1];
        
        //get all files from main bundle's Files folder
        //[filesList addObject:@"test1.pdf"];
        //[filesList addObject:@"test2.pdf"];
        //[filesList addObject:@"test3.pdf"];
        //[filesList addObject:@"test.pdf"];
    }
    return self;
}

-(void) dealloc{
    [delegate release];
    [filesList release];
    [myNavigator release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) loadFilesList
{
    databaseManager* dbmanager = [[databaseManager alloc] init];
    [dbmanager updateNames];
    dbmanager.db = [FMDatabase databaseWithPath:dbmanager.databasePath];
    if(![dbmanager.db open]){
        NSLog(@"Error: Could not connect to database.");
        return;
    }
    
    FMResultSet* rs = [dbmanager.db executeQuery:@"select * from filelist"];
    
    if(rs == nil){
        NSLog(@"Error: result set is nil.");
        return;
    }
    
    [filesList removeAllObjects];
    
    while ([rs next]) {
        [filesList addObject:[rs stringForColumn:@"filename"]];
    }
    
    [dbmanager.db close];
    [dbmanager release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"File Picker";
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"celltexture.png"]];
    
    [self loadFilesList];
    
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
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filesList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
    cell.textLabel.text = [filesList objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:(154.0/255.0f) green:(176.0/255.0f) blue:(44.0/255.0f) alpha:1.0f];
    
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
    //NSLog(@"selected file %@",[filesList objectAtIndex:indexPath.row]);
    
    //check if the file is already in that folder
    for(File* obj in delegate.fileslist){
        if([[obj filename] isEqualToString:[filesList objectAtIndex:indexPath.row]]){
            UIAlertView* myView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"File already exists with the given name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [myView show];
            [myView release];
            [self dismissModalViewControllerAnimated:YES];
            return;
        }
    }
    
    //add it to database
    databaseManager* dbmanager = [[databaseManager alloc] init];
    [dbmanager updateNames];
    dbmanager.db = [FMDatabase databaseWithPath:dbmanager.databasePath];
    if(![dbmanager.db open]){
        NSLog(@"Error: Could not connect to database.");
        [self dismissModalViewControllerAnimated:YES];
        return;
    }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd" ];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];

    NSString* query = [NSString stringWithFormat:@"insert into filesystem (filename,isfolder,foldername,creationdate) values ('%@',0,'%@','%@')",[filesList objectAtIndex:indexPath.row],delegate.foldername,dateString];
    
    BOOL suc = [dbmanager.db executeUpdate:query];
    if(!suc){
        NSLog(@"Error: Inserting failed please try again.");
    }
    
    [dbmanager.db close];
    
    //NSLog(@"added %@ to folder %@",[filesList objectAtIndex:indexPath.row],delegate.foldername);
    [delegate reloadfileslist];
    [self dismissModalViewControllerAnimated:YES];
}

@end
