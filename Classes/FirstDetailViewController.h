
#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface FirstDetailViewController : UIViewController <SubstitutableDetailViewController> {
 
    UIToolbar *toolbar;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@end
