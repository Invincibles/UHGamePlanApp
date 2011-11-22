//
//  GPFilePicker.h
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 11/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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

@end
