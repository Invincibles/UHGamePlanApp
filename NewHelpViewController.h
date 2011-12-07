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
    UIWebView *myWebView;
    UIBarButtonItem *fullScreenOutlet;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UIWebView *myWebView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *fullScreenOutlet;
- (IBAction)fullScreenAction:(id)sender;

@end
