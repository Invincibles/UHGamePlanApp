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

//this function calls addNotes ontoller to fix the bug, once akn         d
-(void)addNote
{
    addTextFile *addText = [[addTextFile alloc] initWithNibName:@"addTextFile" bundle:[NSBundle mainBundle]];
    addText.delegate = self;
    
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:addText];
    nav.navigationBar.tintColor=[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:nav animated:YES];
    [addText release];
}

-(void)cancelNote  /// this function is used to cancel the note
{
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void) loadAnnoataions         // this function is usd to store the anotations present in the database to the array
{
    [arrayOfNotes removeAllObjects]; //we start with an empty array
    
    NSString* cellDescription;
    NSString* date;
    int cellanotation;
    databaseManager *dbManager=[[databaseManager alloc] init];
    [dbManager updateNames];
    dbManager.db = [FMDatabase databaseWithPath:dbManager.databasePath];
   if(![dbManager.db open]){
        NSLog(@"Could not open db.");
        [dbManager release];
        return;
    }
    else{
        NSLog(@"database is open.");
    }
    int fileid=self.fileVC.fileID;
    //belo querry is used to pull all the anotations related to that file int an array

    NSString* query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"select annotationid,description,annotationdate from anotationTable where fid='%d'",fileid]];
  
    FMResultSet *rs=[dbManager.db executeQuery:query];
    
    NSString* query1 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"select count(*) as Count from anotationTable where fid='%d'",fileid]];
  
    FMResultSet *rsCount=[dbManager.db executeQuery:query1];
    
    while([rsCount next])
    {
        rowcount=[rsCount intForColumn:@"Count"];
          
    }
    
    int no=0;
    while([rs next]) {    //anotation,description and anotation date are inserted into the array from database
        
        cellanotation=[rs intForColumn:@"annotationid"];
        NSString *string = [NSString stringWithFormat:@"%d", cellanotation];
        [arrayOfNotes addObject:string];
        cellDescription=[rs stringForColumn:@"description"];
        [arrayOfNotes addObject:cellDescription];
        date=[rs stringForColumn:@"annotationdate"];
        [arrayOfNotes addObject:date];
        no++;
    }
    [dbManager.db close];
    [dbManager release];
    [query1 release];
    [query release];
    
    [self.tableView reloadData];

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


- (void)tableView:(UITableView *)tableView // code for deleting the row
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rownumber = [indexPath row];
    NSUInteger count = [arrayOfNotes count];
    
    if (rownumber < count) {
        
        databaseManager *dbManager=[[databaseManager alloc] init];
        [dbManager updateNames];
        dbManager.db = [FMDatabase databaseWithPath:dbManager.databasePath];
        if(![dbManager.db open]){
            NSLog(@"Could not open db.");
            }
        else{
            NSLog(@"database is open.");
        }
        // this querry deletes the notes selected in the table view from the database
        NSString* query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"delete from anotationTable where annotationid='%d'",[[arrayOfNotes objectAtIndex:((rownumber*3))] intValue]]];
        BOOL suc = [dbManager.db executeUpdate:query];
        if(suc)
            NSLog(@"delete is successful.");
        else
            NSLog(@"delete failed.");
        [dbManager.db close];
        [dbManager release];
        [query release];
        
        //we reload the notes again to get the updated list
        [self loadAnnoataions];
        
    }
}

- (void)tableView:(UITableView *)tableView 
didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView reloadData];                                // this is used to reload the tableview
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  //Each custom cell has a primary label which has note and secondary label which has anotated date
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
    cell.primaryLabel.text=[arrayOfNotes objectAtIndex:(indexPath.row * 3 + 2)] ;
    }
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath // when we select a row in the tableview then we are directed to a description controller which displays the note
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
