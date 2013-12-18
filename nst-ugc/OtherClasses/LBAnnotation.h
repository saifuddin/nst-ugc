//
//  LBAnnotation.h
//  map-annotations
//
//  Created by saifuddin on 17/12/13.
//  Copyright (c) 2013 saifuddin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LBAnnotation : NSObject <MKAnnotation>
@property (nonatomic, strong) NSString *name, *description, *identifier;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
-(id)initWithCoordinate:(CLLocationCoordinate2D)coord;
@end
