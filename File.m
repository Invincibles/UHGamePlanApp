//
//  File.m
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 11/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "File.h"

@implementation File

@synthesize fid,filename,isfolder,foldername, creationdate;

- (id)init:(int)id _filename:(NSString*)fn _isfolder:(BOOL)isFolder _foldername:(NSString*)folder _date:(NSString*)cdate
{
    self = [super init];
    if (self) {
        // Initialization code here.
        fid = id;
        filename = [[NSString alloc] initWithString:fn];
        isfolder = isFolder;
        foldername = [[NSString alloc] initWithString:folder];
        creationdate = [[NSString alloc] initWithString:cdate];
    }
    return self;
}

-(void) dealloc
{
    [filename release];
    [foldername release];
    [creationdate release];
    [super dealloc];
}

@end
