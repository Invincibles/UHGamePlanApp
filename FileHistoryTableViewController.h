//
//  FileHistoryTableViewController.h
//  GamePlanApp
//
//  Created by Kowshik Gurram on 12/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileViewController.h"

@class FileViewController;
@interface FileHistoryTableViewController : UITableViewController
{
    FileViewController *fileVC;
    int rowcount; 
    NSMutableArray* arrayOfHistory; // this array used to store the history
}
@property(nonatomic,retain)FileViewController *fileVC;
@property(nonatomic,retain)NSMutableArray* arrayOfHistory;

@end
