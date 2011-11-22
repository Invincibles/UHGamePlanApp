//
//  NotesTableViewController.h
//  GamePlanApp
//
//  Created by Kowshik Gurram on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FileViewController;
@class AppDelegate;
@interface NotesTableViewController : UITableViewController
{
    AppDelegate *appDelegate;
    int rowcount; 
    NSMutableArray* arrayOfNotes;
}
@property(nonatomic,retain)NSMutableArray* arrayOfNotes;
@property (nonatomic, retain) AppDelegate *appDelegate;
@property(nonatomic,retain)FileViewController *fileVC;

-(void) loadAnnoataions;

@end
