//
//  UIView+Utilities.m
//  MREPC
//
//  Created by saifuddin on 10/02/13.
//  Copyright (c) 2013 Mohd Zahiruddin. All rights reserved.
//

#import "UIView+Utilities.h"

@implementation UIView (Utilities)
@dynamic x, y, width, height, xEnd, yEnd;

- (CGFloat)x { return self.frame.origin.x; }

- (CGFloat)y { return self.frame.origin.y; }

- (CGFloat)width { return self.frame.size.width; }

- (CGFloat)height { return self.frame.size.height; }

- (CGFloat)xEnd { return self.frame.origin.x + self.frame.size.width; }

- (CGFloat)yEnd { return self.frame.origin.y + self.frame.size.height; }

- (CGFloat)yOffsetCenteredInView:(UIView *)view { return [self yOffsetCenteredInRect:view.frame]; }
- (CGFloat)yOffsetCenteredInRect:(CGRect)rect { return ((rect.size.height / 2) - (self.height / 2)) + rect.origin.y; }

- (CGFloat)xOffsetCenteredInView:(UIView *)view { return [self xOffsetCenteredInRect:view.frame]; }
- (CGFloat)xOffsetCenteredInRect:(CGRect)rect { return ((rect.size.width / 2) - (self.width / 2)) + rect.origin.x; }

- (void)alignCenterInView:(UIView *)view { [self alignCenterInRect:view.frame]; }
- (void)alignCenterInSize:(CGSize)size
{
    [self alignCenterInRect:CGRectSetSize(CGRectZero, size)];
}
- (void)alignCenterInRect:(CGRect)rect {
    self.frame = CGRectMake([self xOffsetCenteredInRect:rect], [self yOffsetCenteredInRect:rect], self.frame.size.width, self.frame.size.height);
}


- (void)alignCenterVerticallyInView:(UIView *)view { [self alignCenterVerticallyInRect:view.frame]; }
- (void)alignCenterVerticallyInSquare:(CGSize)size { [self alignCenterVerticallyInRect:CGRectSetSize(CGRectZero, size)]; }
- (void)alignCenterVerticallyInRect:(CGRect)rect {
    self.frame = CGRectMake(self.frame.origin.x, [self yOffsetCenteredInRect:rect], self.frame.size.width, self.frame.size.height);
}

- (void)alignCenterHorizontallyInView:(UIView *)view { [self alignCenterHorizontallyInRect:view.frame]; }
- (void)alignCenterHorizontallyInSquare:(CGSize)size { [self alignCenterHorizontallyInRect:CGRectSetSize(CGRectZero, size)]; }
- (void)alignCenterHorizontallyInRect:(CGRect)rect {
    self.frame = CGRectMake([self xOffsetCenteredInRect:rect], self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setX:(CGFloat)val { self.frame = CGRectMake(val, self.y, self.width, self.height); }

- (void)setY:(CGFloat)val { self.frame = CGRectMake(self.x, val, self.width, self.height); }

- (void)setWidth:(CGFloat)val { self.frame = CGRectMake(self.x, self.y, val, self.height); }

- (void)setHeight:(CGFloat)val { self.frame = CGRectMake(self.x, self.y, self.width, val); }

- (void)setXEnd:(CGFloat)val { self.frame = CGRectMake(val - self.width, self.y, self.width, self.height); }

- (void)setYEnd:(CGFloat)val { self.frame = CGRectMake(self.x, val - self.height, self.width, self.height); }

- (void)setY:(CGFloat)y yEnd:(CGFloat)yEnd { self.frame = CGRectMake(self.x, y, self.width, yEnd - y); }

- (void)setX:(CGFloat)x xEnd:(CGFloat)xEnd { self.frame = CGRectMake(x, self.y, xEnd - x, self.height); }

// JD: This method is actually identical to convertRect:toView & convertRect:fromView
- (void)addSubview:(UIView *)view virtuallyContainedInRect:(CGRect)rect
{
    CGRect viewFrame = view.frame;
    
    viewFrame.origin.y += (rect.origin.y - self.frame.origin.y);
    viewFrame.origin.x += (rect.origin.x - self.frame.origin.x);
    view.frame = viewFrame;
    
    [self addSubview:view];
}

- (void)alignCenterInSuperview
{
	self.frame = CGRectMake(self.superview.width/2 - self.width/2, self.superview.height/2 - self.height/2, self.width, self.height);
}

@end
