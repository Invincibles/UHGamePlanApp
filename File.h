//
//  File.h
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 11/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 The main purpose of this class is to encapslate a file as an object. It contains properties like file id, filename, folder to which it belongs, when it is created.
 Each folder is also handled as a file which has isfolder set to true, if its a file isfolder is set to false.
 */

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

//this function takes file properties as input and returns a file object
- (id)init:(int)id _filename:(NSString*)fn _isfolder:(BOOL)isFolder _foldername:(NSString*)folder _date:(NSString*)cdate;

@end
