//
//  LBAnnotation.m
//  map-annotations
//
//  Created by saifuddin on 17/12/13.
//  Copyright (c) 2013 saifuddin. All rights reserved.
//

#import "LBAnnotation.h"

@implementation LBAnnotation

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord
{
    self=[super init];
    if(self){
        _coordinate = coord;
    }
    return self;
}

@end
