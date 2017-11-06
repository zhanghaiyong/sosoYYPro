//
//  RegisterIOUStepOne.m
//  sosoYY
//
//  Created by zhy on 2017/8/16.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "RegisterIOUStepOne.h"
#import "ApplyMsgModel.h"
#import "RegisterIOUSecondStep.h"
#import "CheckAndRepeat.h"
#import "StepTools.h"
#import <Contacts/Contacts.h>
#import "VSImageHelp.h"
@interface RegisterIOUStepOne ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{

    ApplyMsgModel *applyMsgModel;
    CheckAndRepeat *checkModify;
    UIVisualEffectView *effectView;
    UIButton *nextBtn;
}
@property (weak, nonatomic) IBOutlet UITextField *storeName;
@property (weak, nonatomic) IBOutlet UITextField *applyName;
@property (weak, nonatomic) IBOutlet UITextField *IDCard;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UIImageView *cameraLogo;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UITextField *applyPhone;

@end

@implementation RegisterIOUStepOne

- (void)showAlert {
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (status) {
        case CNAuthorizationStatusNotDetermined:// 未进行授权选择
        {
            //授权
            dispatch_async(dispatch_get_main_queue(), ^{
                CNContactStore *store = [[CNContactStore alloc] init];
                [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (granted) {
                        NSLog(@"授权成功");
                    } else {
                        [[UIApplication sharedApplication].keyWindow hideToastActivity];
                        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"首推需要访问您的通讯录，只有您同意后才能继续申请白条，是否同意？" preferredStyle:UIAlertControllerStyleAlert];
                        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=Privacy&path=CONTACTS"]];
                        }]];
                        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        }]];
                        [self presentViewController:alertCtrl animated:YES completion:nil];
                        NSLog(@"授权失败");
                    }
                }];
            });
        }
            break;
        case CNAuthorizationStatusRestricted: // 不仅应用软件无法访问通讯录数据，就连用户也无法通过设置修改授权状态
            break;
        case CNAuthorizationStatusDenied://表示用户不允许访问通讯录数
            NSLog(@"表示用户不允许访问通讯录数");
        {
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"首推需要访问您的通讯录，只有您同意后才能继续申请白条，是否同意？" preferredStyle:UIAlertControllerStyleAlert];
            [alertCtrl addAction:[UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=Privacy&path=CONTACTS"]];
            }]];
            [alertCtrl addAction:[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertCtrl animated:YES completion:nil];
        }
            break;
        case CNAuthorizationStatusAuthorized://应用软件期望得到的状态
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUp];
    
    [self showAlert];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:18], NSFontAttributeName, nil]];
    self.navigationController.navigationBar.barTintColor = [UIColor fromHexValue:0xEa5413];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    UIBarButtonItem *negativeSpacer = [[ UIBarButtonItem alloc ] initWithBarButtonSystemItem : UIBarButtonSystemItemFixedSpace                                             target : nil action : nil ];
    negativeSpacer. width = - 18;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,backBarItem];
    self.navigationController.navigationBar.translucent = NO;

    
    #pragma mark 获取申请人信息
    [StepTools getApplyMsgRequest:requestApplyMsg finshed:^(ApplyMsgModel *entity, NSError *error) {
        
        if (entity) {
            applyMsgModel = entity;
            if (applyMsgModel.storeName.length > 0) {
                self.storeName.text = applyMsgModel.storeName;
            }
            
            if (applyMsgModel.realname.length > 0) {
                self.applyName.text = applyMsgModel.realname;
            }
            
            if (applyMsgModel.mobile.length > 0) {
                self.applyPhone.text = applyMsgModel.mobile;
            }
            
            if (applyMsgModel.number.length > 0) {
                self.IDCard.text = applyMsgModel.number;
            }
            
        }
    }];
}


//返回
- (void)backClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UI设置
- (void)setUp {

    self.title = @"开通白条";
    nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, 45)];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextStepClick) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.backgroundColor = [UIColor fromHexValue:0xCCCCCC];
    self.tableView.tableFooterView = nextBtn;
    
}


#pragma mark UITableViewDelegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 5) {
        [self choseStoreImg];
    }
}

#pragma mark takePhone 
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        //先把图片转成NSData
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *editImage = [VSImageHelp image:image fitInSize:CGSizeMake(kDeviceWidth*1.2, (KDeviceHeight-140)*1.2)];
        self.postImage.image = image;
        applyMsgModel.editImage = editImage;
        applyMsgModel.oriImage = image;
        self.cameraLogo.hidden = YES;
        self.alertLabel.hidden = YES;
        
        [self getLocation];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 点击拍照
- (void)choseStoreImg {
    
    if (checkModify == nil) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"1.请确保您的网络连接正常\n2.请拍摄申请药店的正面，门面照\n3.如果上传失败，请切换4G或WIFI后再试" preferredStyle:UIAlertControllerStyleAlert];
        UIView *subView1 = alertController.view.subviews[0];
        UIView *subView2 = subView1.subviews[0];
        UIView *subView3 = subView2.subviews[0];
        UIView *subView4 = subView3.subviews[0];
        UIView *subView5 = subView4.subviews[0];
//        NSLog(@"%@",subView5.subviews);
//        //取title和message：
//        UILabel *title = subView5.subviews[0];
        UILabel *message = subView5.subviews[1];
        message.textAlignment = NSTextAlignmentLeft;
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self takePhone];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
       
    }else {
    
        if ([checkModify.label.text isEqualToString:@"上传成功，点击修改"]) {
            UIButton *modityBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight-60, kScreenWidth, 50)];
            [modityBtn setTitle:@"重新上传" forState:UIControlStateNormal];
            [modityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [modityBtn addTarget:self action:@selector(modifyTake) forControlEvents:UIControlEventTouchUpInside];
            [StepTools scanBigImageWithImageView:self.postImage image:applyMsgModel.oriImage alpha:1 button:modityBtn];
        }else if ([checkModify.label.text isEqualToString:@"上传失败，请点击重试"]) {
        
            [self getLocation];
        }
    }
}

#pragma mark 拍照
- (void)takePhone {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }else {
        
        [ZHProgressHUD showInfoWithText:@"请在iphone的“设置－隐私－相机”选项中，允许首推访问你的相机。"];
    }
}

#pragma mark 重新拍照
- (void)modifyTake {

    [StepTools hideImageView];
    [self takePhone];
}

#pragma mark 下一步
- (void)nextStepClick {
    
    if (self.storeName.text.length == 0) {
        [ZHProgressHUD showInfoWithText:@"请填写药店完整名称"];
        return;
    }
    
    if (self.applyName.text.length == 0) {
        [ZHProgressHUD showInfoWithText:@"请填写申请人姓名"];
        return;
    }
    
    if (self.applyPhone.text.length == 0) {
        [ZHProgressHUD showInfoWithText:@"请填写申请人电话号码"];
        return;
    }
    
    if (![[self.applyPhone.text stringByReplacingOccurrencesOfString:@" " withString:@""] isMobilphone]) {
        [ZHProgressHUD showInfoWithText:@"您的电话号码有误，请检查并重新填写"];
        return;
    }
    
    if (self.IDCard.text.length == 0) {
        [ZHProgressHUD showInfoWithText:@"请填写身份证号码"];
        return;
    }
    
    if ([[self.IDCard.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 15 || [[self.IDCard.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 18) {

    }else {
        [ZHProgressHUD showInfoWithText:@"您的身份证号码有误，请检查并重新填写"];
        return;
    }
    
    if (applyMsgModel.editImage == nil) {
        [ZHProgressHUD showInfoWithText:@"请上传门店照片"];
        return;
    }
    
    applyMsgModel.storeName = self.storeName.text;
    applyMsgModel.realname = self.applyName.text;
    applyMsgModel.mobile = self.applyPhone.text;
    applyMsgModel.number = self.IDCard.text;
    
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    [KSMNetworkRequest postRequest:requestVerifyIdno_Mobile params:@{@"idno":self.IDCard.text,@"mobile":self.applyPhone.text} success:^(id responseObj) {
       
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        if ([responseObj[@"success"] integerValue] == 1) {
            UIStoryboard *SB = [UIStoryboard storyboardWithName:@"RegisterIOUSecondStep" bundle:nil];
            RegisterIOUSecondStep *stepSecond = [SB instantiateViewControllerWithIdentifier:@"RegisterIOUSecondStep"];
            stepSecond.applyMsgModel = applyMsgModel;
            [self.navigationController pushViewController:stepSecond animated:YES];
        }else {
        
            [ZHProgressHUD showInfoWithText:responseObj[@"info"]];
        }
        
    } failure:^(NSError *error) {
        
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        [ZHProgressHUD showErrorWithText:@"网络错误，请重试！"];
    }];
    
}

#pragma mark 获取经纬度
- (void)getLocation {

    if (checkModify == nil) {
        //显示"点击查看或者修改"
        checkModify = [[[NSBundle mainBundle] loadNibNamed:@"CheckAndRepeat" owner:self options:nil] lastObject];
        checkModify.frame = CGRectMake(kScreenWidth/2-170/2, 90, 170, 100);
        checkModify.activity.hidden = NO;
        checkModify.userInteractionEnabled = NO;
        checkModify.logo.hidden = YES;
        [checkModify.activity startAnimating];
        checkModify.label.text = @"正在上传...";
        nextBtn.userInteractionEnabled = NO;
        nextBtn.backgroundColor = [UIColor fromHexValue:0xCCCCCC];
        checkModify.center = self.postImage.center;
        [self.postImage.superview addSubview:checkModify];
    }else {
    
        checkModify.userInteractionEnabled = NO;
        checkModify.activity.hidden = NO;
        checkModify.logo.hidden = YES;
        [checkModify.activity startAnimating];
        checkModify.label.text = @"正在上传...";
        nextBtn.userInteractionEnabled = NO;
        nextBtn.backgroundColor = [UIColor fromHexValue:0xCCCCCC];
    }
    

    if (effectView == nil) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        //  毛玻璃视图
        effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //添加到要有毛玻璃特效的控件中
        effectView.frame = self.postImage.bounds;
        [self.postImage addSubview:effectView];
        //设置模糊透明度
        effectView.alpha = 1;
    }else {
    
        effectView.alpha = 1;
    }
    
    [SharedApp startLocationFinshed:^(CLLocationDegrees latitude, CLLocationDegrees longitude, NSError *error) {
        
        if (!error) {
            checkModify.activity.hidden = YES;
            [checkModify.activity stopAnimating];
            checkModify.logo.hidden = NO;
            checkModify.logo.image = [UIImage imageNamed:@"成功"];
            checkModify.label.text = @"上传成功，点击修改";
            nextBtn.userInteractionEnabled = YES;
            nextBtn.backgroundColor = [UIColor fromHexValue:0xEA5413];
            effectView.alpha = 0;
            checkModify.userInteractionEnabled = YES;
            
            applyMsgModel.latitude = latitude;
            applyMsgModel.longitude = longitude;
            
        }else {
            
            checkModify.activity.hidden = YES;
            [checkModify.activity stopAnimating];
            checkModify.logo.hidden = NO;
            checkModify.logo.image = [UIImage imageNamed:@"失败"];
            checkModify.label.text = @"上传失败，请点击重试";
            checkModify.userInteractionEnabled = YES;
        }
    }];
}

@end
