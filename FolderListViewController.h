//
//  FolderListViewController.h
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 10/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 This is the controller that is pushed on to root view when files option is clicked. It contains a list of all the folders.
 By clicking on the folder the user can view the files in that folder.
 */

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
- (IBAction)downloadAction:(id)sender;
- (IBAction)newFolderAction:(id)sender;

@end
