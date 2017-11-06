//
//  SYQRCodeViewController.m
//  SYQRCodeDemo
//
//  Created by sunbb on 15-1-9.
//  Copyright (c) 2015年 SY. All rights reserved.
//

#import "SYQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZXingObjC.h"


//设备宽/高/坐标
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
#define KDeviceFrame [UIScreen mainScreen].bounds

static const float kLineMinY = 185;
static const float kLineMaxY = 385;
static const float kReaderViewWidth = 200;
static const float kReaderViewHeight = 200;

@interface SYQRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) AVCaptureSession *qrSession;//回话
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *qrVideoPreviewLayer;//读取
@property (nonatomic, strong) UIImageView *line;//交互线
@property (nonatomic, strong) NSTimer *lineTimer;//交互线控制
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic,assign) Boolean isOpen;

@end

@implementation SYQRCodeViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
    [self setOverlayPickerView];
    [self startSYQRCodeReading];
    [self initTitleView];
    [self createBackBtn];
    _isOpen=NO;
    [self CheckHaveCamera];
}

-(void)CheckHaveCamera
{
  
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {

        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请在iphone的“设置－隐私－相机”选项中，允许首推访问你的相机。" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
         
         }else{
        
        // [self presentModalViewController:picker animated:YES];
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
 
- (void)dealloc
{
    if (_qrSession) {
        [_qrSession stopRunning];
        _qrSession = nil;
    }
    
    if (_qrVideoPreviewLayer) {
        _qrVideoPreviewLayer = nil;
    }
    
    if (_line) {
        _line = nil;
    }
    
    if (_lineTimer)
    {
        [_lineTimer invalidate];
        _lineTimer = nil;
    }
}

- (void)initTitleView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth, 64)];
    //bgView.backgroundColor = [UIColor colorWithRed:62.0/255 green:199.0/255 blue:153.0/255 alpha:1.0];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    [self.view addSubview:bgView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - 140) / 2.0, 28, 140, 20)];
    //scanCropView.image=[UIImage imageNamed:@""];
    //titleLab.layer.borderColor = [UIColor greenColor].CGColor;
    //titleLab.layer.borderWidth = 2.0;
    //titleLab.backgroundColor = [UIColor colorWithRed:62.0/255 green:199.0/255 blue:153.0/255 alpha:1.0];
    
    //titleLab.text = @"扫一扫";
    titleLab.shadowColor = [UIColor lightGrayColor];
    titleLab.shadowOffset = CGSizeMake(0, - 1);
    titleLab.font = [UIFont boldSystemFontOfSize:18.0];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    
    titleLab.text=@"二维码／条码";
    [self.view addSubview:titleLab];
}

- (void)createBackBtn
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(20, 28, 60, 24)];
    [btn setImage:[UIImage imageNamed:@"bar_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancleSYQRCodeReading) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    //创建灯光开关按钮
    UIButton *btnOpenLight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOpenLight setFrame:CGRectMake((kDeviceWidth - 80), 28, 40, 20)];
    UIFont *iconf= [UIFont fontWithName:@"IconFont" size: 25];
    [btnOpenLight.titleLabel setFont:iconf];
    [btnOpenLight setTitle:@"\U0000e610" forState:UIControlStateNormal];
    [btnOpenLight addTarget:self action:@selector(Flashlight:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnOpenLight];
    
    //创建相册选择按钮
//    UIButton *btnChoosePic=[UIButton buttonWithType:UIButtonTypeCustom];
//    [btnChoosePic setFrame:CGRectMake((kDeviceWidth - 40), 28, 40, 20)];
//    [btnChoosePic setFont:iconf];
//    [btnChoosePic setTitle:@"\U0000e60a" forState:UIControlStateNormal];
//    [btnChoosePic addTarget:self action:@selector(OpenPic:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnChoosePic];
}

-(void)OpenPic:(id)sender
{
    if (!_imagePickerController) {
        
        _imagePickerController = [[UIImagePickerController alloc] init];
        
        _imagePickerController.delegate = self;
        
        _imagePickerController.allowsEditing = YES;
        
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}
-(void)Flashlight:(id)sender
{
    UIButton *button = {(UIButton *)sender};
    if(_isOpen==NO)
    {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOn];
            [device unlockForConfiguration];
            _isOpen=YES;
            [button setTitle:@"\U0000e60f" forState:UIControlStateNormal];
        }
    }
        else{
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            if ([device hasTorch]) {
                [device lockForConfiguration:nil];
                [device setTorchMode: AVCaptureTorchModeOff];
                [device unlockForConfiguration];
                _isOpen=NO;
                [button setTitle:@"\U0000e610" forState:UIControlStateNormal];
            }
        }
        
        
        
        
    
}

    - (void)initUI
    {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        //摄像头判断
        NSError *error = nil;
        
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        
        
        if (error)
        {
            FxLog(@"没有摄像头-%@", error.localizedDescription);
            
            return;
        }
        
        //设置输出(Metadata元数据)
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        
        //设置输出的代理
        //使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [output setRectOfInterest:[self getReaderViewBoundsWithSize:CGSizeMake(kReaderViewWidth, kReaderViewHeight)]];
        
        //拍摄会话
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        
        // 读取质量，质量越高，可读取小尺寸的二维码
        if ([session canSetSessionPreset:AVCaptureSessionPreset1920x1080])
        {
            [session setSessionPreset:AVCaptureSessionPreset1920x1080];
        }
        else if ([session canSetSessionPreset:AVCaptureSessionPreset1280x720])
        {
            [session setSessionPreset:AVCaptureSessionPreset1280x720];
        }
        else
        {
            [session setSessionPreset:AVCaptureSessionPresetPhoto];
        }
        
        if ([session canAddInput:input])
        {
            [session addInput:input];
        }
        
        if ([session canAddOutput:output])
        {
            [session addOutput:output];
        }
        
        //设置输出的格式
        //一定要先设置会话的输出为output之后，再指定输出的元数据类型
        //[output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]];
        //设置预览图层
        AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
        
        //设置preview图层的属性
        //preview.borderColor = [UIColor redColor].CGColor;
        //preview.borderWidth = 1.5;
        [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        //设置preview图层的大小
        preview.frame = self.view.layer.bounds;
        //[preview setFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
        
        //将图层添加到视图的图层
        [self.view.layer insertSublayer:preview atIndex:0];
        //[self.view.layer addSublayer:preview];
        self.qrVideoPreviewLayer = preview;
        self.qrSession = session;
    }
    
    - (CGRect)getReaderViewBoundsWithSize:(CGSize)asize
    {
        return CGRectMake(kLineMinY / KDeviceHeight, ((kDeviceWidth - asize.width) / 2.0) / kDeviceWidth, asize.height / KDeviceHeight, asize.width / kDeviceWidth);
    }
    
    - (void)setOverlayPickerView
    {
        //画中间的基准线
        _line = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth - 300) / 2.0, kLineMinY, 300, 12 * 300 / 320.0)];
        [_line setImage:[UIImage imageNamed:@"QRCodeLine"]];
        [self.view addSubview:_line];
        
        //最上部view
        
        UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kLineMinY)];//80
        upView.alpha = 0.3;
        upView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:upView];
        
        //左侧的view
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, kLineMinY, (kDeviceWidth - kReaderViewWidth) / 2.0, kReaderViewHeight)];
        leftView.alpha = 0.3;
        leftView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:leftView];
        
        //右侧的view
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth - CGRectGetMaxX(leftView.frame), kLineMinY, CGRectGetMaxX(leftView.frame), kReaderViewHeight)];
        rightView.alpha = 0.3;
        rightView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:rightView];
        
        CGFloat space_h = KDeviceHeight - kLineMaxY;
        
        //底部view
        UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, kLineMaxY, kDeviceWidth, space_h)];
        downView.alpha = 0.3;
        downView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:downView];
        
        //四个边角
        UIImage *cornerImage = [UIImage imageNamed:@"QRCodeTopLeft"];
        
        //左侧的view
        UIImageView *leftView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - cornerImage.size.width / 2.0, CGRectGetMaxY(upView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
        leftView_image.image = cornerImage;
        [self.view addSubview:leftView_image];
        
        cornerImage = [UIImage imageNamed:@"QRCodeTopRight"];
        
        //右侧的view
        UIImageView *rightView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width / 2.0, CGRectGetMaxY(upView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
        rightView_image.image = cornerImage;
        [self.view addSubview:rightView_image];
        
        cornerImage = [UIImage imageNamed:@"QRCodebottomLeft"];
        
        //底部view
        UIImageView *downView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - cornerImage.size.width / 2.0, CGRectGetMinY(downView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
        downView_image.image = cornerImage;
        //downView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:downView_image];
        
        cornerImage = [UIImage imageNamed:@"QRCodebottomRight"];
        
        UIImageView *downViewRight_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width / 2.0, CGRectGetMinY(downView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
        downViewRight_image.image = cornerImage;
        //downView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:downViewRight_image];
        
        //说明label
        UILabel *labIntroudction = [[UILabel alloc] init];
        labIntroudction.backgroundColor = [UIColor clearColor];
        labIntroudction.frame = CGRectMake(CGRectGetMaxX(leftView.frame), CGRectGetMinY(downView.frame) + 25, kReaderViewWidth, 20);
        labIntroudction.textAlignment = NSTextAlignmentCenter;
        labIntroudction.font = [UIFont boldSystemFontOfSize:13.0];
        labIntroudction.textColor = [UIColor whiteColor];
        labIntroudction.text = @"将二维码置于框内,即可自动扫描";
        [self.view addSubview:labIntroudction];
        
       /* UIButton *btnS=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnS.frame=CGRectMake(CGRectGetMaxX(leftView.frame), CGRectGetMinY(downView.frame) + 50, kReaderViewWidth, 20);
        [btnS setTitle:@"选择相册" forState:UIControlStateNormal];
        
        [btnS addTarget:self action:@selector(touchButton)  forControlEvents :UIControlEventTouchUpInside];
        [self.view addSubview:btnS];
        */
        
        UIView *scanCropView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - 1,kLineMinY,self.view.frame.size.width - 2 * CGRectGetMaxX(leftView.frame) + 2, kReaderViewHeight + 2)];
        scanCropView.layer.borderColor = [UIColor greenColor].CGColor;
        scanCropView.layer.borderWidth = 2.0;
        [self.view addSubview:scanCropView];
    }
/*
    -(void)touchButton
    {
        if (!_imagePickerController) {
            
            
            
            _imagePickerController = [[UIImagePickerController alloc] init];
            
            _imagePickerController.delegate = self;
            
            _imagePickerController.allowsEditing = YES;
            
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
        }
        [self presentViewController:_imagePickerController animated:YES completion:nil];
        
    }
 */
    - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
    
    {
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            
            
            [self getInfoWithImage:image];
            
        }];
        
    }
    -(void)getInfoWithImage:(UIImage *)img{
        
        
        
        UIImage *loadImage= img;
        
        CGImageRef imageToDecode = loadImage.CGImage;
        
        
        
        ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
        
        
        ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
        
        
        NSError *error = nil;
        
        
        
        ZXDecodeHints *hints = [ZXDecodeHints hints];
        
        
        
        ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
        
        ZXResult *result = [reader decode:bitmap
                            
                                    hints:hints
                            
                                    error:&error];
        
        
        
        if (result) {
            
            
            
            NSString *contents = result.text;
            
            //  [selfshowInfoWithMessage:contents andTitle:@"解析成功"];
            
            
            
            FxLog(@"相册图片contents == %@",contents);
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:contents,@"code", nil];
            
            [self dismissViewControllerAnimated:NO completion:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"do" object:self userInfo:dic];
            }];
            
        } else {
            
            
            
            //  [selfshowInfoWithMessage:nilandTitle:@"解析失败"];
            
            
            
        }
        
    }
#pragma mark -
#pragma mark 输出代理方法
    
    //此方法是在识别到QRCode，并且完成转换
    //如果QRCode的内容越大，转换需要的时间就越长
    - (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
    {
        //扫描结果
        if (metadataObjects.count > 0)
        {
            [self stopSYQRCodeReading];
            
            AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
            
            if (obj.stringValue && ![obj.stringValue isEqualToString:@""] && obj.stringValue.length > 0)
            {
                FxLog(@"---------%@",obj.stringValue);
                
                //  if ([obj.stringValue containsString:@"http"])
                //  {
                if (self.SYQRCodeSuncessBlock) {
                    self.SYQRCodeSuncessBlock(self,obj.stringValue);
                }
                //}
                //  else
                //  {
                //      if (self.SYQRCodeFailBlock) {
                //         self.SYQRCodeFailBlock(self);
                //    }
                //  }
            }
            else
            {
                if (self.SYQRCodeFailBlock) {
                    self.SYQRCodeFailBlock(self);
                }
            }
        }
        else
        {
            if (self.SYQRCodeFailBlock) {
                self.SYQRCodeFailBlock(self);
            }
        }
    }
    
    
#pragma mark -
#pragma mark 交互事件
    
    - (void)startSYQRCodeReading
    {
        _lineTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 20 target:self selector:@selector(animationLine) userInfo:nil repeats:YES];
        
        [self.qrSession startRunning];
        
        FxLog(@"start reading");
    }
    
    - (void)stopSYQRCodeReading
    {
        if (_lineTimer)
        {
            [_lineTimer invalidate];
            _lineTimer = nil;
        }
        
        [self.qrSession stopRunning];
        
        FxLog(@"stop reading");
    }
    
    //取消扫描
    - (void)cancleSYQRCodeReading
    {
        [self stopSYQRCodeReading];
        
        if (self.SYQRCodeCancleBlock)
        {
            self.SYQRCodeCancleBlock(self);
        }
        FxLog(@"cancle reading");
    }
    
    
#pragma mark -
#pragma mark 上下滚动交互线
    
    - (void)animationLine
    {
        __block CGRect frame = _line.frame;
        
        static BOOL flag = YES;
        
        if (flag)
        {
            frame.origin.y = kLineMinY;
            flag = NO;
            
            [UIView animateWithDuration:1.0 / 20 animations:^{
                
                frame.origin.y += 5;
                _line.frame = frame;
                
            } completion:nil];
        }
        else
        {
            if (_line.frame.origin.y >= kLineMinY)
            {
                if (_line.frame.origin.y >= kLineMaxY - 12)
                {
                    frame.origin.y = kLineMinY;
                    _line.frame = frame;
                    
                    flag = YES;
                }
                else
                {
                    [UIView animateWithDuration:1.0 / 20 animations:^{
                        
                        frame.origin.y += 5;
                        _line.frame = frame;
                        
                    } completion:nil];
                }
            }
            else
            {
                flag = !flag;
            }
        }
        
        //NSLog(@"_line.frame.origin.y==%f",_line.frame.origin.y);
    }
    
    @end
