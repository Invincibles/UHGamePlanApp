//
//  HelpFullScreenVC.m
//  GamePlanApp
//
//  Created by Kowshik Gurram on 12/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HelpFullScreenVC.h"

@implementation HelpFullScreenVC
@synthesize myWebView;

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
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.title=@"User Guide";
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    myWebView.scalesPageToFit=YES;
    
    NSString *urlAdd = [[NSBundle mainBundle] pathForResource:@"userguide" ofType: @"pdf"];
    NSURL *ur = [NSURL fileURLWithPath:urlAdd]; 
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:ur]; 
    [myWebView loadRequest:requestObj];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setMyWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
    [myWebView release];
    [super dealloc];
}
@end
