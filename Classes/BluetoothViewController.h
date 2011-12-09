//
//  BluetoothViewController.h
//  GamePlanApp
//
//  Created by Kowshik Gurram on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 This view controller is used to share the current file via bluetooth.
 We use the GKSendDataReliable mode to transfer data.
 There is a limitation(64kb) on the size of packet that we can transfer at a time.
 */

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
    
    NSString* transferedfile; //this is the name of the file being transfered / recieved
    NSInteger _numberOfChunks; //this is the number of chunks we are receiving
    NSInteger _currentChunkId; //this stores the current chunk that is being received
    NSMutableData *_receivedDataChunks; //this stores all the data recieved in the transfer
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
