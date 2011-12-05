//
//  FileIcon.h
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 11/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareFilesViewController;

@interface FileIcon : UIView
{
    UIImageView* fileImage;
    UILabel* fileNameLabel;
    UIButton* fileButton;
    int fileid; //this is to be shared by fileviewcontroller
    NSDate *openedDate;
}

@property (nonatomic, retain) NSDate* openedDate;
@property (nonatomic, retain) UIImageView* fileImage;
@property (nonatomic, retain) UILabel* fileNameLabel;
@property (nonatomic, retain) UIButton* fileButton;
@property (nonatomic, assign) ShareFilesViewController* mydelegate;
@property (nonatomic) int fileid;

- (id)initWithFrame:(CGRect)frame _filename:(NSString*)filename _fileid:(int)fid;

@end
