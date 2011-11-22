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

@interface FullMapViewController : UIViewController<SubstitutableDetailViewController, MKMapViewDelegate>
{
  NSMutableArray* arrayOfLocations;  
    MKMapView *mapView;
}
@property (nonatomic, retain) NSMutableArray* arrayOfLocations;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@end
