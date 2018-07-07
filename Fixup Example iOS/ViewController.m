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
//    [FUJSContext.shared evaluateScript:@"var b = 'cc';var c =Ċạḷḷ('b').();" withSourceURL:nil error:&error];
    
//    [FUJSContext.shared evaluateScript:@"var s = ċȧŀŀ('NSString').ċȧŀŀ('alloc')().ċȧŀŀ('initWithString&')('hello');var ss = ċȧŀŀ('s').ċȧŀŀ('stringByAppendingString&')(' world');" replaceable:NO withSourceURL:nil error:&error];
//    [FUJSContext.shared evaluateScript:@"var s = $('NSString').$('alloc')().$('initWithString&')('hello');s = s+' world';console.log(s);s = s.$('stringByAppendingString&')(' every one.');console.log(s);" replaceable:NO withSourceURL:nil error:&error];
    
    [FUJSContext.shared evaluateScript:@"var s = 'hello world';console.log(s);s = s.$('stringByAppendingString&')(' every one.');console.log(s);" replaceable:NO withSourceURL:nil error:&error];


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
