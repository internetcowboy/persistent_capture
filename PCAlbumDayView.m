//
//  PCAlbumDayView.m
//  Persistent Capture
//
//  Created by InternetCowboy | Codin Pangell on 2/18/14.
//  Copyright (c) 2014 InternetCowboy | Codin Pangell. All rights reserved.
//

#import "PCAlbumDayView.h"
#import "UIComponentsClass.h"
#import <AVFoundation/AVFoundation.h>

@implementation PCAlbumDayView{
    UIComponentsClass * uicore;
    int cellWidth;
    int cellHeight;
    NSArray* daysOfTheWeek;
    
}

//constants
static NSString * const kFontName = @"HelveticaNeue-Bold";
static NSString * const kFontNameMed = @"HelveticaNeue-Medium";
static float kFontSize = 16.0f;
static float kDirectionsFontSize = 10.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"Album Day View...");
        self.backgroundColor = UIColorFromRGB(0x074040);
        uicore = [UIComponentsClass new];
        
        [self addSubview:self.dayTitle];
        [self addSubview:self.directionsTitle];
        [self addSubview:self.thumbnailView];
        [self addSubview:self.closeIcon];
        [self addSubview:self.showVideo];
        
        [self.videoViewWrapper addSubview:self.videoView];
        [self.videoViewWrapper addSubview:self.recorderIcon];
        [self.videoViewWrapper addSubview:self.closeVideoIcon];
        
        [self addSubview:self.videoViewWrapper];
        
    }
    return self;
}


- (void)layoutSubviews {
	[super layoutSubviews];
    self.frame = CGRectMake(-self.frame.size.height, 0, self.frame.size.width, self.frame.size.height);
    self.videoView.frame = self.frame;
    self.videoViewWrapper.frame = self.frame;
}



- (UILabel *)dayTitle {
    
    if (!_dayTitle) {
        _dayTitle = [uicore newCustomFontLabel:@"thisissampletext" y:0 x:0 w:0 h:0 fontName:kFontName fontSize:kFontSize];
        _dayTitle.textColor = [UIColor whiteColor];
        _dayTitle.frame = CGRectMake(25, 60, self.frame.size.width, 20);
    }
    
    return _dayTitle;
}

- (UITextView *)directionsTitle {
    
    if (!_directionsTitle) {
        _directionsTitle = [UITextView new];
        _directionsTitle.scrollEnabled = NO;
        _directionsTitle.textColor = [UIColor whiteColor];
        _directionsTitle.backgroundColor = [UIColor clearColor];
        _directionsTitle.font = [UIFont fontWithName:kFontNameMed size:kDirectionsFontSize];
        _directionsTitle.frame = CGRectMake(0, 100,  self.frame.size.width, 200);
        _directionsTitle.text = @"thisissomereallylongtextbecausetextviewsarebullshitthisissomereallylongtextbecausetextviewsarebullshitthisissomereallylongtextbecausetextviewsarebullshitthisissomereallylongtextbecausetextviewsarebullshit";
        _directionsTitle.textAlignment = NSTextAlignmentCenter;
        [_directionsTitle sizeToFit];
    }
    
    return _directionsTitle;
}

- (UIImageView *)thumbnailView {
    if (!_thumbnailView) {
        _thumbnailView = [[UIImageView alloc] initWithFrame:self.frame];
        _thumbnailView.backgroundColor = [UIColor grayColor];
        _thumbnailView.frame = CGRectMake((self.frame.size.width / 4), 170, (self.frame.size.width / 2), (self.frame.size.width / 2));
    }
    
    return _thumbnailView;
}

- (UIButton *)showVideo {
    if (!_showVideo) {
        _showVideo = [uicore newButton:@"SHOW VIDEO" y:(self.frame.size.width / 2) - 50 x:350 w:100 h:30 color:[UIColor blackColor]];
        _showVideo.hidden = YES;
    }
    
    return _showVideo;
}

- (UILabel *)closeIcon {
    if (!_closeIcon) {
        _closeIcon = [uicore newCustomFontLabel:@"B" y:0 x:0 w:0 h:0 fontName:@"Untitled-Regular" fontSize:24.0f];
        _closeIcon.backgroundColor = [UIColor clearColor];
        _closeIcon.frame = CGRectMake((self.frame.size.width-55), 50, 40, 40);
    }
    
    return _closeIcon;
}

- (UILabel *)closeVideoIcon {
    if (!_closeVideoIcon) {
        _closeVideoIcon = [uicore newCustomFontLabel:@"B" y:0 x:0 w:0 h:0 fontName:@"Untitled-Regular" fontSize:24.0f];
        _closeVideoIcon.backgroundColor = [UIColor whiteColor];
        _closeVideoIcon.frame = CGRectMake(20, 20, 23, 23);
    }
    
    return _closeVideoIcon;
}

- (UIView *)videoView {
    if (!_videoView) {
        _videoView = [[UIView alloc] initWithFrame:self.frame];
        _videoView.backgroundColor = [UIColor blackColor];
    }
    
    return _videoView;
}


- (UIView *)videoViewWrapper {
    if (!_videoViewWrapper) {
        _videoViewWrapper = [[UIView alloc] initWithFrame:self.frame];
        _videoViewWrapper.backgroundColor = [UIColor clearColor];
        _videoViewWrapper.hidden = YES;
    }
    
    return _videoViewWrapper;
}

- (UIImageView *)recorderIcon {
    if (!_recorderIcon) {
        _recorderIcon = [[UIImageView alloc] initWithFrame:self.frame];
        _recorderIcon.backgroundColor = [UIColor clearColor];
        _recorderIcon.frame = CGRectMake( ((self.frame.size.width / 2) - (63/2)) , (self.frame.size.height - 100), 63, 62);
    }
    
    return _recorderIcon;
}


@end
