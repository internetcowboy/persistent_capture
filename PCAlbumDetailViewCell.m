//
//  PCAlbumDetailViewCell.m
//  Persistent Capture
//
//  Created by InternetCowboy | Codin Pangell on 2/3/14.
//  Copyright (c) 2014 InternetCowboy | Codin Pangell. All rights reserved.
//

#import "PCAlbumDetailViewCell.h"
#import "UIComponentsClass.h"

@implementation PCAlbumDetailViewCell {
    UIComponentsClass * uicore;
}


//constants
static NSString * const kFontName = @"HelveticaNeue-Bold";
static float kFontSize = 12.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        uicore = [UIComponentsClass new];
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.dayTitle];
        [self addSubview:self.albumSubTitle];
        [self addSubview:self.recorderIcon];
        
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
}



- (UILabel *)dayTitle {
    
    if (!_dayTitle) {
        _dayTitle = [uicore newCustomFontLabel:@" " y:0 x:0 w:0 h:0 fontName:kFontName fontSize:(kFontSize+5)];
        _dayTitle.textColor = [UIColor whiteColor];
    }
    
    return _dayTitle;
}

- (UILabel *)albumSubTitle {
    
    if (!_albumSubTitle) {
        _albumSubTitle = [uicore newCustomFontLabel:@" " y:0 x:0 w:0 h:0 fontName:kFontName fontSize:kFontSize];
        _albumSubTitle.textColor = [UIColor whiteColor];
    }
    
    return _albumSubTitle;
}


- (UIImageView *)recorderIcon {
    if (!_recorderIcon) {
        _recorderIcon = [[UIImageView alloc] initWithFrame:self.frame];
        _recorderIcon.backgroundColor = [UIColor clearColor];
        _recorderIcon.frame = CGRectMake( 20 , 20, 45, 30);
    }
    
    return _recorderIcon;
}


@end
