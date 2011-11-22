
#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window, splitViewController,description;

NSURL *DocumentsDirectoryURL() {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

NSURL *URLForFileInDocumentDirectory(NSString *filepath) {
    return [DocumentsDirectoryURL() URLByAppendingPathComponent:filepath];
}

-(void) copyDatabase{
    NSFileManager* filemgr = [NSFileManager defaultManager];
    
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* pathindocuments = [documentsDirectory stringByAppendingPathComponent:@"GamePlanDB.sqlite"];
    
    NSLog(@"path in documents - %@",pathindocuments);
    
    NSString* presentPath = [[NSBundle mainBundle]                      pathForResource:@"GamePlanDB" ofType:@"sqlite"];
    
    NSLog(@"path in bundle - %@",presentPath);
    
    if([filemgr fileExistsAtPath:pathindocuments]==YES)
    {
        NSLog(@"%@ - exists!!!",pathindocuments);
    }
    else
    {
        NSLog(@"%@ - does not exists!!!",pathindocuments);
        
        //[filemgr moveItemAtPath:presentPath toPath:pathindocuments error:nil];
        
        [filemgr copyItemAtPath:presentPath toPath:pathindocuments error:nil];
    //    [filemgr 
    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    //NSArray *files = [[NSFileManager defaultManager] contentsAtPath:[[NSBundle mainBundle] bundlePath]];
    
    [self copyDatabase];
    
	[window addSubview:splitViewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [splitViewController release];
    [description release];
    [window release];
    [super dealloc];
}


@end
