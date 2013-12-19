//
//  UIImageView+Network.h
//  MREPC
//
//  Created by Mohd Zahiruddin on 2/6/13.
//  Copyright (c) 2013 Mohd Zahiruddin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Network)
- (void) loadImageFromURL:(NSURL*)url placeholderImage:(UIImage*)placeholder;
- (void) setImageURL:(NSURL *)newImageURL;
- (NSURL*) imageURL;
@end
