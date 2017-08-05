//
//  ViewController.m
//  ZNCustomKeyboardForPlateNumber
//
//  Created by FunctionMaker on 2017/7/8.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

#import "ViewController.h"
#import "EPAddCarViewController.h"

@interface ViewController () <EPAddCar>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addCar:(UIButton *)sender {
    EPAddCarViewController *epaAddCarVC = [[EPAddCarViewController alloc] init];
    epaAddCarVC.delegate = self;
    
    [self.navigationController pushViewController:epaAddCarVC animated:YES];
}

- (void)aNewCarWithPlateNumber:(NSString *)plateNumber {
    NSLog(@"new car plate number:%@", plateNumber);
}

@end
