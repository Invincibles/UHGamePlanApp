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
        
        myNavigator.navigationBar.tintColor = [[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f] autorelease];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
        
        self.navigationItem.leftBarButtonItem = cancelButton;
        
        [cancelButton release];
        
        filesList = [[NSMutableArray alloc] initWithCapacity:1];
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

//this function is used to read the files list from the database
-(void) loadFilesList
{
    databaseManager* dbmanager = [[databaseManager alloc] init];
    [dbmanager updateNames];
    dbmanager.db = [FMDatabase databaseWithPath:dbmanager.databasePath];
    if(![dbmanager.db open]){
        NSLog(@"Error: Could not connect to database.");
        [dbmanager release];
        return;
    }
    
    FMResultSet* rs = [dbmanager.db executeQuery:@"select * from filelist"];
    
    if(rs == nil){
        NSLog(@"Error: result set is nil.");
        [dbmanager release];
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

#pragma mark - Table view delegate

//when we select a file it should be added to that folder

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
        [dbmanager release];
        [self dismissModalViewControllerAnimated:YES];
        return;
    }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd" ];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];

    //inserting into the database
    NSString* query = [NSString stringWithFormat:@"insert into filesystem (filename,isfolder,foldername,creationdate) values ('%@',0,'%@','%@')",[filesList objectAtIndex:indexPath.row],delegate.foldername,dateString];
    
    [dateFormatter release];
    
    BOOL suc = [dbmanager.db executeUpdate:query];
    if(!suc){
        NSLog(@"Error: Inserting failed please try again.");
    }
    
    [dbmanager.db close];
    [dbmanager release];
    
    [delegate reloadfileslist];
    [self dismissModalViewControllerAnimated:YES];
}

@end
