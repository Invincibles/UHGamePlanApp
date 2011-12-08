//
//  BluetoothViewController.m
//  GamePlanApp
//
//  Created by Kowshik Gurram on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BluetoothViewController.h"

@implementation BluetoothViewController
@synthesize progressBar;
@synthesize textLabel, mySession;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.title=@"Share File";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
    
    [super viewDidLoad];
    
    _numberOfChunks = -1;
    _receivedDataChunks = [NSMutableData new];
    
    //initializing the peer picker and setting the coneection type to wifi or bluetooth
    myPicker = [[GKPeerPickerController alloc] init];
    myPicker.delegate = self;
    myPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    myPeers = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTextLabel:nil];
    [self setProgressBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [mySession release];
    [textLabel release];
    [progressBar release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

-(GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type{
    
    NSString *txt = textLabel.text;
    
    GKSession* session = [[GKSession alloc] initWithSessionID:@"Invincibles" displayName:txt sessionMode:GKSessionModePeer];
    
    [session autorelease];
    return session;
}

-(void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
    
    NSLog(@"Connected to %@",peerID);
    
    self.mySession = session;
    session.delegate =self;
    //setting a recieve handler 
    [session setDataReceiveHandler:self withContext:nil];
    //removing the picker
    picker.delegate = nil;
    [picker dismiss];
    [picker autorelease];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //file recieve denied clicked ...do your action
        receiveFile = NO;
        
    }
    else if (buttonIndex == 1)
    {
        //file recieve accepted clicked
        receiveFile = YES;
    }
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
    // Read the bytes in data and perform an application-specific action.
    
    //*************************//
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Recieve File?" message:@"Do you want to recieve this File?" delegate:self cancelButtonTitle:@"Deny" otherButtonTitles:@"Accept"] autorelease];
    [alert show];
    
    if(receiveFile){
        //recieve file code goes here
    }
    else
    {
        //call the disconnect button
    }
    
    //**************************//
    if (_numberOfChunks == -1) {
        _currentChunkId = 0;
        [progressBar setProgress:0.0f];
        NSString* fileInfo = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        _numberOfChunks = [fileInfo integerValue];
        _receivedDataChunks = [NSMutableData new];
        [fileInfo release];
    }
    else {
        
        [_receivedDataChunks appendData:data];
        [progressBar setProgress:((float)_currentChunkId/(float)_numberOfChunks)];
        if (_currentChunkId == _numberOfChunks) {
            
            // write to file here
            NSFileManager* filemgr = [NSFileManager defaultManager];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *destPath = [documentsDirectory stringByAppendingPathComponent:@"copiedFile.pdf"];
            
            NSLog(@"writing to path - %@",destPath);
            
            bool suc = [filemgr createFileAtPath:destPath contents:_receivedDataChunks attributes:nil];
            
            if(suc == YES)
                NSLog(@"file copied successfully.");
            else
                NSLog(@"file transfer failed.");
            
            [_receivedDataChunks release];
            _receivedDataChunks = nil;
            _numberOfChunks = -1;
        }
    }
    
    _currentChunkId++;
    
}


/* Indicates a state change for the given peer.
 */
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
    
	switch (state)
    {
        case GKPeerStateConnected:
		{
			NSString *str=[NSString stringWithFormat:@"%@\n%@%@",textLabel.text,@"Connected from peer ",peerID];
			textLabel.text= str;
			NSLog(@"%@",str);
			[myPeers addObject:peerID];
			break;
		}
        case GKPeerStateDisconnected:
		{
			[myPeers removeObject:peerID];
            
			NSString *str=[NSString stringWithFormat:@"%@\n%@%@",textLabel.text,@"DisConnected from peer ",peerID];
			textLabel.text= str;
			NSLog(@"%@",str);
			break;
		}
        default:
            break;
    }
}

-(void) divideFileToChunks
{
    
    NSFileManager* filemgr = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSData* data1 = [NSData dataWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:@"test.pdf"]];
    
    NSLog(@"file size - %d",[data1 length]);
    
    NSUInteger length = [data1 length];
    NSUInteger chunkSize = 100 * 1024;
    NSUInteger offset = 0;
    //NSLog(@"number of chunks = %d",length/chunkSize);
    NSMutableData* recData = [[NSMutableData alloc] initWithCapacity:1];
    do {
        NSUInteger thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset;
        NSData* chunk = [NSData dataWithBytesNoCopy:(void*)[data1 bytes] + offset length:thisChunkSize freeWhenDone:NO];
        [recData appendBytes:[chunk bytes] length:[chunk length]];
        offset += thisChunkSize;
    } while (offset < length);
    
    /*
     this is for grouping packets
     [data appendBytes:packet1 length:[packet1 length]];
     here data is nsmutabledata, packet1 is nsdata
     */
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:@"test10.pdf"];
    
    NSLog(@"full path : %@",fullPath);
    
    bool suc = [filemgr createFileAtPath:fullPath contents:recData attributes:nil];
    
    if(suc)
    {
        NSLog(@"file created.");
    }
    else
    {
        NSLog(@"file not created.");
    }
    
    if([filemgr fileExistsAtPath:fullPath]==YES)
        NSLog(@"File Exists !");
    else
        NSLog(@"File not found.");
    
    [recData release];
}

- (NSArray *)dataChunks:(NSData *)orgData {
    NSUInteger length = [orgData length];
    NSUInteger chunkSize = 60 * 1024;
    NSUInteger offset = 0;
    
    NSMutableArray *returnArray = [NSMutableArray new];
    do {
        NSUInteger thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset;
        NSData* chunk = [NSData dataWithBytesNoCopy:(void*)[orgData bytes] + offset length:thisChunkSize freeWhenDone:NO];
        [returnArray addObject:chunk];
        offset += thisChunkSize;
    } while (offset < length);
    
    return [returnArray autorelease];
}

- (IBAction)sendFileButton:(id)sender {
    [progressBar setProgress:0.0f];
    
    //push a controller here
    NSString* path = [[NSBundle mainBundle] pathForResource:@"test1" ofType:@"pdf"];
    NSData* fileData = [[NSData alloc] initWithContentsOfFile:path];
    NSLog(@"size of file - %d bytes",[fileData length]);
    NSArray *dataArray = [self dataChunks:fileData];
    NSError *err = nil;
    int noOfChunks = [dataArray count];
    NSString *fileInfo = [NSString stringWithFormat:@"%d", [dataArray count]];
    [mySession sendData:[fileInfo dataUsingEncoding:NSUTF8StringEncoding] toPeers:myPeers withDataMode:GKSendDataReliable error:nil];
    
    int c=0;
    
    for (NSData *dataToBeSent in dataArray) {
        if (![mySession sendData:fileData toPeers:myPeers withDataMode:GKSendDataReliable error:&err]) {
            if (err != nil) {
                NSLog(@"coming here....");
                break;
            }
            c++;
            [progressBar setProgress:((float)c/(float)noOfChunks)];
        }
    }
    
    if (err != nil) 
    {
        NSLog(@"I have an error - %@", [err localizedDescription]);
    }
    else
    {
        NSLog(@"File transferred successfully.");
    }

}


- (IBAction)connectDisconnectBtn:(id)sender {
    
    if(myPicker != nil)
    {
        [myPicker show];
    }
    else
    {
        NSLog(@"myPicker is nil, no peers to pick.");
    }
    
}

-(void)done
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
