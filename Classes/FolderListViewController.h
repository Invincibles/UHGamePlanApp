//
//  FolderListViewController.h
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 10/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareFilesViewController;

@interface FolderListViewController : UIViewController <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    ShareFilesViewController* fileView;
    NSMutableArray* folderList;
}

@property (nonatomic, retain) ShareFilesViewController* fileView;
@property (nonatomic, retain) NSMutableArray* folderList;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

-(void) loadFolderList;
- (IBAction)createNewFolder:(id)sender;
- (IBAction)fileDownlaod:(id)sender;

@end
