//
//  NotesTableViewController.m
//  GamePlanApp
//
//  Created by Kowshik Gurram on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "FileViewController.h"
#import "NotesTableViewController.h"
#import "addTextFile.h"
#import "databaseManager.h"
#import "CustomCell.h"
//#include "DescriptionViewController.h"
#include "DescriptionVC.h"
#import "AppDelegate.h"

@implementation NotesTableViewController
@synthesize arrayOfNotes,appDelegate,fileVC;


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

-(void)addNote
{
    addTextFile *addText = [[addTextFile alloc] initWithNibName:@"addTextFile" bundle:[NSBundle mainBundle]];
    addText.delegate = self;
    
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:addText];
    nav.navigationBar.tintColor=[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:nav animated:YES];
    [addText release];
    
    //[self loadAnnoataions];
}

-(void)cancelNote
{
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void) loadAnnoataions
{
    [arrayOfNotes removeAllObjects];
    
    NSString* cellDescription;
    NSString* date;
    int cellanotation;
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
    int fileid=self.fileVC.fileID;

    NSString* query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"select annotationid,description,annotationdate from anotationTable where fid='%d'",fileid]];
    NSLog(@"%@", query);
    //BOOL suc = [dbManager.db executeUpdate:query];
    
    FMResultSet *rs=[dbManager.db executeQuery:query];
    
    NSString* query1 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"select count(*) as Count from anotationTable where fid='%d'",fileid]];
    NSLog(@"%@", query1);
    FMResultSet *rsCount=[dbManager.db executeQuery:query1];
    
    while([rsCount next])
    {
        rowcount=[rsCount intForColumn:@"Count"];
        NSLog(@"%d------rowcount",rowcount);  
    }
    
    int no=0;
    while([rs next]) {
        
        cellanotation=[rs intForColumn:@"annotationid"];
        NSLog(@"%d----->1",cellanotation);
        NSString *string = [NSString stringWithFormat:@"%d", cellanotation];
        [arrayOfNotes addObject:string];
        
        cellDescription=[rs stringForColumn:@"description"];
        [arrayOfNotes addObject:cellDescription];
        NSLog(@"%@ ---- Data base",cellDescription);
        date=[rs stringForColumn:@"annotationdate"];
        NSLog(@"%@ ----- date",date);
        [arrayOfNotes addObject:date];
        
        
        no++;
    }
    [dbManager.db close];
    
    [self.tableView reloadData];
    [query1 release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"celltexture.png"]];
    
    arrayOfNotes = [[NSMutableArray alloc] init];
    [self loadAnnoataions];
       UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                   UIBarButtonSystemItemAdd target:self action:@selector(addNote)];
    self.title=@"Notes";
    self.navigationItem.rightBarButtonItem = doneButton;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNote)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    [doneButton release];
    [cancelButton release];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
		   editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSUInteger rownumber = [indexPath row];
    NSUInteger count = [arrayOfNotes count];
	
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
    NSUInteger count = [arrayOfNotes count];
    
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
        NSString* query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"delete from anotationTable where annotationid='%d'",[[arrayOfNotes objectAtIndex:((rownumber*3))] intValue]]];
        NSLog(@"%@", query);
        BOOL suc = [dbManager.db executeUpdate:query];
        if(suc)
            NSLog(@"delete is successful.");
        else
            NSLog(@"delete failed.");

        
        [self loadAnnoataions];
        
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
    [self loadAnnoataions];
}

- (void)viewDidAppear:(BOOL)animated
{
    
//    NotesTableViewController *notesTVC=[[NotesTableViewController alloc] init];
    
     
   //[self performSelector:@selector(addNote) withObject:nil afterDelay:0.1];
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
    return rowcount;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AnnotationCell";
    
   // UITableViewCellAccessoryType editableCellAccessoryType =UITableViewCellAccessoryDisclosureIndicator;
    
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        if(arrayOfNotes.count!=0)
        {
    cell.secondaryLabel.text=[arrayOfNotes objectAtIndex:(indexPath.row * 3 + 1)];
            NSLog(@"%@-----array pos",[arrayOfNotes objectAtIndex:(indexPath.row * 3 + 1)]);
            cell.primaryLabel.text=[arrayOfNotes objectAtIndex:(indexPath.row * 3 + 2)] ;
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
    DescriptionVC* descriptionVC = [[DescriptionVC alloc] initWithNibName:@"DescriptionVC" bundle:[NSBundle mainBundle]];
    descriptionVC.delegate=self;
    descriptionVC.myNav.navigationBar.tintColor = [[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    descriptionVC.myNav.modalPresentationStyle = UIModalPresentationFormSheet;
    descriptionVC.descriptionText = [arrayOfNotes objectAtIndex:((indexPath.row)*3+1)];
    descriptionVC.id = [[arrayOfNotes objectAtIndex:((indexPath.row)*3)] intValue];
    NSLog(@"%d-->",descriptionVC.id);
    
    //[self.navigationController pushViewController:descriptionVC animated:YES];
   [self presentModalViewController:descriptionVC.myNav animated:YES];
    [descriptionVC release];
}

@end
