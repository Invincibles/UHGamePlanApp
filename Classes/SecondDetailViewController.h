

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class AnnotatedFilesTableViewController;

@interface SecondDetailViewController : UIViewController <SubstitutableDetailViewController, MKMapViewDelegate> {
    
    //UINavigationBar *navigationBar;
    IBOutlet MKMapView *mapView;
    NSMutableArray* arrayOfLocations;
    UINavigationBar *navigationBar;
    UIBarButtonItem *fullScreenBtnOutlet;
    NSString* anotationDescription;
    NSString* latitude;
    NSString* longitude;
    AnnotatedFilesTableViewController* annotatedFTVC;
}
@property(nonatomic,retain)NSString* latitude;
@property(nonatomic,retain)NSString* longitude;
@property(nonatomic,retain)NSString* anotationDescription;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
- (IBAction)fullScreenBtn:(id)sender;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *fullScreenBtnOutlet;
@property(nonatomic,retain)AnnotatedFilesTableViewController* annotatedFTVC;
//@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray* arrayOfLocations;

@end
