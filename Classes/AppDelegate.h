

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
	UISplitViewController *splitViewController;
    NSString* description;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property(nonatomic,retain) NSString* description;

-(void) copyDatabase;

@end

