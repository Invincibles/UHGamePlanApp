//
//  FolderListViewController.h
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 10/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareFilesViewController;
@class RootViewController;

@interface FolderListViewController : UIViewController <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    ShareFilesViewController* fileView;
    NSMutableArray* folderList;
    RootViewController* root;
    BOOL isFileSelected;
    int isSharedFilePortrait;
    IBOutlet UIBarButtonItem *downloadBtn;
}

@property (nonatomic, retain) ShareFilesViewController* fileView;
@property (nonatomic, retain) NSMutableArray* folderList;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) RootViewController* root;
@property (nonatomic) BOOL isFileSelected;
@property (nonatomic) int isSharedFilePortrait;

-(void) loadFolderList;
- (IBAction)createNewFolder:(id)sender;
- (IBAction)fileDownlaod:(id)sender;

@end
