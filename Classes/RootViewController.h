

#import <UIKit/UIKit.h>

@protocol SubstitutableDetailViewController
- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
@end


@interface RootViewController : UITableViewController <UISplitViewControllerDelegate> {
	
	UISplitViewController *splitViewController;
    
    UIPopoverController *popoverController;    
    UIBarButtonItem *rootPopoverButtonItem;
}

@property (nonatomic, assign) IBOutlet UISplitViewController *splitViewController;

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;

-(void) loadHomePage;

@end
