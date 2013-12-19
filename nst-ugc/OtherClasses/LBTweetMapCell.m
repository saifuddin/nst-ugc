//
//  LBTweetMapCell.m
//  nst-ugc
//
//  Created by saifuddin on 17/12/13.
//  Copyright (c) 2013 saifuddin. All rights reserved.
//

#import "LBTweetMapCell.h"
#import "LBAnnotation.h"
#import "LBRadarView.h"
#import "UIImageView+Network.h"

#define ICON_WIDTH 35

@interface LBTweetMapCell ()
@property (nonatomic, strong) NSArray *tweetAnnotations;
@property (nonatomic, strong) UIButton *btnZoom;
@property (nonatomic, strong) LBRadarView *radar;
@end

@implementation LBTweetMapCell

@synthesize delegate;

- (id)initWithMapHeight:(CGFloat)height reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.width, height)];
        _mapView.delegate = self;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(3.255929, 101.674193), 500000, 500000);
        [self.mapView setRegion:region animated:YES];
        [self.contentView addSubview:_mapView];
        
        self.btnZoom = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_btnZoom setTitle:@"Show All" forState:UIControlStateNormal];
        [_btnZoom addTarget:self action:@selector(zoomToAllAnnotations) forControlEvents:UIControlEventTouchUpInside];
        _btnZoom.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        _btnZoom.titleLabel.textColor = [UIColor blueColor];
        _btnZoom.backgroundColor = [UIColor whiteColor];
        _btnZoom.frame = CGRectMake(self.width - 70 - 20, 20, 70, 30);
        _btnZoom.hidden = YES;
        [self.contentView addSubview:_btnZoom];

        CGFloat radarHeight = sqrt(pow(_mapView.height, 2)*2) + 50;
        self.radar = [[LBRadarView alloc] initWithFrame:CGRectMake(self.width/2 - radarHeight/2, _mapView.height/2 - radarHeight/2, radarHeight, radarHeight)];
        [self.contentView addSubview:_radar];
        [_radar startSpin];
    }
    return self;
}

- (void)addAnnotationsFromCoordinates:(NSArray *)coordinates
{
    if (![coordinates isKindOfClass:[NSNull class]])
    {
        // After fetching from twitter, coordinates contains array of dictionaries
        // with keys kLocation and kIdentifier
        for (NSDictionary *coordinate in coordinates)
        {
            CLLocation *location = coordinate[kLocation];
            NSString *identifier = coordinate[kIdentifier];
            NSString *profileImgURL = coordinate[kProfileImgURL];
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
            LBAnnotation *ann = [[LBAnnotation alloc] initWithCoordinate:coord];
            ann.identifier = identifier;
            ann.profileImgURL = profileImgURL;
            [self.mapView addAnnotation:ann];
        }
        self.btnZoom.hidden = NO;
    }
    if (!_annotationsAdded)
    {
        [self zoomToAllAnnotations];
        self.annotationsAdded = YES;
    }
}



- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(LBAnnotation *)annotation
{
    MKAnnotationView *annView = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier: @"pin"];
    if (annView == nil)
    {
        annView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:@"pin"];
        
        annView.frame = CGRectMake(0, 0, ICON_WIDTH, ICON_WIDTH);
        annView.layer.cornerRadius = annView.width / 2;
        annView.layer.masksToBounds = YES;
        
        UIButton *pinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [pinButton setImage:[UIImage imageNamed:@"icon-#nst"] forState:UIControlStateNormal];
        pinButton.frame = CGRectMake(0, 0, ICON_WIDTH, ICON_WIDTH);
        pinButton.tag = 10;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(didClickedAtAnnotation:)];
        tap.numberOfTapsRequired = 1;
        [pinButton addGestureRecognizer:tap];
        
        [annView addSubview:pinButton];
    }
    
    annView.annotation = annotation;
    
    return annView;
}

- (void)zoomToAllAnnotations
{
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in _mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    
    // padding
    double inset = -zoomRect.size.width * 0.1;
    
    [self.mapView setVisibleMapRect:MKMapRectInset(zoomRect, inset, inset) animated:YES];
}

- (void)didClickedAtAnnotation:(UIGestureRecognizer *)gestureRecognizer
{
    UIButton *btn = (UIButton *)gestureRecognizer.view;
    MKAnnotationView *av = (MKAnnotationView *)btn.superview;
    LBAnnotation *ann = av.annotation;
    
    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ICON_WIDTH, ICON_WIDTH)];
    [v loadImageFromURL:[NSURL URLWithString:ann.profileImgURL] placeholderImage:[UIImage imageNamed:@"twitter.png"]];

    [UIView transitionFromView:btn
                        toView:v
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionCurveEaseInOut
                    completion:nil];

    if ([delegate respondsToSelector:@selector(didClickedAtAnnotationWithIdentifier:)])
    {
        [delegate didClickedAtAnnotationWithIdentifier:ann.identifier];
    }
}

- (void)removeRadar
{
    [UIView animateWithDuration:0.4
                     animations:^{
                         _radar.alpha = 0;
                     }
                     completion:^(BOOL f) {
                         self.btnZoom.hidden = NO;
                         [_radar removeFromSuperview];
                     }];
}

@end
