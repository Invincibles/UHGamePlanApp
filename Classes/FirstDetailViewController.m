
#import "FirstDetailViewController.h"


@implementation FirstDetailViewController
@synthesize toolbar;



#pragma mark -
#pragma mark View lifecycle

- (void)viewDidUnload {
   

    [self setToolbar:nil];
	[super viewDidUnload];
	
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark -
#pragma mark Managing the popover


- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Add the popover button to the toolbar.
    NSMutableArray *itemsArray = [toolbar.items mutableCopy];
    [itemsArray insertObject:barButtonItem atIndex:0];
    [toolbar setItems:itemsArray animated:NO];
    [itemsArray release];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Remove the popover button from the toolbar.
    NSMutableArray *itemsArray = [toolbar.items mutableCopy];
    [itemsArray removeObject:barButtonItem];
    [toolbar setItems:itemsArray animated:NO];
    [itemsArray release];
}


#pragma mark -
#pragma mark Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {

    [toolbar release];
    [super dealloc];
}	


@end
