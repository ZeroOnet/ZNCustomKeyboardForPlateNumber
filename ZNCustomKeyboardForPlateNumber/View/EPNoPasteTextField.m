//
//  EPNoPasteTextField.m
//  ZNCustomKeyboardForPlateNumber
//
//  Created by FunctionMaker on 2017/7/12.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

#import "EPNoPasteTextField.h"

@implementation EPNoPasteTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(paste:) || action == @selector(select:) || action == @selector(selectAll:)) {
        return NO;
    } else {
        return [super canPerformAction:action withSender:sender];
    }
}
@end
