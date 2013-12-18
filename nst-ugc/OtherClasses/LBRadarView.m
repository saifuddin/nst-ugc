//
//  LBRadarView.m
//  twitter
//
//  Created by saifuddin on 14/12/13.
//  Copyright (c) 2013 saifuddin. All rights reserved.
//

#import "LBRadarView.h"
#import "AngleGradientLayer.h"
#import <QuartzCore/QuartzCore.h>

@implementation LBRadarView

+ (Class)layerClass
{
	return [AngleGradientLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
	if (!(self = [super initWithFrame:frame]))
		return nil;
    
    self.layer.cornerRadius = frame.size.width / 2;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];

	AngleGradientLayer *l = (AngleGradientLayer *)self.layer;
	l.colors = [NSArray arrayWithObjects:
                (id)[UIColor colorWithRed:0 green:1 blue:0 alpha:0.5].CGColor,
                (id)[UIColor colorWithRed:0 green:1 blue:0 alpha:0.4].CGColor,
                (id)[UIColor colorWithRed:0 green:1 blue:0 alpha:0.3].CGColor,
                (id)[UIColor colorWithRed:0 green:1 blue:0 alpha:0.2].CGColor,
                (id)[UIColor colorWithRed:0 green:1 blue:0 alpha:0.1].CGColor,
                (id)[UIColor colorWithRed:0 green:1 blue:0 alpha:0].CGColor,
                (id)[UIColor clearColor].CGColor,
                nil];
    
	return self;
}

BOOL animating;

- (void) spinWithOptions: (UIViewAnimationOptions) options {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: 0.45f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         self.transform = CGAffineTransformRotate(self.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (animating) {
                                 // if flag still set, keep spinning with constant speed
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}

- (void) startSpin {
    if (!animating) {
        animating = YES;
        [self spinWithOptions:UIViewAnimationOptionCurveLinear];
    }
}

- (void) stopSpin {
    // set the flag to stop spinning after one last 90 degree increment
    animating = NO;
}

@end
