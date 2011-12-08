//
//  ShareFilesViewController.m
//  MultipleDetailViews
//
//  Created by Invincibles on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShareFilesViewController.h"
#import "AppDelegate.h"

#import "FileViewController.h"
#import "FileIcon.h"
#import "File.h"
#import "databaseManager.h"
#import "GPFilePicker.h"
#import "MyFileViewController.h"
#import "FolderListViewController.h"

@implementation ShareFilesViewController

@synthesize navigationBar;
@synthesize manageFolderBtn;
@synthesize manageFolderOutlet;
@synthesize scrollView;
@synthesize toolbar;
@synthesize Button;
@synthesize numberOfFiles;
@synthesize foldername,arrayoffileicons,fileslist,isLandscape, folderListView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self reloadFiles];
        self.arrayoffileicons = [[NSMutableArray alloc] initWithCapacity:1];
        self.fileslist = [[NSMutableArray alloc] initWithCapacity:1];
        self.manageFolderBtn.enabled = NO;
        self.manageFolderOutlet.enabled = NO;
    }
    return self;
}

-(void) cancelEdit
{
    NSLog(@"it is coming to this function");
}

- (void)dealloc
{
    [fileslist release];
    [foldername release];
    [arrayoffileicons release];
    [toolbar release];
    [Button release];
    [navigationBar release];
    [previousBtn release];
    [nextBtn release];
    [numberOfFiles release];
    [scrollView release];
    [manageFolderBtn release];
    [manageFolderOutlet release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    // Add the popover button to the left navigation item.
    [navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:NO];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    // Remove the popover button.
    [navigationBar.topItem setLeftBarButtonItem:nil animated:NO];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{   
    NSLog(@"in view did load");
    scrollView.backgroundColor = [UIColor grayColor];
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(704, 1750);
    scrollView.clipsToBounds = YES;
    scrollView.delegate = self;
        
    UIImageView* myImageViewer;
    float y_cord=0;
    
    NSLog(@"interface orientation = %d", isLandscape);

    if(isLandscape == 0){    
        for(int i=0;i<10;i++){
            myImageViewer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"file-view-shelves_noicons.png"]];
            myImageViewer.frame = CGRectMake(0, y_cord+i*175, 704, 175);
            myImageViewer.center = CGPointMake(704/2, (y_cord+(i+1)*175)/2);
            [scrollView addSubview:myImageViewer];
            [myImageViewer release];
            y_cord+=175;
        }  
    }
    else{
        for(int i=0;i<11;i++){
            myImageViewer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"file-view-shelves_noicons.png"]];
            myImageViewer.frame = CGRectMake(0, y_cord+i*175, 775, 175);
            myImageViewer.center = CGPointMake(775/2, (y_cord+(i+1)*175)/2);
            [scrollView addSubview:myImageViewer];
            [myImageViewer release];
            y_cord+=175;
        }
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setNavigationBar:nil];

    [previousBtn release];
    previousBtn = nil;
    [nextBtn release];
    nextBtn = nil;
    [numberOfFiles release];
    numberOfFiles = nil;
    [self setManageFolderBtn:nil];
    [self setManageFolderOutlet:nil];
   [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"interface orientation = %d",interfaceOrientation);
    isLandscape = (interfaceOrientation==3 || interfaceOrientation==4) ? 0 : 1;
    
    [self viewDidLoad];
    if(![foldername isEqualToString:@""])
        [self reloadFiles];
    return YES;
}

- (IBAction)previousButton:(id)sender {
    NSLog(@"previous button is pressed.");
}

-(void) cancelListVC
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)nextButton:(id)sender {
    
    MyFileViewController* fileVC = [[MyFileViewController alloc] init];
    fileVC.delegate = self;
    fileVC.foldername = self.foldername;
    fileVC.myNav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:fileVC.myNav animated:YES];
    [fileVC release];
}

-(void) loadFilesList
{
    [fileslist removeAllObjects];
    
    databaseManager* dbmanager = [[databaseManager alloc] init];
    [dbmanager updateNames];
    dbmanager.db = [FMDatabase databaseWithPath:dbmanager.databasePath];
    if(![dbmanager.db open]){
        NSLog(@"Error: Could not connect to database.");
        [dbmanager release];
        return;
    }
    
    NSString* query = [NSString stringWithFormat:@"select * from filesystem where isfolder=0 and foldername = '%@'",foldername];
    
    FMResultSet* rs = [dbmanager.db executeQuery:query];
    
    if(rs == nil){
        NSLog(@"Error: result set is nil.");
        [dbmanager release];
        return;
    }
    
    File* myfile;
    
    while ([rs next]) {
        myfile = [[File alloc] init:[rs intForColumn:@"fid"] _filename:[rs stringForColumn:@"filename"] _isfolder:YES _foldername:[rs stringForColumn:@"foldername"] _date:[rs stringForColumn:@"creationdate"]];
        //NSLog(@"filename - %@",[myfile filename]);
        [fileslist addObject:myfile];
    }
    
    [dbmanager.db close];
    [dbmanager release];
}

- (IBAction)manageFolderAction:(id)sender {
    MyFileViewController* fileVC = [[MyFileViewController alloc] init];
    fileVC.delegate = self;
    fileVC.foldername = self.foldername;
    fileVC.myNav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:fileVC.myNav animated:YES];
    [fileVC release];

}


-(void) reloadFiles{
    
    NSLog(@"RELOAD FILES : %@",self.foldername);
    self.manageFolderOutlet.enabled = NO;
    if(!([foldername isEqualToString:@""] || ([foldername isEqualToString:@"(null)"]) || (foldername == NULL))){
        self.manageFolderOutlet.enabled = YES;
        self.navigationBar.topItem.title = foldername;
        NSLog(@"-----> Folder Name : '%@'", foldername);
    }
    
    //remove all existing files n then add new ones
    for(FileIcon* obj in arrayoffileicons) [obj removeFromSuperview];
    [arrayoffileicons removeAllObjects];
    
    //read from database
    [self loadFilesList];
    
    int fileCount = [fileslist count];
    NSLog(@"filecount - %d",fileCount);
    numberOfFiles.text = [NSString stringWithFormat:@"number of files - %d",fileCount];
    
    int w=1,h=0;
    for(int i=1;i<=fileCount;i++){
        
        FileIcon* obj = [[FileIcon alloc] initWithFrame:CGRectMake(w*125, h+25, 90, 135) _filename:[NSString stringWithFormat:[NSString stringWithString:[[fileslist objectAtIndex:i-1] filename]],i] _fileid:[[fileslist objectAtIndex:i-1] fid]];
        
        obj.mydelegate = self;
        [scrollView addSubview:obj];
        [arrayoffileicons addObject:obj];
        w++;
        if(w==5){
            w=1;
            h+=175;
        }
    }
    [self reloadInputViews];
}
@end
