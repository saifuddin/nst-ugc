//
//  UIView+Utilities.h
//  MREPC
//
//  Created by saifuddin on 10/02/13.
//  Copyright (c) 2013 Mohd Zahiruddin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (Utilities)
@property (nonatomic, assign) CGFloat x, y, width, height, xEnd, yEnd;

- (CGFloat)yOffsetCenteredInView:(UIView *)view;
- (CGFloat)yOffsetCenteredInRect:(CGRect)rect;

- (CGFloat)xOffsetCenteredInView:(UIView *)view;
- (CGFloat)xOffsetCenteredInRect:(CGRect)rect;

- (void)alignCenterInView:(UIView *)view;
- (void)alignCenterInSize:(CGSize)size;
- (void)alignCenterInRect:(CGRect)rect;
- (void)alignCenterInSuperview;

- (void)alignCenterVerticallyInView:(UIView *)view;
- (void)alignCenterVerticallyInRect:(CGRect)rect;
- (void)alignCenterVerticallyInSquare:(CGSize)size;

- (void)alignCenterHorizontallyInView:(UIView *)view;
- (void)alignCenterHorizontallyInRect:(CGRect)rect;
- (void)alignCenterHorizontallyInSquare:(CGSize)size;

- (void)setY:(CGFloat)y yEnd:(CGFloat)yEnd;
- (void)setX:(CGFloat)x xEnd:(CGFloat)xEnd;

- (void)addSubview:(UIView *)view virtuallyContainedInRect:(CGRect)rect;

@end
