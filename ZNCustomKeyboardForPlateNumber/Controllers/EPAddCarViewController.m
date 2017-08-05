//
//  EPAddCarViewController.m
//  ZNCustomKeyboardForPlateNumber
//
//  Created by FunctionMaker on 2017/7/8.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

#import "EPAddCarViewController.h"
#import "EPCarPlateViewController.h"
#import <sys/utsname.h>

@interface EPAddCarViewController () <UITextFieldDelegate, EPKeyboardDeleteWord>

@property (weak, nonatomic) IBOutlet UITextField *firstCell;
@property (weak, nonatomic) IBOutlet UITextField *secondCell;
@property (weak, nonatomic) IBOutlet UITextField *thirdCell;

@property (weak, nonatomic) IBOutlet UILabel *plateNumber;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellWidth;

@end

@implementation EPAddCarViewController {
    UITextField *_currentInputer;
    
    EPCarPlateViewController *_carPlateViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"添加车辆";
    
    [_secondCell becomeFirstResponder];

    [self adjustUILayout];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _currentInputer = textField;
    textField.background = [UIImage imageNamed:@"txt_sel"];
    
    CGFloat minusHeight = [[[NSUserDefaults standardUserDefaults] objectForKey:@"smallIPhone"] boolValue] ? 50.0f: 125.0f;
    
    EPKeyboardType type = EPKeyboardTypeNumberAndLetter;
    EPHiddenCellsType hiddenType = 0;
    
    if (textField.tag == 100) {
        type = EPKeyboardTypeProvinceShortName;
    } else {
        minusHeight += 50.0f;
    }
    
    if (textField.tag == 200) {
        hiddenType = EPHiddenCellsTypeNumbersAndWord;
    } else if (textField.tag == 300) {
        hiddenType = EPHiddenCellsTypeIOAndWord;
    } else if (textField.tag == 1000) {
        hiddenType = EPHiddenCellsTypeIO;
    }
    
    CGRect viewFrame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_finishButton.frame) - minusHeight);
    
    _carPlateViewController = [[EPCarPlateViewController alloc] initWithKeyboardType:type hiddenType:hiddenType];
    _carPlateViewController.delegate = self;
    
    UIView *inputView = _carPlateViewController.inputView;
    inputView.frame = viewFrame;
    
    textField.inputView = inputView;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.background = [UIImage imageNamed:@"txt_nor"];
}

#pragma mark - Delete word delegate

- (void)deleteWord {
    NSInteger index = [self.view.subviews[0].subviews indexOfObject:_currentInputer];
    index --;
    
    _currentInputer.text = @"";
    
    if (index >= 2) {
        UITextField *beforeInputer = self.view.subviews[0].subviews[index];
        [beforeInputer becomeFirstResponder];
        
        _currentInputer = beforeInputer;
    }
}

#pragma mark - Private

- (void)adjustUILayout {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];

    BOOL isOrBeforeIPhone6 = [platform compare:@"iPhone7,1"] == NSOrderedAscending || [platform isEqualToString:@"iPhone7,2"];
    BOOL isSE = [platform isEqualToString:@"iPhone8,4"] ;
    BOOL isNormal = [[platform substringWithRange:NSMakeRange(platform.length - 1, 1)] isEqualToString:@"1"] && [platform compare:@"iPhone7,1"] == NSOrderedDescending;
    BOOL isPlus = [[platform substringWithRange:NSMakeRange(platform.length - 1, 1)] isEqualToString:@"2"] || [platform isEqualToString:@"iPhone7,1"];

    //iPhone 6以及以下
    if (isOrBeforeIPhone6 || isSE || isNormal) {
        NSLog(@"屏幕尺寸小于iPhone6");
        _cellWidth.constant = 32.0f;
        _cellHeight.constant = 43.0f;
    
        _plateNumber.font = [UIFont systemFontOfSize:14.0f];
        
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"smallIPhone"];
    } else if (isPlus) {
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"smallIPhone"];
    }
}

- (BOOL)validateCarPlateNumberWithNumber:(NSString *)number {
    if ([number isEqualToString:@""]) {
        NSLog(@"车牌号不能为空");
        
        return NO;
    } else if (number.length < 7) {
        NSLog(@"车牌号格式有误");
        
        return NO;
    } else {
        NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-hj-zA-HJ-Z]{1}[a-hj-zA-HJ-Z_0-9]{4}[a-hj-zA-HJ-Z_0-9_\u4e00-\u9fa5]$";
        NSPredicate *carPlateValidate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
        BOOL plateIsValid = [carPlateValidate evaluateWithObject:number];
        if (!plateIsValid) {
            NSLog(@"车牌号格式有误");
        }
        
        return plateIsValid;
    }
}

#pragma mark - IB action

- (IBAction)convertCarPlateMode:(UIButton *)sender {
    _firstCell.hidden = !_firstCell.hidden;
    
    _firstCell.text = @"";
    _secondCell.text = @"";
    
    if (_firstCell.hidden) {
        _secondCell.tag = 100;
        _thirdCell.tag = 200;
        
        for (int i = 5; i < 9; i ++) {
            self.view.subviews[0].subviews[i].tag = 300;
        }
        
        [_secondCell resignFirstResponder];
        [_secondCell becomeFirstResponder];
    } else {
        [_firstCell becomeFirstResponder];
        _secondCell.tag = 200;
        
        for (int i = 4; i < 9; i ++) {
            self.view.subviews[0].subviews[i].tag = 300;
        }
    }
}

- (IBAction)finishAddingPlate:(UIButton *)sender {
    NSMutableString *plateNumber = [NSMutableString stringWithCapacity:9];
    
    NSString *firstWord = _firstCell.hidden ? @"" : _firstCell.text;
    [plateNumber appendString:firstWord];
    
    for (int i = 3; i < 10; i ++) {
        [plateNumber appendString:((UITextField *)self.view.subviews[0].subviews[i]).text];
    }
    
    if ([self validateCarPlateNumberWithNumber:plateNumber]) {
        if ([self.delegate respondsToSelector:@selector(aNewCarWithPlateNumber:)]) {
            [self.delegate aNewCarWithPlateNumber:plateNumber];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)textChanged:(UITextField *)sender {
    NSInteger index = [self.view.subviews[0].subviews indexOfObject:sender];
    index ++;
    
    if (index < 10) {
        UITextField *nextInputer = self.view.subviews[0].subviews[index];
        
        [nextInputer becomeFirstResponder];
        
        _currentInputer = nextInputer;
    }
}

@end
