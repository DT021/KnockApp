//
//  QRViewController.m
//  KnockApp
//
//  Created by Fangzhou Sun on 11/24/15.
//  Copyright © 2015 Fangzhou Sun. All rights reserved.
//
//  Test JSON file
//  https://chart.googleapis.com/chart?cht=qr&chs=512x512&chl=https://dl.dropboxusercontent.com/s/cjvg206lansc1by/task.json?dl=0
//

#import "QRViewController.h"
#import "TopicViewController.h"
#import "AFNetworking.h"
#import "Device.h"

@interface QRViewController () {
    NSInteger scanStatus;
}

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) CATextLayer *label;

@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cSAV_view.alpha = 0;
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    scanStatus=0;
    [self startReading];
    [self loadBeepSound];
    _captureSession = nil;
    
    [self startAnimation];
}

- (void)startAnimation {
    self.cSAV_view.type = CSAnimationTypeBounceLeft;
    self.cSAV_view.duration = 0.3;
    self.cSAV_view.delay = 0.0;
    [self.cSAV_view startCanvasAnimation];
    self.cSAV_view.alpha = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)startReading {
    /*
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // Initialize the captureSession object.
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"scan" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:_viewPreview.layer.bounds];
    webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    [_viewPreview addSubview:webView];
    
    // Start video capture.
    [_captureSession startRunning];
    
    */
    
    
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        NSError *error;
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        
        if (!input) {
            // If any error occurs, simply log the description of it and don't continue any more.
            NSLog(@"%@", [error localizedDescription]);
        }
        
        // Initialize the captureSession object.
        _captureSession = [[AVCaptureSession alloc] init];
        // Set the input device on the capture session.
        [_captureSession addInput:input];
        
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [_captureSession addOutput:captureMetadataOutput];
        
        // Create a new serial dispatch queue.
        dispatch_queue_t dispatchQueue;
        dispatchQueue = dispatch_queue_create("myQueue", NULL);
        [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
        [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
        [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
        
        
        // Start video capture.
        [_captureSession startRunning];
        
//        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            
            [_viewPreview.layer addSublayer:_videoPreviewLayer];
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"scan" ofType:@"gif"];
            NSData *gifData = [NSData dataWithContentsOfFile:path];
            UIWebView *webView = [[UIWebView alloc] initWithFrame:_viewPreview.layer.bounds];
            webView.scalesPageToFit = YES;
            webView.backgroundColor = [UIColor clearColor];
            webView.opaque = NO;
            [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
            [_viewPreview addSubview:webView];
//        });
//    });
    
    return YES;
}

-(void)stopReading{
    // Stop video capture and make the capture session object nil.
    [_captureSession stopRunning];
    _captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    [_videoPreviewLayer removeFromSuperlayer];
    [_viewPreview removeFromSuperview];
    scanStatus=1;
}

-(void)loadBeepSound{
    // Get the path to the beep.mp3 file and convert it to a NSURL object.
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    
    NSError *error;
    
    // Initialize the audio player object using the NSURL object previously set.
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        // If the audio player cannot be initialized then log a message.
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        // If the audio player was successfully initialized then load it in memory.
        [_audioPlayer prepareToPlay];
    }
}

-(void)getDataFromURL:(NSString *)dataURL{
    
    NSManagedObjectContext* context = [CoreDataHelper managedObjectContext];
    NSArray* items = [CoreDataHelper fetchEntitiesForClass:[Device class] withPredicate:nil inManagedObjectContext:context];
    NSString *token = @"";
    for (Device* device in items){
        token = device.token;
    }
    
//    NSURL *URL=[NSURL URLWithString: [NSString stringWithFormat:@"%@%@", dataURL, token]];
    NSURL *URL=[NSURL URLWithString: [NSString stringWithFormat:@"%@%@", @"http://10.67.152.111:5000/device?token=", token]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    [policy setValidatesDomainName:NO];
    [policy setAllowInvalidCertificates:YES];
    
    AFHTTPRequestOperation *downloadRequest = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    downloadRequest.securityPolicy.allowInvalidCertificates = YES;
    [downloadRequest setSecurityPolicy:policy];
    
    [downloadRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dataDic = (NSDictionary *)responseObject;
//        
//        NSLog(@"%@", [dataDic objectForKey:@"configs"]);
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"file downloading error : %@", [error localizedDescription]);
    }];
    
    // Step 5: begin asynchronous download
    [downloadRequest start];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // If the found metadata is equal to the QR code metadata then update the status label's text,
            // stop reading and change the bar button item's title and the flag's value.
            // Everything is done on the main thread.
            
            NSLog(@"Successfull: %@", [metadataObj stringValue]);
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            
            if (_audioPlayer) {
                if (_audioPlayer.isPlaying == YES || scanStatus==1)
                    scanStatus=1;
                else
                    [_audioPlayer play];
            }
            
            scanStatus=1;
            //            TopicViewController *topicViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TopicViewController"];
            //            [self presentViewController:topicViewController animated:YES completion:nil];
            
            [self getDataFromURL: [metadataObj stringValue]];
//            [self performSelectorOnMainThread:@selector(presentToTopicView) withObject:nil waitUntilDone:NO];
        }
    }
}

//- (void)presentToTopicView {
//    [self getDataFromURL: [metadataObj stringValue]];
//    
//    
//
////    TopicViewController *topicViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TopicViewController"];
////    [self presentViewController:topicViewController animated:YES completion:nil];
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btnQRBack:(id)sender {
    //    [self.navigationController popViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
