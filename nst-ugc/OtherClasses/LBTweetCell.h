//
//  LBTweetCell.h
//  twitter
//
//  Created by saifuddin on 13/12/13.
//  Copyright (c) 2013 saifuddin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBTweetCell : UITableViewCell
@property (nonatomic, strong) UIImageView *profileImage, *geoLocImage;
@property (nonatomic, strong) UILabel *lblName, *lblTweet, *lblTime, *lblPlace;
- (void)setLblTimeText:(NSString *)text;
- (void)realignSubviews;
@end
