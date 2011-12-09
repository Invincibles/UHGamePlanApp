//
//  MyFileViewController.h
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 11/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 This controller is used to list all the files present in a folder
 */

#import <UIKit/UIKit.h>

@class ShareFilesViewController;

@interface MyFileViewController : UITableViewController
{
    UINavigationController* myNav;
    NSString* foldername; //this contains the foldername
    NSMutableArray* fileslist; //this contains the list of all files in the current folder
}

@property (nonatomic, retain) UINavigationController* myNav;
@property (nonatomic, retain) NSString* foldername;
@property (nonatomic, retain) NSMutableArray* fileslist;
@property (nonatomic, assign) ShareFilesViewController* delegate;

//this function is used to reload list of files in given folder
-(void) reloadfileslist;

@end
