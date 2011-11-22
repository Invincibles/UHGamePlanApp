//
//  File.h
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 11/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface File : NSObject
{
    int fid;
    NSString* filename;
    BOOL isfolder;
    NSString* foldername;
    NSString* creationdate;
}

@property (nonatomic) int fid;
@property (nonatomic, retain) NSString* filename;
@property (nonatomic) BOOL isfolder;
@property (nonatomic, retain) NSString* foldername;
@property (nonatomic, retain) NSString* creationdate;

- (id)init:(int)id _filename:(NSString*)fn _isfolder:(BOOL)isFolder _foldername:(NSString*)folder _date:(NSString*)cdate;

@end
