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
    NSMutableArray* arrayOfFiles;
     int rowcount; 
    NSString* geoDescription;
    NSString* latitude;
    NSString* longitude;
    
    
}
@property(nonatomic,retain)SecondDetailViewController *detailMVC;
@property(nonatomic,retain) FullMapViewController *fullMapVC;
@property(nonatomic,retain)NSMutableArray* arrayOfFiles;
@property(nonatomic,retain) NSString* geoDescription;
@property(nonatomic,retain) NSString* latitude;
@property(nonatomic,retain) NSString* longitude;



@end
