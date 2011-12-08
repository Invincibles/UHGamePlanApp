//
//  DescriptionVC.m
//  GamePlanApp
//
//  Created by Kowshik Gurram on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DescriptionVC.h"
#import "databaseManager.h"
#import "NotesTableViewController.h"
@implementation DescriptionVC
@synthesize textView,myNav,descriptionText,description,id,delegate;



-(void) cancelAction
{
   
    [self.delegate loadAnnoataions];
    [self.delegate.tableView reloadData];
    [self dismissModalViewControllerAnimated:YES];
}
/* update */

-(void) updateAction:(id)sender
{
    
    description=textView.text;
   
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
    
    NSLog(@"%@ --->",description);
    NSLog(@"%@ --->",descriptionText);
    NSLog(@"%d --->",self.id);
    int k=self.id;
    
   NSString* query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"update anotationTable set description='%@' where annotationid='%d'",description,k]];
   NSLog(@"%@", query);
    BOOL suc = [dbManager.db executeUpdate:query];
    if(suc)
    NSLog(@"update is successful.");
   else
    NSLog(@"update failed.");
    
    [query release];
    [dbManager.db close];
    [dbManager release];
    
    [self cancelAction];
      
}





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        myNav = [[UINavigationController alloc] initWithRootViewController:self];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
        self.navigationItem.leftBarButtonItem = cancelButton;
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"done" style:UIBarButtonItemStylePlain target:self action:@selector(updateAction:)];
        self.navigationItem.rightBarButtonItem = doneButton;
        
        descriptionText = [[NSString alloc] init];
    }
    return self;
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
    textView.text = descriptionText;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)dealloc {
    [textView release];
    [super dealloc];
}
@end
