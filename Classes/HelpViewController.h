//
//  HelpViewController.h
//  GamePlanApp
//
//  Created by Kowshik Gurram on 11/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

#import "AppDelegate.h"

@interface HelpViewController : UIViewController<SubstitutableDetailViewController>{
    UIWebView *myWebView;
    UINavigationBar *navigationBar;
    UIBarButtonItem *fullScreenBtnOutlet;
}

- (IBAction)fullScreenBtn:(id)sender;
@property (nonatomic, retain) IBOutlet UIWebView *myWebView;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *fullScreenBtnOutlet;

@end
