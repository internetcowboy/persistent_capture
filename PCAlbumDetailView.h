//
//  PCAlbumDetailView.h
//  Persistent Capture
//
//  Created by InternetCowboy | Codin Pangell on 2/3/14.
//  Copyright (c) 2014 InternetCowboy | Codin Pangell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCAlbumDetailView;
@protocol PCAlbumDetailViewDelegate <NSObject>
@required
- (void)detailView:(PCAlbumDetailView *)dayView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface PCAlbumDetailView : UIView <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *albumTitle;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) id<PCAlbumDetailViewDelegate> delegate;

@property NSDictionary *weekInfo;
@end
