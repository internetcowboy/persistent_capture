//
//  PCMainViewController.h
//  Persistent Capture
//
//  Created by InternetCowboy | Codin Pangell on 1/29/14.
//  Copyright (c) 2014 InternetCowboy | Codin Pangell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PCAlbumView.h"
#import "PCAlbumDetailView.h"

@interface PCMainViewController : UIViewController <PCAlbumViewDelegate, PCAlbumDetailViewDelegate, AVCaptureFileOutputRecordingDelegate>


@property AVPlayer* player;
@property AVPlayerLayer *layer;

@end
