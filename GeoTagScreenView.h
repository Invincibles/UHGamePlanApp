//
//  GeoTagScreenView.h
//  MultipleDetailViews
//
//  Created by Invincibles on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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
@property (nonatomic, retain) IBOutlet UILabel *myLatitude;
@property (nonatomic, retain) IBOutlet UILabel *myLongitude;
@property (nonatomic, retain) IBOutlet UITextView *myTextView;
@property(nonatomic,retain)FileViewController *fileVC;

@end
