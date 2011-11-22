//
//  MyFileViewController.h
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 11/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareFilesViewController;

@interface MyFileViewController : UITableViewController
{
    UINavigationController* myNav;
    NSString* foldername;
    NSMutableArray* fileslist;
}

@property (nonatomic, retain) UINavigationController* myNav;
@property (nonatomic, retain) NSString* foldername;
@property (nonatomic, retain) NSMutableArray* fileslist;
@property (nonatomic, assign) ShareFilesViewController* delegate;

-(void) reloadfileslist;

@end
