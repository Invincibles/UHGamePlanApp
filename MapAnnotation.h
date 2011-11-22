//
//  MapAnnotation.h
//  MultipleDetailViews
//
//  Created by Kowshik Gurram on 10/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation> {
    
	NSString *title;
	CLLocationCoordinate2D coordinate;
    
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d;
- (void) display;


@end
