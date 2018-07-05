//
//  ViewController.m
//  Fixup Example iOS
//
//  Created by emsihyo on 2018/7/4.
//  Copyright © 2018年 Fixup. All rights reserved.
//

@import Fixup;

#import "ViewController.h"

@interface Test :NSObject

@property (nonatomic,strong)id p;

@end

@implementation Test

+ (void)c{
    
}

- (void)i{
    
}
@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FUJSContext.shared evaluateScript:@"NSString.alloc()"];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
