//
//  FullMapViewController.h
//  GamePlanApp
//
//  Created by Kowshik Gurram on 11/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@class AnnotatedFilesTableViewController;
@interface FullMapViewController : UIViewController<MKMapViewDelegate> //, SubstitutableDetailViewController>
{
  NSMutableArray* arrayOfLocations;  
    MKMapView *mapView;
    NSString* anotationDescription;
    AnnotatedFilesTableViewController *annotatedFTVC;
    MKPinAnnotationView* pinView;
    NSString* latitude;
    NSString* longitude;
    
    
}
@property(nonatomic,retain)NSString* latitude;
@property(nonatomic,retain)NSString* longitude;

@property(nonatomic,retain)MKPinAnnotationView* pinView;
@property(nonatomic,retain)NSString* anotationDescription;
@property (nonatomic, retain) NSMutableArray* arrayOfLocations;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic,retain)AnnotatedFilesTableViewController *annotatedFTVC;

@end
