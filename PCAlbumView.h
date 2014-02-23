//
//  PCAlbumView.h
//  Persistent Capture
//
//  Created by InternetCowboy | Codin Pangell on 1/29/14.
//  Copyright (c) 2014 InternetCowboy | Codin Pangell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCAlbumView;
@protocol PCAlbumViewDelegate <NSObject>
@required
- (void)albumView:(PCAlbumView *)albumView didSelectButton:(UIButton *)button;

@end


@interface PCAlbumView : UIView <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *infoTitle;
@property (nonatomic, strong) UILabel *addIcon;
@property (nonatomic, strong) UICollectionView *collectionView;



@property (nonatomic, weak) id<PCAlbumViewDelegate> delegate;

@property NSArray *albums;

-(void)initAlbums;

@end
