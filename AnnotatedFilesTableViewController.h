//
//  AnnotatedFilesTableViewController.h
//  GamePlanApp
//
//  Created by Kowshik Gurram on 12/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullMapViewController.h"
#import "SecondDetailViewController.h"
@class FullMapViewController;
@class SecondDetailViewController;
@interface AnnotatedFilesTableViewController : UITableViewController
{
    FullMapViewController *fullMapVC;
    SecondDetailViewController *detailMVC;
    NSMutableArray* arrayOfFiles;  // this array is used to store the files tagged in that region 
     int rowcount;   // this variable is used to set the number of rows in a table view
    NSString* geoDescription; // this gives us the description of the place
    NSString* latitude;  // this has the latitude of selected place 
    NSString* longitude; // this has the longitude of selected place 
    
    
}
@property(nonatomic,retain)SecondDetailViewController *detailMVC;
@property(nonatomic,retain) FullMapViewController *fullMapVC;
@property(nonatomic,retain)NSMutableArray* arrayOfFiles;
@property(nonatomic,retain) NSString* geoDescription;
@property(nonatomic,retain) NSString* latitude;
@property(nonatomic,retain) NSString* longitude;



@end
