//
//  AnnotatedFilesTableViewController.m
//  GamePlanApp
//
//  Created by Kowshik Gurram on 12/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AnnotatedFilesTableViewController.h"
#import "databaseManager.h"
#import "FileViewController.h"

@implementation AnnotatedFilesTableViewController
@synthesize fullMapVC,arrayOfFiles,geoDescription,detailMVC,latitude,longitude;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)loadFiles
{
    NSString* fname;
    int fileid;
    [arrayOfFiles removeAllObjects];
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
    
    NSLog(@"in ..%@",latitude);
    NSString* query = [NSString stringWithFormat:@"select fid,filename from filesystem where fid in(select fid from geotagTable where latitude='%@' and longitude='%@')",latitude,longitude];
    NSLog(@"full   %@", query);
    //BOOL suc = [dbManager.db executeUpdate:query];
    
    FMResultSet *rs=[dbManager.db executeQuery:query];
    
    NSString* query1 = [NSString stringWithFormat:@"select count(distinct fid) as Count from geotagTable where latitude='%@'and longitude='%@'",latitude,longitude];
    NSLog(@"%@", query1);
    FMResultSet *rsCount=[dbManager.db executeQuery:query1];
    
    while([rsCount next])
    {
        rowcount=[rsCount intForColumn:@"Count"];
        NSLog(@"%d------rowcount",rowcount);  
    }
    
    int no=0;
    while([rs next]) {
        
        fileid=[rs intForColumn:@"fid"];
        NSLog(@"%d----->1",fileid);
        NSString *string = [NSString stringWithFormat:@"%d", fileid];
        [arrayOfFiles addObject:string];
        fname=[rs stringForColumn:@"filename"];
        [arrayOfFiles addObject:fname];
        NSLog(@"%@ ---- Data base",fname);
      no++;
    }
    [dbManager.db close];
    [dbManager release];
    
    [self.tableView reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"celltexture.png"]];
    
    arrayOfFiles = [[NSMutableArray alloc] init];
    [self loadFiles];
 
    NSLog(@"description %@",  self.fullMapVC.anotationDescription);
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
     return rowcount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text =[arrayOfFiles objectAtIndex:(2*(indexPath.row)+1)];
    
    cell.textLabel.textColor = [UIColor colorWithRed:(154.0/255.0f) green:(176.0/255.0f) blue:(44.0/255.0f) alpha:1.0f];
    
    // Configure the cell...
    
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
    int fileid=[[arrayOfFiles objectAtIndex:(indexPath.row)] intValue];
    
    databaseManager *dbManager=[[databaseManager alloc] init];
    [dbManager updateNames];
    dbManager.db = [FMDatabase databaseWithPath:dbManager.databasePath];
    NSLog(@"path ---- %@",dbManager.databasePath);
    if(![dbManager.db open]){
        NSLog(@"Could not open db.");
        [dbManager release];
        return;
    }
    else{
        NSLog(@"database is open.");
    }
    NSDate* openedDate = [NSDate date];
    
    //NSLog(@"%@",now);
    
    NSString* query = [NSString stringWithFormat:@"insert into filehistory (fid,openeddate) values (%d,'%@')",fileid,openedDate];
    NSLog(@"%@", query);
    BOOL suc = [dbManager.db executeUpdate:query];
    if(suc)
        NSLog(@"insert is successful.");
    else
        NSLog(@"insert failed.");
    
    [dbManager.db close];
    [dbManager release];
    
    FileViewController *fvc = [[FileViewController alloc] initWithNibName:@"FileViewController" bundle:[NSBundle mainBundle]];
    fvc.fileID =fileid;
    fvc.openedDate=openedDate;
    
    NSArray *split = [[arrayOfFiles objectAtIndex:(2*(indexPath.row)+1)] componentsSeparatedByString:@"."];
    fvc.filename=[split objectAtIndex:0];
    
  
    [self presentModalViewController:fvc animated:YES];
    [fvc release];
}

@end
