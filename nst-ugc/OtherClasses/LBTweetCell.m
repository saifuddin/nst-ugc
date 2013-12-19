//
//  LBTweetCell.m
//  twitter
//
//  Created by saifuddin on 13/12/13.
//  Copyright (c) 2013 saifuddin. All rights reserved.
//

#import "LBTweetCell.h"
#import <QuartzCore/QuartzCore.h>

@interface AutosizingLabel : UILabel
{
    double minHeight;
}
@property (nonatomic) double minHeight;
- (void)calculateSize;
@end

#define MIN_HEIGHT 10.0f
#define TEXT_HEIGHT 48.0f

@implementation AutosizingLabel

@synthesize minHeight;

- (id)init {
    if ([super init]) {
        self.minHeight = MIN_HEIGHT;
    }
    return self;
}

- (void)calculateSize
{
    CGSize constraint = CGSizeMake(self.frame.size.width, CGFLOAT_MAX);
    CGSize size = [self.text sizeWithFont:self.font
                        constrainedToSize:constraint
                            lineBreakMode:NSLineBreakByWordWrapping];
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.adjustsFontSizeToFitWidth = NO;
    self.numberOfLines = 0;
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            MAX(size.height, MIN_HEIGHT));
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self calculateSize];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self calculateSize];
}

@end

@interface LBTweetCell ()
@property (nonatomic, strong) UIImageView *bubbleTop, *bubbleArrow, *bubbleBottom, *bubbleLeft, *bubbleRight, *clockImage;
@end

@implementation LBTweetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        self.contentView.backgroundColor = [UIColor clearColor];

        self.profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(18, 15, 42, 42)];
        _profileImage.layer.cornerRadius = _profileImage.width / 2;
        _profileImage.layer.masksToBounds = YES;
        _profileImage.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:_profileImage];

        self.lblName = [[UILabel alloc] initWithFrame:CGRectMake(72, 0, self.contentView.width - 72, 20)];
        _lblName.backgroundColor = [UIColor clearColor];
        _lblName.text = @"@suprdeen";
        _lblName.font = [UIFont boldSystemFontOfSize:12.5];
        [self.contentView addSubview:_lblName];

        self.bubbleTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_top"]];
        _bubbleTop.frame = CGRectMake(_lblName.x, _lblName.yEnd, 230, 10);
        [self.contentView addSubview:_bubbleTop];

        self.bubbleArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_arrow"]];
        _bubbleArrow.frame = CGRectMake(_profileImage.xEnd + 4, _bubbleTop.yEnd, 18, 9);
        [self.contentView addSubview:_bubbleArrow];
        
        self.bubbleLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_left"]];
        _bubbleLeft.frame = CGRectMake(_bubbleTop.x, _bubbleArrow.yEnd, 10, TEXT_HEIGHT);
        [self.contentView addSubview:_bubbleLeft];
        
        self.bubbleRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_right"]];
        _bubbleRight.frame = CGRectMake(_bubbleTop.xEnd - 10, _bubbleTop.yEnd, 10, TEXT_HEIGHT + _bubbleArrow.height);
        [self.contentView addSubview:_bubbleRight];
        
        self.bubbleBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_bottom"]];
        _bubbleBottom.frame = CGRectMake(_bubbleLeft.x, _bubbleRight.yEnd, _bubbleTop.width, 10);
        [self.contentView addSubview:_bubbleBottom];
        
        UIView *bgTweet = [[UIView alloc] initWithFrame:CGRectMake(_bubbleArrow.xEnd, _bubbleTop.yEnd, _bubbleTop.width - _bubbleRight.width*2, _bubbleRight.height)];
        bgTweet.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:143.0/255.0 blue:0 alpha:1];
        [self.contentView addSubview:bgTweet];

        self.lblTweet = [[AutosizingLabel alloc] initWithFrame:bgTweet.frame];
        _lblTweet.backgroundColor = bgTweet.backgroundColor;
        _lblTweet.font = [UIFont boldSystemFontOfSize:12];
        _lblTweet.textColor = [UIColor whiteColor];
        _lblTweet.text = @"This is a tweet from #NST that will be displayed in the app as a UGC content and will collected blah blah.";
        
        UIView *viewThatObscuresStupidLineOnTopOfLblTweet = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _lblTweet.width, 2)];
        viewThatObscuresStupidLineOnTopOfLblTweet.backgroundColor = bgTweet.backgroundColor;
        [_lblTweet addSubview:viewThatObscuresStupidLineOnTopOfLblTweet];

        [self.contentView addSubview:_lblTweet];
        
        self.lblTime = [[UILabel alloc] initWithFrame:CGRectMake(_bubbleRight.xEnd - 35, _lblName.y, 35, _lblName.height)];
        _lblTime.textColor = [UIColor grayColor];
        _lblTime.textAlignment = NSTextAlignmentRight;
        _lblTime.font = [UIFont italicSystemFontOfSize:12];
        _lblTime.text = @"15:07";
        _lblTime.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_lblTime];
        
        self.clockImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-time"]];
        _clockImage.frame = CGRectMake(_lblTime.x - 11, 5, 11, 11);
        [self.contentView addSubview:_clockImage];
        
        self.geoLocImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-geoloc"]];
        _geoLocImage.frame = CGRectMake(_bubbleLeft.x, _bubbleBottom.yEnd, 29, 26);
        _geoLocImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_geoLocImage];
        
        self.lblPlace = [[UILabel alloc] initWithFrame:CGRectMake(_geoLocImage.xEnd, _geoLocImage.y, self.contentView.width - (_geoLocImage.xEnd + 8 + _bubbleRight.width), _geoLocImage.height)];
        _lblPlace.text = @"Perth, Western Australia";
        _lblPlace.font = [UIFont italicSystemFontOfSize:12];
        _lblPlace.textColor = [UIColor grayColor];
        _lblPlace.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_lblPlace];
    }
    return self;
}

- (void)setLblTimeText:(NSString *)text
{
    CGSize constraint = CGSizeMake(150, _lblTime.height);
    CGSize size = [text sizeWithFont:_lblTime.font
                        constrainedToSize:constraint
                            lineBreakMode:_lblTime.lineBreakMode];
    _lblTime.frame = CGRectMake(_bubbleRight.xEnd - size.width, _lblTime.y, size.width, _lblTime.height);
    _lblTime.text = text;
    _clockImage.frame = CGRectMake(_lblTime.x - _clockImage.width - 5, _clockImage.y, _clockImage.width, _clockImage.height);
}

- (void)realignSubviews
{
    
}

@end
