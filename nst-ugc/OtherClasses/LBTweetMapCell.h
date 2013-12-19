//
//  LBTweetMapCell.h
//  nst-ugc
//
//  Created by saifuddin on 17/12/13.
//  Copyright (c) 2013 saifuddin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

static NSString * const kTweetStatus = @"kTweetStatus";
static NSString * const kTweetMap = @"kTweetMap";
static NSString * const kLocation = @"kLocation";
static NSString * const kIdentifier = @"kIdentifier";
static NSString * const kProfileImgURL = @"kProfileImgURL";


@protocol LBTweetMapCellDelegate <NSObject>
@optional
- (void)didClickedAtAnnotationWithIdentifier:(NSString *)identifier;
@end

@interface LBTweetMapCell : UITableViewCell <MKMapViewDelegate>
- (id)initWithMapHeight:(CGFloat)height reuseIdentifier:(NSString *)reuseIdentifier;
- (void)addAnnotationsFromCoordinates:(NSArray *)coordinates;
- (void)removeRadar;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, weak) id<LBTweetMapCellDelegate> delegate;
@property BOOL annotationsAdded;
@end
