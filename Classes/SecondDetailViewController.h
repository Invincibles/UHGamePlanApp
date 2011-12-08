

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class AnnotatedFilesTableViewController;

@interface SecondDetailViewController : UIViewController <SubstitutableDetailViewController, MKMapViewDelegate> {
    
    IBOutlet MKMapView *mapView;   //this mapview is used to display the map
    NSMutableArray* arrayOfLocations;// this array is used to store the array of locations 
    UINavigationBar *navigationBar;
    NSString* anotationDescription;
    NSString* latitude;
    NSString* longitude;
    AnnotatedFilesTableViewController* annotatedFTVC;// instance of annotatedFilesTableviecontroller
    UIBarButtonItem *fullScreenBtn;
}
@property(nonatomic,retain)NSString* latitude;
@property(nonatomic,retain)NSString* longitude;
@property(nonatomic,retain)NSString* anotationDescription;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property(nonatomic,retain)AnnotatedFilesTableViewController* annotatedFTVC;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *fullScreenBtn;
- (IBAction)fullScreen:(id)sender;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray* arrayOfLocations;

@end
