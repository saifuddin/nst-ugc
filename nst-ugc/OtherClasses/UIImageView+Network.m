//
//  UIImageView+Network.m
//  MREPC
//
//  Created by Mohd Zahiruddin on 2/6/13.
//  Copyright (c) 2013 Mohd Zahiruddin. All rights reserved.
//

// http://khanlou.com/2012/08/asynchronous-downloaded-images-with-caching/

#import "UIImageView+Network.h"

#import "NSString+Hash.h"
#import "FTWCache.h"
#import <objc/runtime.h>

static char URL_KEY;

@implementation UIImageView (Network)

- (void) loadImageFromURL:(NSURL*)url placeholderImage:(UIImage*)placeholder
{
	self.imageURL = url;
	self.image = placeholder;
    NSString *key = [url.absoluteString md5];

	dispatch_queue_t queue = dispatch_queue_create("com.ar.nst.bgqueue", NULL);; //dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
	dispatch_async(queue, ^{
		NSData *data = [NSData dataWithContentsOfURL:url];

		UIImage *imageFromData = [UIImage imageWithData:data];

		[FTWCache setObject:UIImagePNGRepresentation(imageFromData) forKey:key];
		UIImage *imageToSet = imageFromData;
		if (imageToSet) {
			if ([self.imageURL.absoluteString isEqualToString:url.absoluteString]) {
				dispatch_async(dispatch_get_main_queue(), ^{
					self.image = imageFromData;
				});
			}
		}
		self.imageURL = nil;
	});
}

- (void) setImageURL:(NSURL *)newImageURL {
	objc_setAssociatedObject(self, &URL_KEY, newImageURL, OBJC_ASSOCIATION_COPY);
}

- (NSURL*) imageURL {
	return objc_getAssociatedObject(self, &URL_KEY);
}

@end
