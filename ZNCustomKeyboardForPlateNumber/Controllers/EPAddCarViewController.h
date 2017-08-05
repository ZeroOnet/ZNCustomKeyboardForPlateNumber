//
//  EPAddCarViewController.h
//  ZNCustomKeyboardForPlateNumber
//
//  Created by FunctionMaker on 2017/7/8.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

#include <UIKit/UIKit.h>

@protocol EPAddCar <NSObject>

- (void)aNewCarWithPlateNumber:(NSString *)plateNumber;

@end

@interface EPAddCarViewController : UIViewController

@property (weak, nonatomic) id<EPAddCar> delegate;

@end
