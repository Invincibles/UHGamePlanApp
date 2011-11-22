//
//  CustomUIAlert.h
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 11/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomUIAlert : UIAlertView
{
    UITextField* textField;
}

@property (nonatomic, retain) UITextField *textField;
@property (readonly) NSString *enteredText;
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;
@end
