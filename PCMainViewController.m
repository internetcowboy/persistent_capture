//
//  PCMainViewController.m
//  Persistent Capture
//
//  Created by InternetCowboy | Codin Pangell on 1/29/14.
//  Copyright (c) 2014 InternetCowboy | Codin Pangell. All rights reserved.
//

#import "PCMainViewController.h"
#import "PCAlbumView.h"
#import "PCAlbumCollectionViewCell.h"
#import "PCAddAlbum.h"
#import "UIComponentsClass.h"
#import "PCIOController.h"
#import "PCAlbumDetailView.h"
#import "PCAlbumDayView.h"
#import "PCVideoController.h"

#import <AssetsLibrary/AssetsLibrary.h>		//<<Can delete if not storing videos to the photo library.  Delete the assetslibrary framework too requires this)
#import <MediaPlayer/MediaPlayer.h>


@interface PCMainViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) PCAlbumView *albumView;
@property (nonatomic,strong) PCAddAlbum *addAlbumView;
@property (nonatomic,strong) PCAlbumDetailView *detailView;
@property (nonatomic, strong) PCAlbumDayView *dayView;


@end

@implementation PCMainViewController {
    bool isAddButton;
    bool takingPhoto;
    bool isRecording;
    UIComponentsClass * uicore;
    PCIOController * iocore;
    PCVideoController * videofilecore;
    NSString *activeAlbum;
    NSString *activeDayOfTheWeek;
    NSString *activeVideoPath;
    AVCaptureStillImageOutput *stillImageOutput;
    UIImage *imageForNewAlbum;
    int currentDetailAlbum;
    int activeDayOfTheWeekIndex;
    AVCaptureSession *videoSession;
    AVCaptureMovieFileOutput *MovieFileOutput;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    uicore = [UIComponentsClass new];
    iocore = [PCIOController new];
    videofilecore = [PCVideoController new];
    
    //kick off the party
    [self initObjects];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    self.albumView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.addAlbumView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.detailView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    self.dayView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}


- (void)initObjects
{
    
    //attach sub views
    [self.view addSubview:self.addAlbumView];
    [self.view addSubview:self.albumView];
    [self.view sendSubviewToBack:self.albumView];
    [self.view addSubview:self.detailView];
    [self.view addSubview:self.dayView];
    
    //init VC controls
    [self initAlbumView];
    [self initAddAlbumView];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //silly keyboard, hide yo-self.
    [[self view] endEditing:YES];
}


#pragma mark AlbumView Items

-(void)initAlbumView {
    
    //main title for album
    [self setTitleText:@"Albums"];
    isAddButton = YES;
    
    //event handler for add / close button
    UITapGestureRecognizer *addAlbumTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTapped:)];
    [self.albumView.addIcon addGestureRecognizer:addAlbumTap];
    [self.albumView.addIcon setUserInteractionEnabled:YES];

}


-(void)setTitleText:(NSString *)titleText {
    
    //main title for album
    self.albumView.infoTitle.text = [titleText uppercaseString];
    [self.albumView.infoTitle sizeToFit];
    self.albumView.infoTitle.frame = CGRectMake(0, 50, self.albumView.frame.size.width, self.albumView.infoTitle.frame.size.height);
    self.albumView.infoTitle.textAlignment = NSTextAlignmentCenter;
    
}


#pragma mark Add AlbumView Items

- (void)initAddAlbumView {
    
    takingPhoto = NO;
    
    //event handler for take takePhotoIcon
    UITapGestureRecognizer *takePhotoIconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openCameraView:)];
    [self.addAlbumView.takePhotoIcon addGestureRecognizer:takePhotoIconTap];
    [self.addAlbumView.takePhotoIcon setUserInteractionEnabled:YES];
    
    //event handler for take snapPhotoButton
    UITapGestureRecognizer *snapPhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(snapPhotoAction:)];
    [self.addAlbumView.snapPhoto addGestureRecognizer:snapPhotoTap];
    [self.addAlbumView.snapPhoto setUserInteractionEnabled:YES];
    
    //event handler for save album button
    UITapGestureRecognizer *saveAlbum = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveAlbumAction:)];
    [self.addAlbumView.saveAlbumBtn addGestureRecognizer:saveAlbum];
    [self.addAlbumView.saveAlbumBtn setUserInteractionEnabled:YES];
    
    
}

- (void)saveAlbumAction:(UIGestureRecognizer *)gestureRecognizer {
    
    NSString * aTitle = [self.addAlbumView.albumTitleText text];
    if ([aTitle isEqualToString:@""]) {
        [self raiseAlert:@"Enter an album name."];
    } else {
        NSLog(@"save complete");
        [iocore saveImageToDocuments:imageForNewAlbum albumName:aTitle imageName:@"thumbnail.jpg"];
        self.addAlbumView.albumTitle.text = @"";
        
        //close and reload the collectionview
        [self closeAddAlbumView];
        [self.albumView initAlbums];
    }

}

- (void) raiseAlert:(NSString *) alertText
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertText
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    [alert show];
}

- (void)snapPhotoAction:(UIGestureRecognizer *)gestureRecognizer {
    
    NSLog(@"Take photo");
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         //resize image
         image = [uicore squareImageWithImage:image scaledToSize:self.addAlbumView.photoView.frame.size];
         
         //extract the image and set it in this square on addAlbumView
         UIImageView *BGImage = [UIImageView new];
         BGImage.frame = CGRectMake(0, 0, self.addAlbumView.photoView.frame.size.width, self.addAlbumView.photoView.frame.size.height);
         [BGImage setImage:image];
         imageForNewAlbum = image;
         [self.addAlbumView.photoView addSubview:BGImage];
         
         //hide camera view
         [self hideTakePhotoView];
         
     }];

    
}

- (void)openCameraView:(UIGestureRecognizer *)gestureRecognizer {
    
    NSLog(@"Open Camera");
    
    self.addAlbumView.cameraView.hidden = NO;
    [self setTitleText:@"Take Album Photo"];
    takingPhoto = YES;
    [UIView animateWithDuration:0.2
                     animations:^{
                         //camera view
                         self.addAlbumView.cameraView.frame = CGRectMake(0, 0, self.addAlbumView.frame.size.width, self.addAlbumView.frame.size.height);
                         
                         
                     } completion:^(BOOL finished){
                         //init camera
                         AVCaptureSession *session = [[AVCaptureSession alloc] init];
                         session.sessionPreset = AVCaptureSessionPresetMedium;

                         AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
                         captureVideoPreviewLayer.frame = self.addAlbumView.cameraView.frame;
                         
                         [self.addAlbumView.cameraView.layer addSublayer:captureVideoPreviewLayer];
                         
                         AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
                         NSError *error = nil;
                         AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
                         if (!input) {
                             NSLog(@"ERROR: trying to open camera: %@", error);
                         }
                         [session addInput:input];
                         
                         stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
                         NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
                         [stillImageOutput setOutputSettings:outputSettings];
                         [session addOutput:stillImageOutput];
                         [session startRunning];
                     }];
    
}

- (void)addTapped:(UIGestureRecognizer *)gestureRecognizer {
    
    if (takingPhoto){
        
        [self hideTakePhotoView];

    } else {
        if (isAddButton){
            NSLog(@"is Add");
            
            //load in the add album View
            [UIView animateWithDuration:0.5
                             animations:^{
                                 [self.albumView.addIcon setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90))];
                                 [self setTitleText:@"Add Album"];
                                 self.addAlbumView.frame = CGRectMake(0, 100, self.addAlbumView.frame.size.width, self.addAlbumView.frame.size.height);
                             } completion:nil];
            
            isAddButton = NO;
        } else {
            NSLog(@"is Close");
            [self closeAddAlbumView];
        }
    }
    
   
 
}

-(void)closeAddAlbumView {
    
    //close add album View
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.albumView.addIcon setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45))];
                         [self setTitleText:@"Albums"];
                         self.addAlbumView.frame = CGRectMake(0, self.addAlbumView.frame.size.height, self.addAlbumView.frame.size.width, self.addAlbumView.frame.size.height);
                     } completion:nil];
    isAddButton = YES;
    
}

-(void)hideTakePhotoView {
    
    //hide the take photo view and show add album view
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.addAlbumView.cameraView.frame = CGRectMake(0, self.addAlbumView.frame.size.height, self.addAlbumView.frame.size.width, self.addAlbumView.frame.size.height);
                     } completion:^(BOOL finished){
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              self.addAlbumView.cameraView.hidden = YES;
                                              takingPhoto = NO;
                                              [self setTitleText:@"Add Album"];
                                              self.addAlbumView.frame = CGRectMake(0, 100, self.addAlbumView.frame.size.width, self.addAlbumView.frame.size.height);
                                          } completion:nil];
                     }];
    
}


- (void)albumView:(PCAlbumView *)albumView didSelectButton:(UIButton *)button {
    
    //determine index point of item and obtain the name of the album
    int row = button.tag;
    currentDetailAlbum = row;
    activeAlbum = self.albumView.albums[row];
    
    NSLog(@"Load Album Detail :: %@",activeAlbum);
    NSLog(@"DUMP : %@",[videofilecore obtainVideoDictionaryForWeek:activeAlbum]);
    
    //dump out whole list of items
    //[iocore displayAllFilesAndDirectories];
    
    //obtain Cell
    PCAlbumCollectionViewCell *cell = (PCAlbumCollectionViewCell *)[self.albumView.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    
    //set the album info
    self.detailView.weekInfo = [videofilecore obtainVideoDictionaryForWeek:activeAlbum];
    [self.detailView.collectionView reloadData];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                        
                         //animate view
                         self.albumView.frame = CGRectMake(0, -(self.albumView.frame.size.height-140), self.albumView.frame.size.width, self.albumView.frame.size.height);
                         
                         //set up components for cell
                         cell.coverImageView.frame = CGRectMake((self.albumView.frame.size.width-150), 0, cell.coverImageView.frame.size.width, cell.coverImageView.frame.size.width);
                         cell.thumbnail.hidden = YES;
                         cell.openBtn.hidden = YES;
                         
                         //prepare the action for the close detail button
                         UITapGestureRecognizer *closeAlbumDetail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAlbumDetail:)];
                         [cell.closeDetailLbl addGestureRecognizer:closeAlbumDetail];
                         [cell.closeDetailLbl setUserInteractionEnabled:YES];
                   
                     } completion:^(BOOL finished){
                         self.albumView.collectionView.scrollEnabled = NO;
                         cell.closeDetailLbl.hidden = NO;
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                                //animate in detail panel
                                                self.detailView.frame = CGRectMake(0, 130, self.view.bounds.size.width, self.view.bounds.size.height);
                                              } completion:nil];
                        
                        
                            
                     }];
     

}

- (void)detailView:(PCAlbumDetailView *)detailView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    int ind = indexPath.item;
    NSArray *daysOfTheWeek = [NSArray arrayWithObjects: @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday", nil];
    activeDayOfTheWeek = daysOfTheWeek[ind];
    activeDayOfTheWeekIndex = ind;
    NSDictionary *albumFullDictionary = [videofilecore obtainVideoDictionaryForWeek:activeAlbum];
    NSArray *dayInformation = [albumFullDictionary valueForKey:activeDayOfTheWeek];
    
    NSLog(@"DAY : %@  didSelectItemAtIndexPath detailview",dayInformation);
    
    activeVideoPath = dayInformation[1];
    /*
     DAY : (
        "02-21-2014",
        "Codin_1/Friday/video_02-21-2014.mov",
        true
     )
     */
    
    
    
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         //day title
                         self.dayView.dayTitle.text = [daysOfTheWeek[ind] uppercaseString];
                         
                         //show video button if it exists
                         if ([dayInformation[2] isEqualToString:@"true"]) {
                             self.dayView.showVideo.hidden = NO;
                             self.dayView.directionsTitle.text = [@"Edit this days moment by tapping the thumbnail below. All video will be automatically saved for this day." uppercaseString];
                             
                            
                             //show a thumbnail for the video that has been recorded.
                             NSString *documentsDirectory = [iocore documentDirectory];
                             NSString *videoFile = [documentsDirectory stringByAppendingPathComponent:dayInformation[1]];
                             AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath: videoFile] options:nil];
                             AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                             NSError *error = NULL;
                             CMTime time = CMTimeMake(1, 65);
                             CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
                             UIImage *FrameImage= [[UIImage alloc] initWithCGImage:refImg];
                             
                             //I have no clue why this image needs to be rotated but it does.
                             UIImage *rotatedImage = [uicore imageRotatedByDegrees:FrameImage deg:90.0];
                             
                             //make it square
                             rotatedImage = [uicore squareImageWithImage:rotatedImage scaledToSize:self.dayView.thumbnailView.frame.size ];
                             self.dayView.thumbnailView.image = rotatedImage;
                             
                         } else {
                             self.dayView.showVideo.hidden = YES;
                             self.dayView.directionsTitle.text = [@"Create a video for today. Tap the box below to get started. The video will be automatically saved when it is done recording." uppercaseString];
                         }
                         
                         
                         
                         //animate view
                         self.dayView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         
                         //prepare the action for the close detail button
                         UITapGestureRecognizer *closeDayView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeDayView:)];
                         [self.dayView.closeIcon addGestureRecognizer:closeDayView];
                         [self.dayView.closeIcon setUserInteractionEnabled:YES];
                         
                         //prepare the action for the load Video
                         UITapGestureRecognizer *openRecorder = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openRecorder:)];
                         [self.dayView.thumbnailView addGestureRecognizer:openRecorder];
                         [self.dayView.thumbnailView setUserInteractionEnabled:YES];
                         
                         //prepare the action for the play video
                         UITapGestureRecognizer *playVideo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo:)];
                         [self.dayView.showVideo addGestureRecognizer:playVideo];
                         [self.dayView.showVideo setUserInteractionEnabled:YES];
                         
                     } completion:^(BOOL finished){
                         
                     }];
    
}

- (void)playVideo:(UIGestureRecognizer *)gestureRecognizer {
    
    NSLog(@"PLAY VIDEO WITH PATH :: %@", activeVideoPath);
    
    //given path for song
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
    NSString *strPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory1,activeVideoPath];
    NSLog(@"Play Video %@", strPath);
    NSURL *videosURL = [NSURL fileURLWithPath:strPath];
    AVPlayerItem  *playerItem = [AVPlayerItem playerItemWithURL:videosURL];
    
    // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
    // Pass the AVPlayerItem to a new player
    self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    
    //attach this video player to a layer
    self.layer = [AVPlayerLayer layer];
    [self.layer setPlayer:self.player];
    [self.layer setFrame:CGRectMake(0, 0, self.dayView.thumbnailView.frame.size.width, self.dayView.thumbnailView.frame.size.height)];
    [self.layer setBackgroundColor:[UIColor clearColor].CGColor];
    [self.layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.dayView.thumbnailView.layer addSublayer:self.layer];
    [self.player play];
    
}

- (void)openRecorder:(UIGestureRecognizer *)gestureRecognizer {
    
    
    //camera view
    self.dayView.videoViewWrapper.frame = CGRectMake(0, 0, self.albumView.frame.size.width, self.albumView.frame.size.height);
    self.dayView.videoView.frame = CGRectMake(0, 0, self.dayView.frame.size.width, self.dayView.frame.size.height);
    self.dayView.videoViewWrapper.hidden = NO;
    
    //set recorder button state
    isRecording=NO;
    self.dayView.recorderIcon.image = [UIImage imageNamed:@"record.png"];
    UITapGestureRecognizer *startRecord = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startRecord:)];
    [self.dayView.recorderIcon addGestureRecognizer:startRecord];
    [self.dayView.recorderIcon setUserInteractionEnabled:YES];
    
    //close video event
    UITapGestureRecognizer *closeVideo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeVideo:)];
    [self.dayView.closeVideoIcon addGestureRecognizer:closeVideo];
    [self.dayView.closeVideoIcon setUserInteractionEnabled:YES];
    
    //get the video recording party started.
    [self initRecorder];
}

-(void)initRecorder {
    
    //perhaps the video is playing. stop it
    [self.player pause];
    
    //---------------------------------
	//----- SETUP CAPTURE SESSION -----
	//---------------------------------
	NSLog(@"Setting up capture session");
	videoSession = [[AVCaptureSession alloc] init];
	
	//----- ADD INPUTS -----
	NSLog(@"Adding video input");
	
	//ADD VIDEO INPUT
    AVCaptureDeviceInput *VideoInputDevice;
	AVCaptureDevice *VideoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if (VideoDevice)
	{
		NSError *error;
		VideoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:VideoDevice error:&error];
		if (!error)
		{
			if ([videoSession canAddInput:VideoInputDevice])
				[videoSession addInput:VideoInputDevice];
			else
				NSLog(@"Couldn't add video input");
		}
		else
		{
			NSLog(@"Couldn't create video input");
		}
	}
	else
	{
		NSLog(@"Couldn't create video capture device");
	}
	
	//ADD AUDIO INPUT
	NSLog(@"Adding audio input");
	AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
	NSError *error = nil;
	AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
	if (audioInput)
	{
		[videoSession addInput:audioInput];
	}
	
    //show video layer
    self.dayView.videoViewWrapper.hidden = NO;
    self.dayView.videoView.hidden = NO;

	
	//----- ADD OUTPUTS -----
	
	//ADD VIDEO PREVIEW LAYER
	NSLog(@"Adding video preview layer");
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:videoSession];
    captureVideoPreviewLayer.frame = self.dayView.videoView.frame;
    [self.dayView.videoView.layer addSublayer:captureVideoPreviewLayer];
    
	//ADD MOVIE FILE OUTPUT
	NSLog(@"Adding movie file output");
	MovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
	
	Float64 TotalSeconds = 5;			//Total seconds
	int32_t preferredTimeScale = 30;	//Frames per second
	CMTime maxDuration = CMTimeMakeWithSeconds(TotalSeconds, preferredTimeScale);	//<<SET MAX DURATION
	MovieFileOutput.maxRecordedDuration = maxDuration;
	
	MovieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024;						//<<SET MIN FREE SPACE IN BYTES FOR RECORDING TO CONTINUE ON A VOLUME
	
	if ([videoSession canAddOutput:MovieFileOutput])
		[videoSession addOutput:MovieFileOutput];
    
    //----- START THE CAPTURE SESSION RUNNING -----
    [videoSession startRunning];
    
	
}


- (void)closeVideo:(UIGestureRecognizer *)gestureRecognizer {
    
    NSLog(@"Close Video");

    //reload information on day view
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:activeDayOfTheWeekIndex inSection:0];
    [self.detailView collectionView:self.detailView.collectionView didSelectItemAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         //animate view
                         self.dayView.frame = CGRectMake(0, 0, self.albumView.frame.size.width, self.albumView.frame.size.height);
                         //reset states
                         self.dayView.videoViewWrapper.hidden = YES;
                         self.dayView.recorderIcon.image = [UIImage imageNamed:@"record.png"];
                         isRecording=NO;
                         
                     } completion:^(BOOL finished){
                         
                     }];
    
}

- (void)startRecord:(UIGestureRecognizer *)gestureRecognizer {
    
    //set recorder button state
    if (isRecording) {
        isRecording=NO;
        self.dayView.recorderIcon.image = [UIImage imageNamed:@"record.png"];
        [self stopVideoRecord];
    } else {
        isRecording=YES;
        self.dayView.recorderIcon.image = [UIImage imageNamed:@"stoprecord.png"];
        [self startVideoRecord];
    }
    
    
}

-(void)startVideoRecord {
    
    
    //----- START RECORDING -----
    NSLog(@"START RECORDING");
   
    
    //create the directory /albumname/dayOfTheWeek
    NSString *subDirectory = [NSString stringWithFormat:@"%@/%@/", activeAlbum, activeDayOfTheWeek];
    [iocore createDirectoryIfNotExist:subDirectory];
    
    //obtain some paths
    NSString *documentsDirectory = [iocore documentDirectory];
    NSString *videoDirectory = [documentsDirectory stringByAppendingPathComponent:subDirectory];
    
    //create file name
    NSLog(@"FILE CREATED NAME :: %@", [videofilecore returnDateForDayOfTheWeek:activeDayOfTheWeek]);
    
    //append file name onto file path
    NSString *filePath = [videoDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"video_%@.mov",[videofilecore returnDateForDayOfTheWeek:activeDayOfTheWeek]]];

    /*
    
     //RECORD TO ALBUM
     
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
    NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outputPath]) {
        NSError *error;
        if ([fileManager removeItemAtPath:outputPath error:&error] == NO) {
            //Error - handle if requried
            NSLog(@"ERROR RECORDING");
        }
    }
    */

    //Start recording
    NSLog(@"RECORD TO :: %@",filePath);
    NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:filePath];
    
    //if file exists remove it
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        if ([fileManager removeItemAtPath:filePath error:&error] == NO) {
            //Error - handle if requried
            NSLog(@"ERROR RECORDING");
        }
    }
    
    //start recording
    [MovieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];

}

-(void)stopVideoRecord {
    
    //----- STOP RECORDING -----
    NSLog(@"STOP RECORDING");

    [MovieFileOutput stopRecording];
    
}


//********** DID FINISH RECORDING TO OUTPUT FILE AT URL **********
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
	  fromConnections:(NSArray *)connections
				error:(NSError *)error
{
    
	NSLog(@"didFinishRecordingToOutputFileAtURL - enter");
	
    BOOL RecordedSuccessfully = YES;
    if ([error code] != noErr) {
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value) {
            RecordedSuccessfully = [value boolValue];
        }
    }
	if (RecordedSuccessfully) {
		//----- RECORDED SUCESSFULLY -----
        
        /*
         
         SAVE TO PHOTO ALBUM
         
         
        NSLog(@"didFinishRecordingToOutputFileAtURL - success");
		ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
		if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileURL])
		{
			[library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
										completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 if (error) {
                     NSLog(@"AN ERROR RECORDING SUCCESSFULLY");
                 }
             }];
		}
         
        
         */
        NSLog(@"Successful record");
        isRecording=NO;
        self.dayView.recorderIcon.image = [UIImage imageNamed:@"record.png"];
        [self stopVideoRecord];
        
        //reload album information
		//[self.albumView initAlbums];
	}
}


- (void)closeDayView:(UIGestureRecognizer *)gestureRecognizer {
    
    NSLog(@"close DayView");
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         //animate view
                         self.dayView.frame = CGRectMake(0, 0, -self.view.frame.size.width, self.view.frame.size.height);
                         
                         //hide elements
                         self.dayView.videoViewWrapper.hidden = YES;
                         self.dayView.videoView.hidden = YES;
                         
                         //remove player layer
                         [self.layer removeFromSuperlayer];
                         [self.player pause];
                         
                     } completion:^(BOOL finished){
                         
                         //remove image with a blank one if it is inside the frame
                         UIImage *dumb = [UIImage new];
                         self.dayView.thumbnailView.image = dumb;
                         self.dayView.thumbnailView.image = nil;
                         
                         //set the album info with brand new data
                         self.detailView.weekInfo = [videofilecore obtainVideoDictionaryForWeek:activeAlbum];
                         [self.detailView.collectionView reloadData];
                         
                     }];
    
}

- (void)closeAlbumDetail:(UIGestureRecognizer *)gestureRecognizer {

    //obtain cell
    PCAlbumCollectionViewCell *cell = (PCAlbumCollectionViewCell *)[self.albumView.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:currentDetailAlbum inSection:0]];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         //animate in detail panel
                         self.detailView.frame = CGRectMake(0, self.view.bounds.size.height * 2, self.view.bounds.size.width, self.view.bounds.size.height);
                     } completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              
                                              //animate view
                                              self.albumView.frame = CGRectMake(0, 0, self.albumView.frame.size.width, self.albumView.frame.size.height);
                                              
                                              //set up components for cell
                                              cell.coverImageView.frame = CGRectMake(self.albumView.frame.size.width*2, 0, cell.coverImageView.frame.size.width, cell.coverImageView.frame.size.width);
                                              cell.thumbnail.hidden = NO;
                                              cell.closeDetailLbl.hidden = YES;
                                              
                                          } completion:^(BOOL finished){
                                              self.albumView.collectionView.scrollEnabled = YES;
                                              cell.openBtn.hidden = NO;
                                              
                                          }];
                         
                     }];
    
    
}


#pragma mark Subviews

- (PCAlbumView *)albumView {
    if (!_albumView) {
        _albumView = [[PCAlbumView alloc] initWithFrame:self.view.bounds];
        _albumView.delegate = self;
    }
    
    return _albumView;
}

- (PCAddAlbum *)addAlbumView {
    if (!_addAlbumView) {
        _addAlbumView = [[PCAddAlbum alloc] initWithFrame:self.view.bounds];
    }
    
    return _addAlbumView;
}

- (PCAlbumDetailView *)detailView {
    if (!_detailView) {
        _detailView = [[PCAlbumDetailView alloc] initWithFrame:self.view.bounds];
        [_detailView setDelegate:self];
    }
    
    return _detailView;
}

- (PCAlbumDayView *)dayView {
    if (!_dayView) {
        _dayView = [[PCAlbumDayView alloc] initWithFrame:self.view.bounds];
    }
    
    return _dayView;
}



@end
