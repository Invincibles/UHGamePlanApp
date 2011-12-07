//
//  GPNewFilePicker.m
//  GamePlanApp
//
//  Created by Kowshik Gurram on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "databaseManager.h"
#import "GPNewFilePicker.h"

@implementation GPNewFilePicker
@synthesize errorMsg;
@synthesize filenamefield;
@synthesize urlfield;
@synthesize navigator;

-(void) cancelAction:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        navigator = [[UINavigationController alloc] initWithRootViewController:self];
        navigator.navigationBar.tintColor = [[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
        self.navigationItem.rightBarButtonItem = cancelButton;
        [cancelButton release];
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
    [super viewDidLoad];
    self.title = @"Download New File";
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setFilenamefield:nil];
    [self setUrlfield:nil];
    [self setErrorMsg:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)dealloc {
    [filenamefield release];
    [urlfield release];
    [errorMsg release];
    [super dealloc];
}
- (IBAction)getFileAction:(id)sender {
    
    //validate the text fields first
    errorMsg.text = @"";
    
    NSString *filename = filenamefield.text;
    NSString *urlString = urlfield.text;
    
    if([filename isEqualToString:@""]){
        errorMsg.text = [NSString stringWithFormat:@"%@\nfile name cannot be empty.",errorMsg.text];
    }
    
    if([urlString isEqualToString:@""] || [urlString isEqualToString:@"http://"]){
        errorMsg.text = [NSString stringWithFormat:@"%@\nurl cannot be empty.",errorMsg.text];
        
    }
    
    NSRange start;
    start = [filename rangeOfString:@"."];
    NSString *extention = [filename substringFromIndex:start.location+1];
    
    if(start.location == NSNotFound){
        errorMsg.text = [NSString stringWithFormat:@"%@\nFile should contain an extention.",errorMsg.text];
    }
    else if(!([extention isEqualToString:@"pdf"] || [extention isEqualToString:@"doc"] || [extention isEqualToString:@"doc"] || [extention isEqualToString:@"ppt"] || [extention isEqualToString:@"pptx"] || [extention isEqualToString:@"png"] || [extention isEqualToString:@"jpg"])){
        errorMsg.text = [NSString stringWithFormat:@"%@\nFile extention is not supported. (should be pdf, doc, docx, png, jpg, pptx or ppt)",errorMsg.text];
    }
    
    if([errorMsg.text isEqualToString:@""]){

        NSFileManager *filemgr = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* filePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,filename];
        
        if([filemgr fileExistsAtPath:filePath]){
            errorMsg.text = @"File with the given name already exists. Please give another name.";
            return;
        }
        
        NSData *filedata = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        
        if(filedata == NULL){
            NSLog(@"file data is null.");
        }
        else{
            NSLog(@"file data is not null.");
        }
        
        bool suc = [filedata writeToFile:filePath atomically:YES];
        
        if(suc){
            [self dismissModalViewControllerAnimated:YES];
            
            databaseManager* dbmanager = [[databaseManager alloc] init];
            [dbmanager updateNames];
            dbmanager.db = [FMDatabase databaseWithPath:dbmanager.databasePath];
            if(![dbmanager.db open]){
                NSLog(@"Error: Could not connect to database.");
                return;
            }
            
            NSString* query = [NSString stringWithFormat:@"insert into filelist (filename) values ('%@')",filename];
            NSLog(@"query string : %@",query);
            
            bool suc = [dbmanager.db executeUpdate:query];
            
            if(suc)
                NSLog(@"insert to database is succesful.");
            else
                NSLog(@"insert to database failed.");
            
            [dbmanager.db close];
            [dbmanager release];
        }
        else{
            errorMsg.text = @"Writing to file failed. Please try again.";
        }
    }
}
@end
