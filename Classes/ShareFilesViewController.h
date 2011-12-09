//
//  ShareFilesViewController.h
//  MultipleDetailViews
//
//  Created by Invincibles on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 This is the view controller that has the rack view presented, all the files are arranged in the rack.
 */

#import <UIKit/UIKit.h>
#import "RootViewController.h"

#import "AppDelegate.h"

@class FolderListViewController;

@interface ShareFilesViewController : UIViewController <SubstitutableDetailViewController, UIScrollViewDelegate> {
    
    UIToolbar *toolbar;
    UINavigationBar *navigationBar;
    UIBarButtonItem *Button;
    IBOutlet UIBarButtonItem *previousBtn;
    IBOutlet UIBarButtonItem *nextBtn;    
    IBOutlet UILabel *numberOfFiles;
    
    NSString* foldername;
    NSMutableArray* fileslist;
    NSMutableArray* arrayoffileicons;
    UIScrollView *scrollView;
    UIBarButtonItem *manageFolderBtn;
    UIButton *manageFolderOutlet;
    int isLandscpae;
    FolderListViewController *folderListView;
    BOOL isFolderViewPresent;
}
@property (nonatomic, retain) IBOutlet UIBarButtonItem *manageFolderBtn;
@property (nonatomic, retain) IBOutlet UIButton *manageFolderOutlet;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic,retain) UIBarButtonItem *Button;
@property (nonatomic, retain) IBOutlet UILabel *numberOfFiles;
@property (nonatomic, retain) NSString* foldername;
@property (nonatomic, retain) NSMutableArray* fileslist;
@property (nonatomic, retain) NSMutableArray* arrayoffileicons;

@property (nonatomic) int isLandscape;

@property (nonatomic, assign) FolderListViewController *folderListView;
@property (nonatomic) BOOL isFolderViewPresent;

- (IBAction)previousButton:(id)sender;
- (IBAction)nextButton:(id)sender;
- (void) reloadFiles;
- (void) loadFilesList;
- (IBAction)manageFolderAction:(id)sender;

@end
