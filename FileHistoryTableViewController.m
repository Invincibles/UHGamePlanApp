//
//  FileHistoryTableViewController.m
//  GamePlanApp
//
//  Created by Kowshik Gurram on 12/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileHistoryTableViewController.h"
#import "CustomCell.h"
#import "databaseManager.h"

@implementation FileHistoryTableViewController

@synthesize fileVC,arrayOfHistory;

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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

#pragma mark - View lifecycle
-(void)cancel
{
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void) loadHistory
{
    [arrayOfHistory removeAllObjects];
    NSString* description;
    NSString* date;
     NSString* geodescription;
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
    int fileid=self.fileVC.fileID;
    
    NSString* query = [NSString stringWithFormat:@"select openeddate,description,geodescription from filehistory where fid='%d'",fileid];
    NSLog(@"%@", query);
    //BOOL suc = [dbManager.db executeUpdate:query];
    
    FMResultSet *rs=[dbManager.db executeQuery:query];
    
    NSString* query1 = [NSString stringWithFormat:@"select count(*) as Count from filehistory where fid='%d'",fileid];
    NSLog(@"%@", query1);
    FMResultSet *rsCount=[dbManager.db executeQuery:query1];
    
    while([rsCount next])
    {
        rowcount=[rsCount intForColumn:@"Count"];
        NSLog(@"%d------rowcount",rowcount);  
    }
    
    int no=0;
    while([rs next]) {
    
        date=[rs stringForColumn:@"openeddate"];
        NSLog(@"%@ ----- date",date);
        [arrayOfHistory addObject:date];
        
        description=[rs stringForColumn:@"description"];
        NSLog(@"%@ ---- Data base",description);
        if(description==NULL)
            description=@"NOT ANNOTATED";
        [arrayOfHistory addObject:description];
        NSLog(@"%@ ---- Data base",description);
        
        geodescription=[rs stringForColumn:@"geodescription"];
        if(geodescription==NULL)
            geodescription=@"NOT TAGGED";
        [arrayOfHistory addObject:geodescription];
        no++;
    }
    [dbManager.db close];
    [dbManager release];
    
    [self.tableView reloadData];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"celltexture.png"]];
    
    arrayOfHistory = [[NSMutableArray alloc] init];
    [self loadHistory];
  
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    
    [cancelButton release];
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
    static NSString *CellIdentifier = @"AnnotationCell";
    
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    
  
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    if(arrayOfHistory.count!=0)
    {
        cell.secondaryLabel.text=[arrayOfHistory objectAtIndex:(indexPath.row * 3)];
        NSLog(@"%@-----array pos",[arrayOfHistory objectAtIndex:(indexPath.row * 3 + 1)]);
        cell.primaryLabel.text=[arrayOfHistory objectAtIndex:(indexPath.row * 3 + 2)] ;
    }
    
   
    
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
