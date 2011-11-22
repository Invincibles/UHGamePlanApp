//
//  MapAnnotation.m
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 10/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

@synthesize title, coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {
	[super init];
	title = ttl;
	coordinate = c2d;
	return self;
}

-(void) display
{
    NSLog(@"Display Annotation : ");
    NSLog(@"Title - %@",self.title);
    NSLog(@"Latitude - %f",self.coordinate.latitude);
    NSLog(@"Longitude - %f",self.coordinate.longitude);
}

- (void)dealloc {
	[title release];
	[super dealloc];
}

@end