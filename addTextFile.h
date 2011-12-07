//
//  addTextFile.h
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 11/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NotesTableViewController;

@interface addTextFile : UIViewController<UITextViewDelegate> {
    
    NSString *description; 
    IBOutlet UITextView *textview;
    
}

@property(nonatomic,retain)NSString* description;

@property (nonatomic, assign) NotesTableViewController *delegate;

- (void)cancelNote;

@end
