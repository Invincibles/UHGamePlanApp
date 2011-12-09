//
//  BluetoothViewController.m
//  GamePlanApp
//
//  Created by Kowshik Gurram on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BluetoothViewController.h"
#import "databaseManager.h"

@implementation BluetoothViewController
@synthesize progressBar;
@synthesize textLabel, mySession, transferedfile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        transferedfile = [[NSString alloc] initWithString:@""];
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
    [connectBtn release];
    connectBtn = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [transferedfile release];
    [mySession release];
    [textLabel release];
    [progressBar release];
    [connectBtn release];
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
    //when the controller is initialize the _currentChunkId is set to -1 which indicates that we are receiving the header packet
    if (_numberOfChunks == -1) {
        _currentChunkId = 0; //now we change the _currentChunkId to 0
        [progressBar setProgress:0.0f];
        //reading the header packet to a string
        NSString* fileInfo = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",fileInfo);
        //splitting the string based on ',' we get number of chunks and transferred file name
        NSRange commapos = [fileInfo rangeOfString:@","];
        _numberOfChunks = [[fileInfo substringToIndex:commapos.location] integerValue];
        transferedfile = [[NSString alloc] initWithString:[fileInfo substringFromIndex:commapos.location+1]];
        
        NSLog(@"numbe rof chunks - %d, file name = %@",_numberOfChunks, transferedfile);
        
        //we initalize the array that stores the received packets
        _receivedDataChunks = [NSMutableData new];
        [fileInfo release];
    }
    else {
        //adding it to _receivedDataChunks
        [_receivedDataChunks appendData:data];
        [progressBar setProgress:((float)_currentChunkId/(float)_numberOfChunks)];
        //checking if the current chunk is the last chunk
        if (_currentChunkId == _numberOfChunks) {
            
            // write to file here
            NSFileManager* filemgr = [NSFileManager defaultManager];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *destPath = [documentsDirectory stringByAppendingPathComponent:transferedfile];
            
            NSLog(@"writing to path - %@",destPath);
            
            //creating and writing to file
            bool suc = [filemgr createFileAtPath:destPath contents:_receivedDataChunks attributes:nil];
            
            //if writing to file is successful
            if(suc == YES){
                //we add this file to the list of files in the app
                if(![filemgr fileExistsAtPath:transferedfile]){
                    databaseManager* dbmanager = [[databaseManager alloc] init];
                    [dbmanager updateNames];
                    dbmanager.db = [FMDatabase databaseWithPath:dbmanager.databasePath];
                    if(![dbmanager.db open]){
                        NSLog(@"Error: Could not connect to database.");
                        [dbmanager release];
                        return;
                    }
                    //inserting into filelist
                    NSString* query = [NSString stringWithFormat:@"insert into filelist (filename) values ('%@')",transferedfile];
                    NSLog(@"query string : %@",query);
                    
                    bool suc = [dbmanager.db executeUpdate:query];
                    
                    if(suc)
                        NSLog(@"insert to database is succesful.");
                    else
                        NSLog(@"insert to database failed.");
                    
                    [dbmanager.db close];
                    [dbmanager release];
                }
                //displaying the alert that shows the data is recieved successfully
                UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" message:@"File Recieved Successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [success show];
                [success release];
                
            }
            else{
                NSLog(@"file transfer failed.");
            }
            //we reset all the values for the next transfer
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

/*
 This function divides the data into chunks of size 60kb
 */
- (NSArray *)dataChunks:(NSData *)orgData {
    NSUInteger length = [orgData length];//we get the size of data here
    NSUInteger chunkSize = 60 * 1024;
    NSUInteger offset = 0; //we start from 0th byte
    
    NSMutableArray *returnArray = [NSMutableArray new];
    do {
        //we get the size of each chunk here, if its the last packet the size will be equal to number of remaining bytes
        NSUInteger thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset;
        //we read the chunk from offset to size of chunk we calculated above
        NSData* chunk = [NSData dataWithBytesNoCopy:(void*)[orgData bytes] + offset length:thisChunkSize freeWhenDone:NO];
        //we add this packet to an array
        [returnArray addObject:chunk];
        //we increase the offset value to calculate the next packet
        offset += thisChunkSize;
    } while (offset < length);

    return [returnArray autorelease];
}

- (IBAction)sendFileButton:(id)sender {
    [progressBar setProgress:0.0f];
    
    //we find the position of period to divide the filename and the extension
    NSRange dotpos = [transferedfile rangeOfString:@"."];
    
    //we get the file path from main bundle here
    NSString* path = [[NSBundle mainBundle] pathForResource:[transferedfile substringToIndex:dotpos.location] ofType:[transferedfile substringFromIndex:dotpos.location+1]];
    
    //if its not present in the main bundle 
    if(path == nil){
        //then we find the path from documents folder
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        path = [NSString stringWithFormat:@"%@/%@",documentsDirectory,transferedfile];
    }
    
    NSLog(@"%@",path);
    
    //we read the contents of file to nsdata
    NSData* fileData = [[NSData alloc] initWithContentsOfFile:path];
    NSLog(@"size of file - %d bytes",[fileData length]);
    //we are dividing the data into chunks and storing them into an array
    NSArray *dataArray = [self dataChunks:fileData];
    NSError *err = nil; //to store error value if it occurs during the transfer
    int noOfChunks = [dataArray count];//gives the number of chunks we should transfer
    
    //constructing the header packet here
    NSString *fileInfo = [NSString stringWithFormat:@"%d,%@", [dataArray count],transferedfile];
    NSLog(@"fileinfo - %@",fileInfo);
    
    //we start the communication by sending the header packet which contains the number of chunks to transferred and the filename
    [mySession sendData:[fileInfo dataUsingEncoding:NSUTF8StringEncoding] toPeers:myPeers withDataMode:GKSendDataReliable error:nil];
    
    int c=0;//to track the number of chunks transferred
    
    //for each chunk in the array
    for (NSData *dataToBeSent in dataArray) {
        //sending the data packet to myPeers
        if (![mySession sendData:dataToBeSent toPeers:myPeers withDataMode:GKSendDataReliable error:&err]) {
            //if there is an error we break the loop here
            if (err != nil) {
                break;
            }
            c++; //increase the chunks count
            [progressBar setProgress:((float)c/(float)noOfChunks)]; //increase the status bar
        }
    }
    
    //if there is an error
    if (err != nil) 
    {
        NSLog(@"I have an error - %@", [err localizedDescription]);
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error transfering file, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [error show];
        [error release];
    }
    else
    {
        //we display the success message
        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" message:@"File Transferred Successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [success show];
        [success release];
    }

}

- (IBAction)connectDisconnectBtn:(id)sender {
    
    //connect / disconnect button is a toggle button
    if([connectBtn.titleLabel.text isEqualToString:@"Connect"]){
        if(myPicker != nil) //if my picker is allocated
        {
            [myPicker show]; //we display all the peers that are available to connect
            //toggle the button text
            [connectBtn setTitle:@"Disconnect" forState:UIControlStateNormal];
        }
        else
        {
            NSLog(@"myPicker is nil, no peers to pick.");
        }
    }
    else{
        //on pressing the disconnect button, we disconnect from all peers
        [mySession disconnectFromAllPeers];
        //toggle the button text
        [connectBtn setTitle:@"Connect" forState:UIControlStateNormal];
    }
    
}

-(void)done
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
