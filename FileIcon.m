//
//  FileIcon.m
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 11/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileIcon.h"
#import "FileViewController.h"
#import "databaseManager.h"
#import "FolderListViewController.h"
#import "ShareFilesViewController.h"
#import "FolderListViewController.h"

@implementation FileIcon

@synthesize fileImage,fileNameLabel,fileButton,mydelegate,fileid,openedDate;

-(void) aMethod:(id)sender
{
    
    NSLog(@"%@ is clicked. fid - %d",fileNameLabel.text,fileid);
    
    // added for history
     
     databaseManager *dbManager=[[databaseManager alloc] init];
     [dbManager updateNames];
     dbManager.db = [FMDatabase databaseWithPath:dbManager.databasePath];
     NSLog(@"path ---- %@",dbManager.databasePath);
     if(![dbManager.db open]){
     NSLog(@"Could not open db.");
     return;
     }
     else{
     NSLog(@"database is open.");
     }
     openedDate = [NSDate date];
    
     //NSLog(@"%@",now);
     
     NSString* query = [[NSString alloc] initWithString:[NSString stringWithFormat:@"insert into filehistory (fid,openeddate) values (%d,'%@')",fileid,openedDate]];
     NSLog(@"%@", query);
     BOOL suc = [dbManager.db executeUpdate:query];
     if(suc)
     NSLog(@"insert is successful.");
     else
     NSLog(@"insert failed.");
     
    [dbManager.db close];
    mydelegate.folderListView.isFileSelected = TRUE;
    FileViewController *fvc = [[FileViewController alloc] initWithNibName:@"FileViewController" bundle:[NSBundle mainBundle]];
    fvc.sharedFiles = mydelegate;
    fvc.fileID = self.fileid;
    fvc.openedDate=self.openedDate;
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
