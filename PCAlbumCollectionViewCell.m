//
//  PCAlbumCollectionViewCell.m
//  Persistent Capture
//
//  Created by InternetCowboy | Codin Pangell on 1/30/14.
//  Copyright (c) 2014 InternetCowboy | Codin Pangell. All rights reserved.
//

#import "PCAlbumCollectionViewCell.h"
#import "UIComponentsClass.h"

@implementation PCAlbumCollectionViewCell{
    UIComponentsClass * uicore;
}

//constants
static NSString * const kFontName = @"HelveticaNeue-Bold";
static float kFontSize = 10.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        uicore = [UIComponentsClass new];
        self.backgroundColor = [UIColor clearColor];
        
        [self.infoView addSubview:self.albumTitle];
        [self.infoView addSubview:self.lastUpdatedTitle];
        [self.infoView addSubview:self.numberOfDaysTitle];
        [self.infoView addSubview:self.openBtn];
        [self.infoView addSubview:self.coverImageView];
        [self.infoView addSubview:self.closeDetailLbl];
        
        
        
        [self addSubview:self.infoView];
        [self addSubview:self.thumbnail];
        
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
    self.infoView.backgroundColor = [UIColor clearColor];
}


#pragma mark - Subviews

- (UIButton *)openBtn {
    if (!_openBtn) {
        _openBtn = [uicore newButton:@"OPEN ALBUM" y:(self.infoView.frame.size.width - 130) x:15 w:100 h:30 color:[UIColor blackColor]];
    }
    
    return _openBtn;
}

- (UILabel *)albumTitle {
    
    if (!_albumTitle) {
        _albumTitle = [uicore newCustomFontLabel:@" " y:0 x:0 w:0 h:0 fontName:kFontName fontSize:(kFontSize+5)];
        _albumTitle.textColor = [UIColor whiteColor];
    }
    
    return _albumTitle;
}

- (UILabel *)lastUpdatedTitle {
    
    if (!_lastUpdatedTitle) {
        _lastUpdatedTitle = [uicore newCustomFontLabel:@" " y:0 x:0 w:0 h:0 fontName:kFontName fontSize:kFontSize];
        _lastUpdatedTitle.textColor = [UIColor whiteColor];
    }
    
    return _lastUpdatedTitle;
}

- (UILabel *)numberOfDaysTitle {
    
    if (!_numberOfDaysTitle) {
        _numberOfDaysTitle = [uicore newCustomFontLabel:@" " y:0 x:0 w:0 h:0 fontName:kFontName fontSize:kFontSize];
        _numberOfDaysTitle.textColor = [UIColor whiteColor];
    }
    
    return _numberOfDaysTitle;
}

- (UIImageView *)thumbnail {
    
    if (!_thumbnail) {
        _thumbnail = [UIImageView new];
    }
    
    return _thumbnail;
}

- (UIView *)infoView {
    if (!_infoView) {
        _infoView = [[UIView alloc] initWithFrame:self.bounds];
    }
    
    return _infoView;
}


- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] initWithFrame:self.frame];
        _coverImageView.backgroundColor = [UIColor blackColor];
        _coverImageView.frame = CGRectMake((self.infoView.frame.size.width*2), 0, (self.frame.size.width / 4), (self.frame.size.width / 4));
    }
    
    return _coverImageView;
}


- (UILabel *)closeDetailLbl {
    if (!_closeDetailLbl) {
        _closeDetailLbl = [uicore newCustomFontLabel:@"B" y:0 x:0 w:0 h:0 fontName:@"Untitled-Regular" fontSize:24.0f];
        _closeDetailLbl.backgroundColor = [UIColor clearColor];
        _closeDetailLbl.frame = CGRectMake((self.frame.size.width-55), 0, 40, 40);
        [_closeDetailLbl setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90))]; //yeah I know. It is an X that I turned into a + because I didn't want to render out a font.
        _closeDetailLbl.hidden = YES;
    }
    
    return _closeDetailLbl;
}


@end
