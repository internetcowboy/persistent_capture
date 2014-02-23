//
//  PCAlbumView.m
//  Persistent Capture
//
//  Created by InternetCowboy | Codin Pangell on 1/29/14.
//  Copyright (c) 2014 InternetCowboy | Codin Pangell. All rights reserved.
//
/*
 
 #0d8080
 Red = 13
 Green = 128
 Blue = 128	#87c0c0
 Red = 135
 Green = 192
 Blue = 192	#074040
 Red = 7
 Green = 64
 Blue = 64	#c3dfdf
 Red = 195
 Green = 223
 Blue = 223	#096060
 Red = 9
 Green = 96
 Blue = 96	#659090
 Red = 101
 Green = 144
 Blue = 144	#053030
 Red = 5
 Green = 48
 Blue = 48	#92a7a7
 
 */
#import "PCAlbumView.h"
#import "UIComponentsClass.h"
#import "PCIOController.h"
#import "PCAlbumCollectionViewCell.h"

@implementation PCAlbumView{
    UIComponentsClass * uicore;
    PCIOController * iocore;
    int cellWidth;
}

static NSString * const kFontName = @"HelveticaNeue-Bold";
static NSString * const kFontNameMed = @"HelveticaNeue-Medium";
static float kFontSize = 13.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"Album View...");
        self.backgroundColor = UIColorFromRGB(0x074040);
        
        //init helper classes
        uicore = [UIComponentsClass new];
        iocore = [PCIOController new];
        
        //smaller items
        [self addSubview:self.infoTitle];
        [self addSubview:self.addIcon];
        
        //create collection view layout
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0.0f;
        layout.minimumInteritemSpacing = 0.0f;
        
        //create collectionview
        self.collectionView=[[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        self.collectionView.dataSource = self;
        [self.collectionView setDelegate:self];
        [self.collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.collectionView registerClass:[PCAlbumCollectionViewCell class] forCellWithReuseIdentifier:@"cellAlbum"];
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.collectionView];
        
        [self initAlbums];
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.collectionView.frame = CGRectMake(0, 80, self.bounds.size.width, self.bounds.size.height);
    
}

-(void)initAlbums {
    NSLog(@"init albums");
    self.albums = [iocore obtainAlbums];
    [self.collectionView reloadData];
    
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.albums count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    cellWidth = self.frame.size.width;
    return CGSizeMake( cellWidth, cellWidth+150);
}


- (PCAlbumCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSLog(@"%@",indexPath);
    
    PCAlbumCollectionViewCell *cell = (PCAlbumCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellAlbum" forIndexPath:indexPath];
    int ind = indexPath.item;
    
    //set title for album and adjust the position.
    cell.albumTitle.text = [self.albums[ind] uppercaseString];
    cell.albumTitle.frame = CGRectMake(20, 0, cellWidth, 20);

    [cell bringSubviewToFront:cell.albumTitle];
    
    //set title for last updated and adjust the position.
    //cell.lastUpdatedTitle.text = [@"Last Updated : 01/30/2013" uppercaseString];
    //cell.lastUpdatedTitle.frame = CGRectMake(20, 20, cellWidth, 20); //(cellWidth + cell.lastUpdatedTitle.frame.size.height)
    
    //set title for number of days running and adjust the position.
    //cell.numberOfDaysTitle.text = [@"Days Running : 10" uppercaseString];
    //cell.numberOfDaysTitle.frame = CGRectMake(20, 40, cellWidth, 20);

    
    //load the thumbnail image
    cell.thumbnail.image = nil;
    NSString * documentsDir = [iocore documentDirectory];
    BOOL doesThumbnailExist = [iocore fileExistsAtAbsolutePath : [NSString stringWithFormat:@"%@/%@/thumbnail.jpg", documentsDir, self.albums[ind]]];
    if (doesThumbnailExist) {
        UIImage *thumb = [iocore obtainThumbnail:self.albums[ind] imageName:@"thumbnail.jpg"];
        cell.thumbnail.image = thumb;
        cell.coverImageView.image = thumb;
    }
    
    //adjust frames
    cell.thumbnail.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    cell.infoView.frame = CGRectMake(0, cell.frame.size.height-30, self.frame.size.width, (cell.frame.size.height-self.collectionView.frame.size.height) );
    
    //prepare the action for the open button
    cell.openBtn.tag = ind;
    [cell.openBtn addTarget:self action:@selector(albumDetailClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    return cell;
}

- (void)albumDetailClicked:(id)sender {
    
    //forward delegate to view controller
    [self.delegate albumView:self didSelectButton:sender];
}

- (UILabel *)infoTitle {
    if (!_infoTitle) {
        _infoTitle = [uicore newCustomFontLabel:@" " y:0 x:0 w:0 h:0 fontName:kFontNameMed fontSize:kFontSize];
        _infoTitle.textColor = [UIColor whiteColor];
    }
    
    return _infoTitle;
}


- (UILabel *)addIcon {
    if (!_addIcon) {
        _addIcon = [uicore newCustomFontLabel:@"B" y:0 x:0 w:0 h:0 fontName:@"Untitled-Regular" fontSize:24.0f];
        _addIcon.backgroundColor = [UIColor clearColor];
        _addIcon.frame = CGRectMake((self.frame.size.width-55), 50, 40, 40);
        [_addIcon setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45))]; //yeah I know. It is an X that I turned into a + because I didn't want to render out a font.
    }
    
    return _addIcon;
}


@end
