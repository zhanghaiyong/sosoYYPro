//
//  UIViewController+DismissKeyboard.m
//  my
//
//  Created by soso-mac on 2016/11/28.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "UIViewController+DismissKeyboard.h"

@implementation UIViewController (DismissKeyboard)

- (void)setupForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    
    __weak UIViewController *weakSelf = self;
    
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [weakSelf.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [weakSelf.view removeGestureRecognizer:singleTapGR];
                }];
}



- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的firstresponder都resign掉
    [self.view endEditing:YES];
    __weak UIViewController *weakSelf=self;
    NSBlockOperation * bop = [[NSBlockOperation alloc] init];
    [bop addExecutionBlock:^{
        NSTimeInterval animationDuration = 0.2f;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width = weakSelf.view.frame.size.width;
        float height = weakSelf.view.frame.size.height;
        CGRect rect = CGRectMake(0, 0,width,height);
        self.view.frame = rect;
        [UIView commitAnimations];
    }];
    [bop start];
}

//监视键盘高度
-(void)setupForDismissKeyboardHight:(CGFloat)textFieldHight{
    __weak UIViewController *weakSelf=self;
    int hight=weakSelf.view.frame.size.height-textFieldHight-300 - 64;
    NSBlockOperation *bop=[[NSBlockOperation alloc]init];
    [bop addExecutionBlock:^{
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        if (hight<216){
            float width = self.view.frame.size.width;
            float height = self.view.frame.size.height;
            CGRect rect = CGRectMake(0, -(216-hight+40),width,height);
            self.view.frame = rect;
        }
        [UIView commitAnimations];
    }];
    [bop start];
}

-(void)retrunForDismissKeyboard:(UITextField *)textField {
    
    [textField resignFirstResponder];
    __weak UIViewController *weakSelf=self;
    
    NSBlockOperation * bop = [[NSBlockOperation alloc] init];
    [bop addExecutionBlock:^{
        NSTimeInterval animationDuration = 0.2f;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width = weakSelf.view.frame.size.width;
        float height = weakSelf.view.frame.size.height;
        CGRect rect = CGRectMake(0, 0,width,height);
        self.view.frame = rect;
        [UIView commitAnimations];
    }];
    [bop start];
}
-(void)setCallTell:(NSString *)tel{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"你要拨打电话吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //      [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",tel]]];
        //        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]]]];
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]]];
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)textViewOrTextFieldEditChanged:(NSNotification *)obj{
    
    if ([obj.userInfo[@"view"] isKindOfClass:[UITextView class]]) {
       
        [self setUpTextViewEditChanged:obj maxLength:[obj.userInfo[@"num"] integerValue]];
        
    }else{
       [self setUpTextFieldEditChanged:obj maxLength:[obj.userInfo[@"num"] integerValue]];
    }
}

-(void)setUpTextViewEditChanged:(NSNotification *)obj maxLength:(NSInteger )maxLength{
    
  UITextView *textView = (UITextView *)obj.userInfo[@"view"];
    
    NSString *toBeString = textView.text;
    NSString *lang = [textView.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textView markedTextRange];
        
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        if (!position) {
            if (toBeString.length > maxLength) {
                textView.text = [toBeString substringToIndex:maxLength];
                [ZHProgressHUD showInfoWithText:[NSString stringWithFormat:@"最多只能输入%zi个字",maxLength]];
            }
        }
        
        else{
            
        }
    }
    else{
        if (toBeString.length > maxLength) {
            textView.text = [toBeString substringToIndex:maxLength];
        }
    }
}
-(void)setUpTextFieldEditChanged:(NSNotification *)obj maxLength:(NSInteger )maxLength{
    
    UITextField *textField = (UITextField *)obj.userInfo[@"view"];
    
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        if (!position) {
            if (toBeString.length > maxLength) {
                textField.text = [toBeString substringToIndex:maxLength];
             [ZHProgressHUD showInfoWithText:[NSString stringWithFormat:@"不能超过%zi位数字",maxLength]];
            }
        }
        
        else{
            
        }
    }
    else{
        if (toBeString.length > maxLength) {
            textField.text = [toBeString substringToIndex:maxLength];
        }
    }
}
-(void)tabBarControllerHidden{
 self.tabBarController.tabBar.hidden = YES;
}
-(void)addTabBarView{
    UIView *tabBarView = [UIView new];
    tabBarView.backgroundColor = [UIColor whiteColor];
    tabBarView.frame = CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49);
    [self.view addSubview:tabBarView];
}

-(void)addTabNavView{
    
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, kScreenWidth, 20);
    view.backgroundColor = [UIColor fromHexValue:0xea5413 alpha:1];
    [self.view addSubview:view];
}

@end
