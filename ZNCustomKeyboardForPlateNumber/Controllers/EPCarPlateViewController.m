//
//  EPCarPlateViewController.m
//  ZNCustomKeyboardForPlateNumber
//
//  Created by FunctionMaker on 2017/7/10.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

#import "EPCarPlateViewController.h"

#define kCellMargin 4.0f

@interface EPCarPlateViewController ()

@property (strong, nonatomic) NSArray *shortProvinceNames;
@property (strong, nonatomic) NSArray *normalWords;
@property (strong, nonatomic) NSArray *specialWords;

@property (strong, nonatomic) NSArray<UIButton *> *wordsSenders;

@end

@implementation EPCarPlateViewController {
    EPKeyboardType _keyboardType;
    EPHiddenCellsType _hiddenType;
    
    BOOL _showSpecialWords;
}

#pragma mark - Initializer

- (instancetype)initWithKeyboardType:(EPKeyboardType)type hiddenType:(EPHiddenCellsType)hiddenType {
    self = [super init];
    
    if (self) {
        _keyboardType = type;
        _hiddenType = hiddenType;
    }
    
    return self;
}

#pragma mark - View life cycle

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (_keyboardType == EPKeyboardTypeProvinceShortName) {
        CGFloat cellWidth = (CGRectGetWidth(self.inputView.frame) - 10.0f * kCellMargin) / 9.0f;
        CGFloat cellHeight = (CGRectGetHeight(self.inputView.frame) - 6.0f * kCellMargin) / 5.0f;
        
        [self.wordsSenders enumerateObjectsUsingBlock:^(UIButton * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
            NSUInteger i = idx % 9;
            NSUInteger j = idx / 9;
            
            cell.frame = CGRectMake(i * (cellWidth + kCellMargin) + kCellMargin, j * (cellHeight + kCellMargin) + kCellMargin, cellWidth, cellHeight);
            cell.titleLabel.font = [UIFont systemFontOfSize:0.3f * cellHeight];
        }];
    } else {
       __block CGFloat cellWidth = (CGRectGetWidth(self.inputView.frame) - 11.0f * kCellMargin) / 10.0f;
        CGFloat cellHeight = (CGRectGetHeight(self.inputView.frame) - 5.0f * kCellMargin) / 4.0f;
        CGFloat specialCellWidth = (CGRectGetWidth(self.inputView.frame) - 10.0f * kCellMargin) / 9.0f;
        
        [self.wordsSenders enumerateObjectsUsingBlock:^(UIButton * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > 19 && idx <= 28) {
                NSUInteger i = idx - 20;
                NSUInteger j = idx / 10;
                
                cell.frame = CGRectMake(0.5f * cellWidth + 2.0f * kCellMargin + i * (kCellMargin + cellWidth), j * (cellHeight + kCellMargin) + kCellMargin, cellWidth, cellHeight);
            } else {
                NSUInteger i;
                NSUInteger j;
                if (idx > 28) {
                    cellWidth = specialCellWidth;
                    
                    i = (idx - 2) % 9;
                    j = (idx - 2) / 9;
                } else {
                    i = idx % 10;
                    j = idx / 10;
                }
                
                cell.frame = CGRectMake(i * (cellWidth + kCellMargin) + kCellMargin, j * (cellHeight + kCellMargin) + kCellMargin, cellWidth, cellHeight);
            }
            
            cell.titleLabel.font = [UIFont systemFontOfSize:0.3f * cellHeight];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_hiddenType == EPHiddenCellsTypeNumbersAndWord) {
        for (int i = 0; i < 10; i ++) {
            [self disableCellWithCell:self.wordsSenders[i]];
        }
        
        [self disableCellWithCell:self.wordsSenders[29]];
    } else if (_hiddenType == EPHiddenCellsTypeIOAndWord) {
        [self disableCellWithCell:self.wordsSenders[29]];
        [self disableCellWithCell:self.wordsSenders[18]];
        [self disableCellWithCell:self.wordsSenders[17]];
    } else if (_hiddenType == EPHiddenCellsTypeIO) {
        [self disableCellWithCell:self.wordsSenders[18]];
        [self disableCellWithCell:self.wordsSenders[17]];
    }
    
    [self.wordsSenders enumerateObjectsUsingBlock:^(UIButton * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.inputView addSubview:cell];
    }];
}

#pragma mark - Cells Action

- (void)inputWord:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"字"]) {
        _showSpecialWords = !_showSpecialWords;
        
        for (int i = 20; i < 28; i ++) {
            if (_showSpecialWords) {
                [self.wordsSenders[i] setTitle:self.specialWords[i - 20] forState:UIControlStateNormal];
            } else {
                [self.wordsSenders[i] setTitle:self.normalWords[i] forState:UIControlStateNormal];
            }
        }
    } else {
        [self.textDocumentProxy deleteBackward];
        [self.textDocumentProxy insertText:sender.titleLabel.text];
    }
}

- (void)deleteWord:(UIButton *)sender {    
    if ([self.delegate respondsToSelector:@selector(deleteWord)]) {
        [self.delegate deleteWord];
    }
}

#pragma mark - Private

- (void)disableCellWithCell:(UIButton *)cell {
    cell.enabled = NO;
    cell.alpha = 0.5f;
}

#pragma mark - getters

- (NSArray<UIButton *> *)wordsSenders {
    if (!_wordsSenders) {
        NSMutableArray *cells;
        NSArray *titles;
        
        if (_keyboardType == EPKeyboardTypeProvinceShortName) {
             cells = [NSMutableArray arrayWithCapacity:self.shortProvinceNames.count + 1];
            titles = self.shortProvinceNames;
        } else {
            cells = [NSMutableArray arrayWithCapacity:self.normalWords.count + 1];
            titles = self.normalWords;
        }
            
        [titles enumerateObjectsUsingBlock:^(NSString *_Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *cell = [UIButton buttonWithType:UIButtonTypeSystem];
                [cell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [cell setTitle:title forState:UIControlStateNormal];
                [cell setBackgroundImage:[UIImage imageNamed:@"txt_white"] forState:UIControlStateNormal];
                [cell addTarget:self action:@selector(inputWord:) forControlEvents:UIControlEventTouchUpInside];
            
                [cells addObject:cell];
            }];
            
        UIButton *deleteCell = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteCell setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [deleteCell setImage:[UIImage imageNamed:@"txt_del"] forState:UIControlStateNormal];
        [deleteCell setBackgroundImage:[UIImage imageNamed:@"txt_white"] forState:UIControlStateNormal];
        [deleteCell.imageView setContentMode:UIViewContentModeCenter];
        
        [deleteCell addTarget:self action:@selector(deleteWord:) forControlEvents:UIControlEventTouchUpInside];
        
        [cells addObject:deleteCell];
            
        _wordsSenders = cells;
    }
    
    return _wordsSenders;
}

- (NSArray *)shortProvinceNames {
    if (!_shortProvinceNames) {
        _shortProvinceNames = @[@"京",@"津",@"冀",@"晋",@"蒙",@"辽",@"吉",@"黑",@"沪",@"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"粤",@"桂",@"琼",@"渝",@"川",@"贵",@"云",@"藏",@"陕",@"甘",@"青",@"宁",@"新", @"台", @"使", @"WJ", @"V", @"K", @"H", @"B", @"S", @"L", @"J", @"N", @"G", @"C"];
    }
    
    return _shortProvinceNames;
}

- (NSArray *)normalWords {
    if (!_normalWords) {
        _normalWords = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @"Q", @"W", @"E", @"R", @"T", @"Y", @"U", @"I", @"O", @"P", @"A", @"S", @"D", @"F", @"G", @"H", @"J", @"K", @"L", @"字", @"Z", @"X", @"C", @"V", @"B", @"N", @"M"];
    }
    
    return _normalWords;
}

- (NSArray *)specialWords {
    if (!_specialWords) {
        _specialWords = @[@"警", @"学", @"领", @"挂", @"港", @"澳", @"试", @"超"];
    }
    
    return _specialWords;
}

@end
