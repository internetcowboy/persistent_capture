//
//  PCAlbumDetailView.m
//  Persistent Capture
//
//  Created by InternetCowboy | Codin Pangell on 2/3/14.
//  Copyright (c) 2014 InternetCowboy | Codin Pangell. All rights reserved.
//

#import "PCAlbumDetailView.h"
#import "UIComponentsClass.h"
#import "PCAlbumDetailViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PCAlbumDetailView{
    UIComponentsClass * uicore;
    int cellWidth;
    int cellHeight;
    NSArray* daysOfTheWeek;
}

static NSString * const kFontName = @"HelveticaNeue-Bold";
static NSString * const kFontNameMed = @"HelveticaNeue-Medium";
static float kFontSize = 13.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"Album Detail View...");
        self.backgroundColor = [UIColor clearColor];
        uicore = [UIComponentsClass new];
        
        [self addSubview:self.albumTitle];
        [self addSubview:self.coverView];
        
        daysOfTheWeek = [NSArray arrayWithObjects: @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday", nil];
        
        //create collection view layout
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 2.0f;
        layout.minimumInteritemSpacing = 0.0f;
        
        //create collectionview
        self.collectionView=[[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        self.collectionView.dataSource = self;
        [self.collectionView setDelegate:self];
        [self.collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        self.collectionView.pagingEnabled = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.collectionView registerClass:[PCAlbumDetailViewCell class] forCellWithReuseIdentifier:@"dayCell"];
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.collectionView];
        
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
    self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    self.coverView.frame = self.frame;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Inside detail view, try to forward action");
    
    //forward delegate to view controller
    [self.delegate detailView: self didSelectItemAtIndexPath:indexPath];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    cellWidth = self.frame.size.width;
    
    float h = self.frame.size.height;
    h = h - 140;
    cellHeight = h / 7;
    return CGSizeMake( cellWidth, cellHeight);
}


- (PCAlbumDetailViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PCAlbumDetailViewCell *cell = (PCAlbumDetailViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"dayCell" forIndexPath:indexPath];
    int ind = indexPath.item;
   
    NSArray *dayInformation = [self.weekInfo valueForKey:daysOfTheWeek[ind]];
    
    //title
    cell.dayTitle.text = [daysOfTheWeek[ind] uppercaseString];
    cell.dayTitle.frame = CGRectMake(0, 0, cellWidth, cellHeight);
    cell.dayTitle.textAlignment = NSTextAlignmentCenter;
    
    //subtitle
    cell.albumSubTitle.text = [dayInformation[0] uppercaseString];
    cell.albumSubTitle.frame = CGRectMake(0, 15, cellWidth, cellHeight);
    cell.albumSubTitle.textAlignment = NSTextAlignmentCenter;
    
    //set video camera icon
    if ([dayInformation[2] isEqualToString:@"true"]) {
        cell.recorderIcon.image = [UIImage imageNamed:@"videocamera.png"];
        NSLog(@"setimage");
    } else {
        cell.recorderIcon.image = [UIImage new];
    }
    
    cell.backgroundColor = UIColorFromRGB(0x096060);

    return cell;
}

- (UILabel *)albumTitle {
    
    if (!_albumTitle) {
        _albumTitle = [uicore newCustomFontLabel:@" " y:0 x:0 w:0 h:0 fontName:kFontNameMed fontSize:kFontSize];
        _albumTitle.textColor = [UIColor whiteColor];
        _albumTitle.frame = CGRectMake(20, 20, self.frame.size.width, self.albumTitle.frame.size.height);
    }
    
    return _albumTitle;
}
- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:self.frame];
        _coverView.frame = CGRectMake(20, 115, (self.frame.size.width / 2), (self.frame.size.width / 2));
        _coverView.backgroundColor = [UIColor grayColor];
    }
    
    return _coverView;
}



@end
