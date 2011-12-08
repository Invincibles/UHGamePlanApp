//
//  BluetoothViewController.h
//  GamePlanApp
//
//  Created by Kowshik Gurram on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface BluetoothViewController : UIViewController<GKPeerPickerControllerDelegate, GKSessionDelegate, UIAlertViewDelegate> 
{
    GKPeerPickerController *myPicker;
    GKSession *mySession;
    NSMutableArray *myPeers;
    UIImageView *sharedImage;
    
    UILabel *textLabel;
    UIProgressView *progressBar;
    
    NSString* transferedfile;
    NSInteger _numberOfChunks;
    NSInteger _currentChunkId;
    NSMutableData *_receivedDataChunks;
    BOOL receiveFile;
    IBOutlet UIButton *connectBtn;
}
@property (nonatomic, retain) IBOutlet UIProgressView *progressBar;
@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (retain) GKSession *mySession;
@property (nonatomic, retain) NSString* transferedfile;

- (IBAction)connectDisconnectBtn:(id)sender;
- (IBAction)sendFileButton:(id)sender;

@end
