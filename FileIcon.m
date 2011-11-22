//
//  FileIcon.m
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 11/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileIcon.h"
#import "FileViewController.h"

@implementation FileIcon

@synthesize fileImage,fileNameLabel,fileButton,mydelegate,fileid;

-(void) aMethod:(id)sender
{
    NSLog(@"%@ is clicked. fid - %d",fileNameLabel.text,fileid);
    
    FileViewController *fvc = [[FileViewController alloc] initWithNibName:@"FileViewController" bundle:[NSBundle mainBundle]];
    fvc.fileID = self.fileid;
    NSArray *split = [fileNameLabel.text componentsSeparatedByString:@"."];
    fvc.filename=[split objectAtIndex:0];
    [mydelegate presentModalViewController:fvc animated:YES];
    [fvc release];
}

- (id)initWithFrame:(CGRect)frame _filename:(NSString*)filename _fileid:(int)fid
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.fileid = fid;
        
        // Initialization code
        fileImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"file-view-icon-witharrow.png"]];
        fileImage.frame = CGRectMake(0, 0, 90, 100);
        
        fileNameLabel = [[UILabel alloc] init];
        fileNameLabel.textAlignment = UITextAlignmentCenter;
        fileNameLabel.frame = CGRectMake(0, 105, 90, 20);
        fileNameLabel.text = filename;
        fileNameLabel.backgroundColor = [UIColor clearColor];
        
        fileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [fileButton addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
        fileButton.frame = CGRectMake(0, 0, 90, 125);
        fileButton.alpha = 0.9;
        fileButton.enabled = YES;
        
        self.userInteractionEnabled = YES;
        //self.clipsToBounds = YES;
        
        [self addSubview:fileImage];
        [self addSubview:fileNameLabel];
        [self addSubview:fileButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
