//
//  PCAlbumDayView.h
//  Persistent Capture
//
//  Created by InternetCowboy | Codin Pangell on 2/18/14.
//  Copyright (c) 2014 InternetCowboy | Codin Pangell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCAlbumDayView : UIView

@property (nonatomic, strong) UILabel *closeIcon;
@property (nonatomic, strong) UILabel *dayTitle;
@property (nonatomic, strong) UITextView *directionsTitle;
@property (nonatomic, strong) UIImageView *thumbnailView;

@property (nonatomic, strong) UIView *videoViewWrapper;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIImageView *recorderIcon;
@property (nonatomic, strong) UILabel *closeVideoIcon;
@property (nonatomic, strong) UIButton  *showVideo;


@end
