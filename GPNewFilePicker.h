//
//  GPNewFilePicker.h
//  GamePlanApp
//
//  Created by Kowshik Gurram on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 This view controller pops up when we press the download button.
 This reads the filename and the url from where to get the files.
 */

#import <UIKit/UIKit.h>

@interface GPNewFilePicker : UIViewController {
    UITextField *filenamefield; //textfield to read the filename
    UITextField *urlfield; //textfield to read the url
    UITextView *errorMsg; //label to display the error message
    UINavigationController *navigator;
}

@property (nonatomic, retain) IBOutlet UITextField *filenamefield;
@property (nonatomic, retain) IBOutlet UITextField *urlfield;
- (IBAction)getFileAction:(id)sender;
@property (nonatomic, retain) IBOutlet UITextView *errorMsg;

@property (nonatomic, retain) UINavigationController *navigator;

@end
