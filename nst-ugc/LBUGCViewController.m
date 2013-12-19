//
//  LBUGCViewController.m
//  nst-ugc
//
//  Created by saifuddin on 17/12/13.
//  Copyright (c) 2013 saifuddin. All rights reserved.
//

#import "LBUGCViewController.h"
#import "LBTweetCell.h"
#import "STTwitterAPI.h"
#import "LBRadarView.h"
#import "YLActivityIndicatorView.h"
#import "UIImageView+Network.h"
#import "NSDate+Utilities.h"

#define LOADING_TAG 33
#define INDEX_OF_MAP 0
#define INDEX_OF_FIRST_TWEET 1
#define LATITUDE 1
#define LONGITUDE 0

@interface LBUGCViewController ()
{
    CGFloat _mapHeight;
}
@property (nonatomic, strong) UITableView *tweetTV;
@property (nonatomic, strong) NSMutableArray *statuses;
@end

@implementation LBUGCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"#NST";
    [self prepareTweetsTV];
    [self fetchTweets];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _statuses.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    CGFloat nonMapHeight = is4inch ? 126 : 125;
    switch (indexPath.row)
    {
        case 0:
            height = _mapHeight = _tweetTV.height - nonMapHeight - 44 - 20;
            break;
        default:
            height = nonMapHeight;
            break;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;

    if (indexPath.row == 0)
    {
        LBTweetMapCell *tmpCell = [tableView dequeueReusableCellWithIdentifier:kTweetMap];
        
        if (!tmpCell) // First time making
        {
            tmpCell = [[LBTweetMapCell alloc] initWithMapHeight:_mapHeight reuseIdentifier:kTweetMap];
            tmpCell.delegate = self;
        }
        else
        {
            [tmpCell addAnnotationsFromCoordinates:_statuses[0]];
            [tmpCell removeRadar];
        }
        cell = tmpCell;
    }
    else
    {
        LBTweetCell *tmpCell = [tableView dequeueReusableCellWithIdentifier:kTweetStatus];
        
        if (!tmpCell)
        {
            tmpCell = [[LBTweetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTweetStatus];
        }
        
        NSDictionary *status = _statuses[indexPath.row];
        NSString *strCreatedAt = [status valueForKeyPath:@"created_at"];
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingAllTypes error:nil];
        NSTextCheckingResult *result = [detector firstMatchInString:strCreatedAt options:kNilOptions range:NSMakeRange(0, strCreatedAt.length)];
        [tmpCell setLblTimeText:[NSDate relativeStringFromDate:result.date]];
        tmpCell.lblTweet.text = status[@"text"];
        tmpCell.lblName.text = [NSString stringWithFormat:@"@%@",[status valueForKeyPath:@"user.screen_name"]];
        NSString *place = [status valueForKeyPath:@"place.full_name"];
        if (![place isKindOfClass:[NSNull class]])
        {
            tmpCell.lblPlace.text = [status valueForKeyPath:@"place.full_name"];
            tmpCell.geoLocImage.hidden = NO;
        }
        else
        {
            tmpCell.lblPlace.text = @"";
            tmpCell.geoLocImage.hidden = YES;
        }
        [tmpCell.profileImage loadImageFromURL:[NSURL URLWithString:[status valueForKeyPath:@"user.profile_image_url"]] placeholderImage:[UIImage imageNamed:@"twitter.png"]];
//      [cell realignSubviews];
        cell = tmpCell;
    }
    return cell;
}

- (void)didClickedAtAnnotationWithIdentifier:(NSString *)identifier
{
    NSInteger indexOfTweetToShow = [identifier integerValue];
    NSDictionary *status = _statuses[indexOfTweetToShow];
    [_statuses replaceObjectAtIndex:INDEX_OF_FIRST_TWEET withObject:status];
    NSArray *indexToAnimate = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:INDEX_OF_FIRST_TWEET inSection:0]];
    [_tweetTV reloadRowsAtIndexPaths:indexToAnimate withRowAnimation:UITableViewRowAnimationMiddle];
}

- (void)prepareTweetsTV
{
    self.statuses = [NSMutableArray arrayWithObjects:[NSNull null], nil];

    self.tweetTV = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tweetTV.delegate = self;
    _tweetTV.dataSource = self;
    _tweetTV.separatorColor = [UIColor clearColor];
    _tweetTV.rowHeight = 100;
    [self.view addSubview:_tweetTV];
    
    YLActivityIndicatorView *loadingIndicator = [[YLActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.width/2 - 40/2, self.view.height - 70, 40, 15)];
    loadingIndicator.duration = 0.8;
    loadingIndicator.dotCount = 5;
    loadingIndicator.tag = LOADING_TAG;
    [self.view addSubview:loadingIndicator];
    [loadingIndicator startAnimating];
}

- (void)fetchTweets
{
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"U2Q6UYmGc56x1xIJgT0kg"
                                                            consumerSecret:@"OJEIObS5IMRU9fv03vrduELqQJTOFnuzCaMrq7IIhPE"];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        [twitter getSearchTweetsWithQuery:@"thistweetisspecialandshouldnotbetestedatall"
                             successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
                                 NSMutableArray *tmpCoords = [NSMutableArray array];
                                 for (int i = 0; i < statuses.count; i++)
                                 {
                                     NSDictionary *status = statuses[i];
                                     NSArray *coord = [status valueForKeyPath:@"coordinates.coordinates"];
                                     if ([coord isKindOfClass:[NSArray class]])
                                     {
                                         CLLocation *location = [[CLLocation alloc] initWithLatitude:[coord[LATITUDE] doubleValue] longitude:[coord[LONGITUDE] doubleValue]];
                                         NSString *identifier = [NSString stringWithFormat:@"%d",i+1]; // compensate for first item is map, not tweet
                                         NSString *profileImgURL = [status valueForKeyPath:@"user.profile_image_url"];
                                         NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:location, kLocation, identifier, kIdentifier, profileImgURL, kProfileImgURL, nil];
                                         [tmpCoords addObject:dict];
                                     }
                                 }
                                 [_statuses replaceObjectAtIndex:INDEX_OF_MAP withObject:tmpCoords];
                                 [_statuses addObjectsFromArray:statuses];
//                                 [_statuses addObjectsFromArray:statuses];
                                  NSLog(@"%d",_statuses.count);
                                 [self.tweetTV reloadData];
                                 YLActivityIndicatorView *loadingIndicator = (YLActivityIndicatorView *)[self.view viewWithTag:LOADING_TAG];
                                 [loadingIndicator removeFromSuperview];
                             }
                               errorBlock:^(NSError *error){
                                   // ..
                               }];
    } errorBlock:^(NSError *error) {
        // ...
    }];
}

@end
