//
//  databaseManager.m
//  MultipleDetailViews
//
//  Created by Invincibles on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "databaseManager.h"


@implementation databaseManager
@synthesize window;
@synthesize navigationController;
@synthesize aryDatabase;
@synthesize databaseName;
@synthesize databasePath;
@synthesize db;

#pragma mark -
#pragma mark Application lifecycle

-(void)updateNames{
	databaseName = @"GamePlanDB.sqlite";
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
}
/*
-(void) checkAndCreateDatabase{
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	success = [fileManager fileExistsAtPath:databasePath];
	//if(success) return;
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	[fileManager release];
}
*/


@end
