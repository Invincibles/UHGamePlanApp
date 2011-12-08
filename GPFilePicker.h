//
//  GPFilePicker.h
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 11/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 This controller lists all the files in your application. It makes use of a database to store the files, it is updated each time a file is downloaded or received from bluetooth.
 */

#import <UIKit/UIKit.h>

@class MyFileViewController;

@interface GPFilePicker : UITableViewController
{
    UINavigationController* myNavigator;
    NSMutableArray* filesList;
    MyFileViewController* delegate;
}

@property (nonatomic, retain) UINavigationController* myNavigator;
@property (nonatomic, retain) NSMutableArray* filesList;
@property (nonatomic, retain) MyFileViewController* delegate;

-(void) loadFilesList;

@end
