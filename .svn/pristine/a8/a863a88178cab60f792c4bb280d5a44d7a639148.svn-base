//
//  TakePhotoViewController.m
//  Guide
//
//  Created by ksm on 16/4/19.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "TakePhotoViewController.h"

@interface TakePhotoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{

    UIImagePickerController *imagePicker;
    UIActionSheet           *alertSheet;
    
}

@end

@implementation TakePhotoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //全屏展示
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.view.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;

}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    if (alertSheet == nil) {
        alertSheet = [[UIActionSheet alloc]initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相机" otherButtonTitles:@"相册", nil];
        [alertSheet showInView:self.view];
    }

}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    FxLog(@"%ld",buttonIndex);
    
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self LocalPhoto];
            
            break;
        case 2:
             [self dismissViewControllerAnimated:YES completion:nil];
            
            break;
        default:
            break;
    }
}

- (void)takePhoto {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }else {
    
        [SVProgressHUD showWithStatus:@"无拍照功能"];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)LocalPhoto {

    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark UIImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//        UIImage *newImage = [Uitils imageWithImage:image scaledToSize:CGSizeMake(200, 120)];
//        NSData *data = UIImageJPEGRepresentation(newImage, 1);
        
        if (self.callBack != nil) {
            
            self.callBack(image);
        }
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (void)returnImage:(ReturnImageBlock)block {

    self.callBack = block;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}


@end
