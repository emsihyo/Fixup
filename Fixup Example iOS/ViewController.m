//
//  ViewController.m
//  Fixup Example iOS
//
//  Created by emsihyo on 2018/7/4.
//  Copyright © 2018年 Fixup. All rights reserved.
//

@import Fixup;

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSError *error;
    [FUJSContext.shared evaluateScript:@"var b = NSString.alloc().initWithString&('bca');var c = b + 'haha'; if(typeof b==='string'){ console.log(b) }" withSourceURL:nil error:&error];
    if (error){
        NSLog(@"%@",error.localizedDescription);
    }
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
