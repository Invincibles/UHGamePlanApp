//
//  CustomUIAlert.h
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 11/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 For reading a folder name from user, instead of creating a uiviewcontroller, we tried to use this customized version of UIAlertView, this prompts and requests for a folder name.
 */

#import <Foundation/Foundation.h>

@interface CustomUIAlert : UIAlertView
{
    UITextField* textField;
}

@property (nonatomic, retain) UITextField *textField;
@property (readonly) NSString *enteredText;
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;
@end
