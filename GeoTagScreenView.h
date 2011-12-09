//
//  GeoTagScreenView.h
//  MultipleDetailViews
//
//  Created by Invincibles on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 This view controller is used to tag a file opened in the current location.
 It displays the latitude and longitude of the current location, user should give a description to it so that he can easy remember it.
 */

#import <UIKit/UIKit.h>

@class FileViewController;
@interface GeoTagScreenView : UIViewController {
    
    UINavigationController* navigator;
    UILabel *myLatitude; 
    UILabel *myLongitude;
    UITextView *myTextView;

    IBOutlet UITextField *myLatitudeTF;
    IBOutlet UITextField *myLongitudeTF;
}
@property (nonatomic, retain) UINavigationController* navigator;
@property (nonatomic, retain) IBOutlet UILabel *myLatitude;// this label is used to store the laitutde
@property (nonatomic, retain) IBOutlet UILabel *myLongitude;//this label is used to store the longitude
@property (nonatomic, retain) IBOutlet UITextView *myTextView;//this label is used to store the textview
@property(nonatomic,retain)FileViewController *fileVC;

@end
