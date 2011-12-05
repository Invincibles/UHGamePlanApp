

#import "RootViewController.h"
#import "FirstDetailViewController.h"
#import "SecondDetailViewController.h"
#import "EventManagerViewController.h"
#import "ShareFilesViewController.h"
#import "ManagedContactViewController.h"
#import "HelpViewController.h"
#import "NewHelpViewController.h"

#import "FolderListViewController.h"

#import "RootViewTableCell.h"

@implementation RootViewController

@synthesize popoverController, splitViewController, rootPopoverButtonItem;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"celltexture.png"]];
    
    // Set the content size for the popover: there are just two rows in the table view, so set to rowHeight*2.
    self.contentSizeForViewInPopover = CGSizeMake(310.0, self.tableView.rowHeight*2.0);
}

-(void) viewDidUnload {
	[super viewDidUnload];
	
	self.splitViewController = nil;
	self.rootPopoverButtonItem = nil;
}

#pragma mark -
#pragma mark Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc {
    
    // Keep references to the popover controller and the popover button, and tell the detail view controller to show the button.
    barButtonItem.title = @"Game Plan";
    self.popoverController = pc;
    [pc setPopoverContentSize:CGSizeMake(320, 300)];
    self.rootPopoverButtonItem = barButtonItem;
    UIViewController <SubstitutableDetailViewController> *detailViewController = [splitViewController.viewControllers objectAtIndex:1];
    [detailViewController showRootPopoverButtonItem:rootPopoverButtonItem];
}


- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
 
    // Nil out references to the popover controller and the popover button, and tell the detail view controller to hide the button.
    UIViewController <SubstitutableDetailViewController> *detailViewController = [splitViewController.viewControllers objectAtIndex:1];
    [detailViewController invalidateRootPopoverButtonItem:rootPopoverButtonItem];
    self.popoverController = nil;
    self.rootPopoverButtonItem = nil;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    
    // Two sections, one for each detail view controller.
    return 6;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RootViewControllerCellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    //UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    RootViewTableCell *cell = (RootViewTableCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[[RootViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set appropriate labels for the cells.

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch(indexPath.row){
        case 0:
            cell.titleLabel.text = @"";
            break;
        case 1:
            cell.titleLabel.text = @"Contacts";
            cell.iconImage.image = [UIImage imageNamed:@"contact.png"];
            break;
        case 2:
            cell.titleLabel.text = @"Calendar";
            cell.iconImage.image = [UIImage imageNamed:@"calendar.png"];
            break;
        case 3:
            cell.titleLabel.text = @"Files";
            cell.iconImage.image = [UIImage imageNamed:@"sharefile.png"];
            break;
        case 4:
            cell.titleLabel.text = @"My Map";
            cell.iconImage.image = [UIImage imageNamed:@"geotag.png"];
            break;
        case 5:
            cell.titleLabel.text = @"Help";
            cell.iconImage.image = [UIImage imageNamed:@"help.png"];
            break;
    }
    return cell;
}

#pragma mark -
#pragma mark Table view selection

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     Create and configure a new detail view controller appropriate for the selection.
     */
    NSUInteger row = indexPath.row;
    if(row != 0 )
    {
        
    UIViewController <SubstitutableDetailViewController> *detailViewController = nil;
    
   
    if (row == 1) {
        ManagedContactViewController *newDetailViewController = [[ManagedContactViewController alloc] initWithNibName:@"ManagedContactViewController" bundle:nil];
        detailViewController = newDetailViewController;
    }

    if (row == 2) {
        EventManagerViewController *newDetailViewController = [[EventManagerViewController alloc] initWithNibName:@"EventManagerViewController" bundle:nil];
        detailViewController = newDetailViewController;
    }
    if(row == 3){
        
        FolderListViewController *folderList = [[FolderListViewController alloc] init];
        [self.navigationController pushViewController:folderList animated:YES];
        
        ShareFilesViewController *newDetailViewController = [[ShareFilesViewController alloc] initWithNibName:@"ShareFilesViewController" bundle:nil];
        detailViewController = newDetailViewController;
        folderList.fileView = newDetailViewController;
        [folderList release];
    }
    if(row == 4){
       SecondDetailViewController *newDetailViewController = [[SecondDetailViewController alloc] initWithNibName:@"SecondDetailView" bundle:nil];
      
        detailViewController = newDetailViewController;
    }
    if(row == 5){
        
        NewHelpViewController *newHelpVC = [[NewHelpViewController alloc] initWithNibName:@"NewHelpViewController" bundle:nil];
        detailViewController = newHelpVC;
    /*
        HelpViewController *newDetailViewController = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
        detailViewController = newDetailViewController;
     */
        
    }
    // Update the split view controller's view controllers array.
    NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.navigationController, detailViewController, nil];
    splitViewController.viewControllers = viewControllers;
    [viewControllers release];
    
    // Dismiss the popover if it's present.
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }

    // Configure the new view controller's popover button (after the view has been displayed and its toolbar/navigation bar has been created).
    if (rootPopoverButtonItem != nil) {
        [detailViewController showRootPopoverButtonItem:self.rootPopoverButtonItem];
    }
        
    [detailViewController release];
    }
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [popoverController release];
    [rootPopoverButtonItem release];
    [super dealloc];
}

@end
