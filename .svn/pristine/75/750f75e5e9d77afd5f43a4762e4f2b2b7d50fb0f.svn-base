//
//  STWisdomToSearchCountView.m
//  sosoYY
//
//  Created by soso-mac on 2017/3/29.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomToSearchCountView.h"

@interface STWisdomToSearchCountView ()<UITextFieldDelegate>
@property(strong,nonatomic)NSString *buyCount;
@property(strong,nonatomic)NSString *goods_Package_ID;
@end

@implementation STWisdomToSearchCountView

-(void)setWisdomToSearchCountBuy:(STProductListEntity *)entity{
    
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 10.0f;
    
    _subtractBtn.layer.masksToBounds = YES;
    _subtractBtn.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    _subtractBtn.layer.borderWidth = .5;
    
    _addBtn.layer.masksToBounds = YES;
    _addBtn.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    _addBtn.layer.borderWidth = .5;
    
    _textTextField.delegate = self;
//    _textTextField.inputAccessoryView = [self addToolbar];
    _textTextField.layer.masksToBounds = YES;
    _textTextField.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    _textTextField.layer.borderWidth = .5;
    
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    _cancelBtn.layer.borderWidth = .5;
    
    _finishedBtn.layer.masksToBounds = YES;
    _finishedBtn.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    _finishedBtn.layer.borderWidth = .5;
    
    _goods_Package_ID = [NSString stringWithFormat:@"%@",entity.goods_Package_ID];
    _buyCount = @"1";
    _textTextField.text = _buyCount;

}
- (UIToolbar *)addToolbar{
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    UIBarButtonItem *finished = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finished)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIToolbar *toobar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kToobarHeight)];
    toobar.backgroundColor = [UIColor whiteColor];
    toobar.layer.borderColor  = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    toobar.layer.borderWidth = .5;
    toobar.layer.masksToBounds = YES;
    toobar.tintColor = [UIColor fromHexValue:0x555555 alpha:1];
    toobar.items = [NSArray arrayWithObjects:cancel,spaceItem,finished ,nil];
    return toobar;
}
- (IBAction)subtractSelectBtn:(UIButton *)sender {
     [_textTextField resignFirstResponder];
    if (1 >= [_textTextField.text intValue]) {
        [ZHProgressHUD showInfoWithText:@"购买数量不能小于1"];
    }else{
        _textTextField.text = [NSString stringWithFormat:@"%d",[_textTextField.text intValue] - 1];
        _buyCount = _textTextField.text;
    }
}
- (IBAction)addSelectBtn:(UIButton *)sender {
     [_textTextField resignFirstResponder];
    if (99999 <= [_textTextField.text intValue]) {
        [ZHProgressHUD showInfoWithText:@"购买数量不能大于99999"];
    }else{
        _textTextField.text = [NSString stringWithFormat:@"%d",[_textTextField.text intValue] + 1];
        _buyCount = _textTextField.text;
    }
}

- (IBAction)cancelSelectBtn:(UIButton *)sender {
    if (_WisdomSearchCountBlock) {
        _WisdomSearchCountBlock(0,@{@"num":_buyCount,@"Goods_Package_ID":_goods_Package_ID});
    }
    [_textTextField resignFirstResponder];
}
- (IBAction)finishedSelectBtn:(UIButton *)sender {
    if ( 1 > [_textTextField.text intValue]) {
        [ZHProgressHUD showInfoWithText:@"购买数量不能小于1"];
        _textTextField.text = @"";
    }else if(99999 < [_textTextField.text intValue]){
        [ZHProgressHUD showInfoWithText:@"购买数量不能大于99999"];
        _textTextField.text = @"";
    }else{
        _buyCount = _textTextField.text;
        if (_WisdomSearchCountBlock) {
            _WisdomSearchCountBlock(1,@{@"num":_buyCount,@"Goods_Package_ID":_goods_Package_ID});
        }
    }
    [_textTextField resignFirstResponder];
}
- (IBAction)deleteSelectBtn:(UIButton *)sender {
    if (_WisdomSearchCountBlock) {
        _WisdomSearchCountBlock(0,@{@"num":_buyCount,@"Goods_Package_ID":_goods_Package_ID});
    }
    [_textTextField resignFirstResponder];
}
-(void)finished{
    if ( 1 > [_textTextField.text intValue]) {
        [ZHProgressHUD showInfoWithText:@"购买数量不能小于1"];
        _textTextField.text = @"";
    }else if(99999 < [_textTextField.text intValue]){
        [ZHProgressHUD showInfoWithText:@"购买数量不能大于99999"];
        _textTextField.text = @"";
    }else{
        _buyCount = _textTextField.text;
        [_textTextField resignFirstResponder];
    }
}
-(void)cancel{
    [_textTextField resignFirstResponder];
    _textTextField.text = _buyCount;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _textTextField.text = @"";
}

@end
