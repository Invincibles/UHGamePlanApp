//
//  NotesTableViewController.h
//  GamePlanApp
//
//  Created by Kowshik Gurram on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 This class lists all the annotations associated with a given file with the latest one first. This also has features to add a new note to file and view / edit an already existing note.
 */

#import <UIKit/UIKit.h>

@class FileViewController;
@class AppDelegate;
@interface NotesTableViewController : UITableViewController
{
    AppDelegate *appDelegate;
    int rowcount; 
    NSMutableArray* arrayOfNotes;//contains the list of all notes
}
@property(nonatomic,retain)NSMutableArray* arrayOfNotes;
@property (nonatomic, retain) AppDelegate *appDelegate;
@property(nonatomic,retain)FileViewController *fileVC;

-(void) loadAnnoataions;//this function gets the list of all annotations that are associated with a fie, the latest one appears first

@end
