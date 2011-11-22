

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SecondDetailViewController : UIViewController <SubstitutableDetailViewController, MKMapViewDelegate> {
    
    UINavigationBar *navigationBar;
    IBOutlet MKMapView *mapView;
    NSMutableArray* arrayOfLocations;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray* arrayOfLocations;

@end
