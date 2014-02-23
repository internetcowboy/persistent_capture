//
//  PCAlbumCollectionViewCell.h
//  Persistent Capture
//
//  Created by InternetCowboy | Codin Pangell on 1/30/14.
//  Copyright (c) 2014 InternetCowboy | Codin Pangell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCAlbumCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *albumTitle;
@property (nonatomic, strong) UILabel *lastUpdatedTitle;
@property (nonatomic, strong) UILabel *numberOfDaysTitle;

@property (nonatomic, strong) UIImageView *thumbnail;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UIButton  *openBtn;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *closeDetailLbl;

@end
