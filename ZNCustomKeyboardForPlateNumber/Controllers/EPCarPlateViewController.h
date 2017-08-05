//
//  EPCarPlateViewController.h
//  ZNCustomKeyboardForPlateNumber
//
//  Created by FunctionMaker on 2017/7/10.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EPKeyboardType) {
    EPKeyboardTypeProvinceShortName,
    EPKeyboardTypeNumberAndLetter
};

typedef NS_ENUM(NSInteger, EPHiddenCellsType) {
    EPHiddenCellsTypeNumbersAndWord = 1,
    EPHiddenCellsTypeIOAndWord,
    EPHiddenCellsTypeIO
};

@protocol EPKeyboardDeleteWord <NSObject>

- (void)deleteWord;

@end

@interface EPCarPlateViewController : UIInputViewController

@property (weak, nonatomic) id<EPKeyboardDeleteWord> delegate;

- (instancetype)initWithKeyboardType:(EPKeyboardType)type hiddenType:(EPHiddenCellsType)hiddenType;

@end
