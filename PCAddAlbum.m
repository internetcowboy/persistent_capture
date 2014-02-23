//
//  PCAddAlbum.m
//  Persistent Capture
//
//  Created by InternetCowboy | Codin Pangell on 1/29/14.
//  Copyright (c) 2014 InternetCowboy | Codin Pangell. All rights reserved.
//

#import "PCAddAlbum.h"
#import "UIComponentsClass.h"

@implementation PCAddAlbum{
    UIComponentsClass * uicore;
}

static NSString * const kFontName = @"HelveticaNeue-Bold";
static NSString * const kFontNameMed = @"HelveticaNeue-Medium";
static float kFontSize = 13.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"Add Album View...");
        self.backgroundColor = UIColorFromRGB(0x096060);
        uicore = [UIComponentsClass new];
        
        [self addSubview:self.albumTitle];
        [self addSubview:self.photoTitleLbl];
        [self addSubview:self.albumTitleText];
        [self addSubview:self.saveAlbumBtn];
        [self addSubview:self.photoView];
        [self addSubview:self.takePhotoIcon];
        
        //camera view
        [self.cameraView addSubview:self.snapPhoto];
        [self addSubview:self.cameraView];
        
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
    self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    self.cameraView.frame = self.frame;
}


- (UILabel *)albumTitle {
    
    if (!_albumTitle) {
        _albumTitle = [uicore newCustomFontLabel:@"Add a Title" y:0 x:0 w:0 h:0 fontName:kFontNameMed fontSize:kFontSize];
        _albumTitle.textColor = [UIColor whiteColor];
        _albumTitle.frame = CGRectMake(20, 20, self.frame.size.width, self.albumTitle.frame.size.height);
    }
    
    return _albumTitle;
}


- (UILabel *)photoTitleLbl {
    
    if (!_photoTitleLbl) {
        _photoTitleLbl = [uicore newCustomFontLabel:@"Add a Album Cover" y:0 x:0 w:0 h:0 fontName:kFontNameMed fontSize:kFontSize];
        _photoTitleLbl.textColor = [UIColor whiteColor];
        _photoTitleLbl.frame = CGRectMake(20, 90, self.frame.size.width, 30);
    }
    
    return _photoTitleLbl;
}

- (UITextField *)albumTitleText {
    if (!_albumTitleText) {
        _albumTitleText = [uicore newField: @" " y:40 x:20 w:self.frame.size.width-40 h:30];
    }
    
    return _albumTitleText;
}

- (UIButton *)saveAlbumBtn {
    if (!_saveAlbumBtn) {
        _saveAlbumBtn = [uicore newButton:@"SAVE ALBUM" y:20 x:(self.frame.size.height-150) w:100 h:30 color:[UIColor blackColor]];
    }
    
    return _saveAlbumBtn;
}

- (UIView *)photoView {
    if (!_photoView) {
        _photoView = [[UIView alloc] initWithFrame:self.frame];
        _photoView.frame = CGRectMake(20, 115, (self.frame.size.width / 2), (self.frame.size.width / 2));
        _photoView.backgroundColor = [UIColor grayColor];
    }
    
    return _photoView;
}

- (UILabel *)takePhotoIcon {
    if (!_takePhotoIcon) {
        _takePhotoIcon = [uicore newCustomFontLabel:@"D" y:0 x:0 w:0 h:0 fontName:@"Untitled-Regular" fontSize:60.0f];
        _takePhotoIcon.backgroundColor = [UIColor clearColor];
        _takePhotoIcon.frame = CGRectMake((self.frame.size.width / 2) + 60, 155, 80, 80);
        
    }
    
    return _takePhotoIcon;
}

- (UIView *)cameraView {
    if (!_cameraView) {
        _cameraView = [[UIView alloc] initWithFrame:self.frame];
        _cameraView.backgroundColor = [UIColor blackColor];
    }
    
    return _cameraView;
}

- (UIButton *)snapPhoto {
    if (!_snapPhoto) {
        _snapPhoto = [uicore newButton:@"SNAP PHOTO" y:(self.frame.size.width / 2) - 50 x:20 w:100 h:30 color:UIColorFromRGB(0x096060)];
    }
    
    return _snapPhoto;
}

@end
