//
//  PCAddAlbum.h
//  Persistent Capture
//
//  Created by InternetCowboy | Codin Pangell on 1/29/14.
//  Copyright (c) 2014 InternetCowboy | Codin Pangell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCAddAlbum : UIView

@property (nonatomic, strong) UILabel *albumTitle;
@property (nonatomic, strong) UITextField *albumTitleText;
@property (nonatomic, strong) UIButton  *saveAlbumBtn;
@property (nonatomic, strong) UILabel *photoTitleLbl;
@property (nonatomic, strong) UIView *photoView;
@property (nonatomic, strong) UIView *cameraView;
@property (nonatomic, strong) UILabel *takePhotoIcon;
@property (nonatomic, strong) UIButton  *snapPhoto;

@end
