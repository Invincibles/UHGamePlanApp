//
//  databaseManager.h
//  MultipleDetailViews
//
//  Created by Invincibles on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface databaseManager : NSObject {
    UIWindow *window;
    UINavigationController *navigationController;
	NSMutableArray* aryDatabase;
	NSString* databaseName;
	NSString* databasePath;
	FMDatabase* db;
    
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property(nonatomic,retain)NSString *databasePath;
@property(nonatomic,retain)NSString *databaseName;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic,retain) NSMutableArray* aryDatabase;
@property(nonatomic,retain)FMDatabase* db;

-(void)updateNames;

@end
