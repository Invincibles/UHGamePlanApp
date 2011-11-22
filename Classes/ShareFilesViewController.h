//
//  ShareFilesViewController.h
//  MultipleDetailViews
//
//  Created by Invincibles on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

#import "AppDelegate.h"
@interface ShareFilesViewController : UIViewController <SubstitutableDetailViewController, UIScrollViewDelegate> {
    
    UIToolbar *toolbar;
    UINavigationBar *navigationBar;
    UIBarButtonItem *Button;
    IBOutlet UIBarButtonItem *previousBtn;
    IBOutlet UIBarButtonItem *nextBtn;    
    IBOutlet UILabel *numberOfFiles;
    
    NSString* foldername;
    NSMutableArray* fileslist;
    //int fileCount;
    NSMutableArray* arrayoffileicons;
    UIScrollView *scrollView;
    UIBarButtonItem *manageFolderBtn;
}
@property (nonatomic, retain) IBOutlet UIBarButtonItem *manageFolderBtn;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic,retain) UIBarButtonItem *Button;
@property (nonatomic, retain) IBOutlet UILabel *numberOfFiles;
@property (nonatomic, retain) NSString* foldername;
@property (nonatomic, retain) NSMutableArray* fileslist;
//@property (nonatomic) int fileCount;
@property (nonatomic, retain) NSMutableArray* arrayoffileicons;

- (IBAction)previousButton:(id)sender;
- (IBAction)nextButton:(id)sender;
- (void) reloadFiles;
- (void) loadFilesList;
//- (IBAction)file1:(id)sender;
//- (IBAction)file2:(id)sender;
//- (IBAction)file3:(id)sender;
//- (IBAction)file4:(id)sender;

@end
