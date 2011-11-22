//
//  FileViewController.h
//  MultipleDetailViews
//
//  Created by Invincibles on 10/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "RootViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "FMDatabase.h"
#import "databaseManager.h"
#import "BluetoothViewController.h"
#import "addTextFile.h"
@interface FileViewController : UIViewController <SubstitutableDetailViewController,CLLocationManagerDelegate>  {
    
    GKSession *presentSession;
    GKPeerPickerController *picker;
   // databaseManager *dbManager;
    UIWebView *fileWebView;
    UIToolbar *toolbar;
    NSString *filename;
    int fileID;
    BOOL ispotrait;
    CLLocationManager *lManager;
}
//@property(nonatomic,retain)databaseManager *dbManager;
@property(nonatomic, retain) GKSession *presentSession;
@property(nonatomic, retain) GKPeerPickerController *picker;
@property(nonatomic,retain)CLLocationManager *lManager;
@property(nonatomic)int fileID;
@property(nonatomic,retain)NSString *filename;
@property(nonatomic,retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIWebView *fileWebView;
- (IBAction)backButton:(id)sender;
- (IBAction)calenderButton:(id)sender;
- (IBAction)geotagButton:(id)sender;
- (IBAction)shareButton:(id)sender;
- (IBAction)contactButton:(id)sender;
- (IBAction)noteButton:(id)sender;
@end
