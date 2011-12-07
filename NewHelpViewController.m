//
//  NewHelpViewController.m
//  GamePlanApp
//
//  Created by Kowshik Gurram on 12/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewHelpViewController.h"

@implementation NewHelpViewController
@synthesize fullScreenOutlet;
@synthesize myWebView;
@synthesize navigationBar;

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
    [super viewDidLoad];
    
    myWebView.scalesPageToFit=YES;
    
    NSString *urlAdd = [[NSBundle mainBundle] pathForResource:@"userguide" ofType: @"pdf"];
    NSURL *ur = [NSURL fileURLWithPath:urlAdd]; 
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:ur]; 
    [myWebView loadRequest:requestObj];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setNavigationBar:nil];
    [self setFullScreenOutlet:nil];
    [self setMyWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem{
    [navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:NO];
}

-(void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem{
    [navigationBar.topItem setLeftBarButtonItem:nil animated:NO];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if(UIDeviceOrientationIsPortrait(toInterfaceOrientation))
        [fullScreenOutlet setEnabled:NO];
    else
        [fullScreenOutlet setEnabled:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
    [navigationBar release];
    [fullScreenOutlet release];
    [myWebView release];
    [super dealloc];
}

- (IBAction)fullScreenAction:(id)sender {
    
    HelpFullScreenVC *fullScreenVC = [[HelpFullScreenVC alloc] initWithNibName:@"HelpFullScreenVC" bundle:[NSBundle mainBundle]];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:fullScreenVC];
    nav.navigationBar.tintColor=[[UIColor alloc] initWithRed:(54.0f/255.0f) green:(23.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f];
    [self presentModalViewController:nav animated:YES];
}
@end
