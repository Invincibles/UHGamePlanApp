//
//  NewHelpViewController.h
//  GamePlanApp
//
//  Created by Kowshik Gurram on 12/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "HelpFullScreenVC.h"

@interface NewHelpViewController : UIViewController<SubstitutableDetailViewController> {
    UINavigationBar *navigationBar;
    UIBarButtonItem *fullScreenOutlet;
    UIWebView *myWebView;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
- (IBAction)fullScreenAction:(id)sender;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *fullScreenOutlet;
@property (nonatomic, retain) IBOutlet UIWebView *myWebView;

@end
