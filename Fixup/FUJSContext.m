//
//  FUJSContext.m
//  Fixup iOS
//
//  Created by emsihyo on 2018/7/4.
//  Copyright © 2018年 Fixup. All rights reserved.
//

#import "FUClass.h"
#import "FUConsole.h"
#import "FUJSContext.h"

@interface FUJSContext()

@property (nonatomic,copy)NSString *script;
@property (nonatomic,strong)NSMutableDictionary *classmap;
@property (nonatomic,strong)NSDictionary        *blocks;

@end

@implementation FUJSContext

+ (FUJSContext*)shared{
    static FUJSContext *shared; static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ shared=[[FUJSContext alloc]init]; });
    return shared;
}

- (JSValue*)evaluateScript:(NSString *)script{
    self.script=script;
    return [super evaluateScript:script];
}

- (instancetype)init{
    self=[super init];
    if (!self) return nil;
    self.classmap=[NSMutableDictionary dictionary];
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex=[NSRegularExpression regularExpressionWithPattern:@"Can't\\sfind\\svariable:\\s([^\\s]*)" options:0 error:nil];
    });
    self.exceptionHandler = ^(JSContext *_context, JSValue *exception) {
        FUJSContext *context=(FUJSContext*)_context;
        NSLog(@"\nexception:\n%@\n%@\n javascript:\n%@\n",[exception toString],[exception toDictionary],[context script]);
        NSString *e=[exception toString];
        NSArray * results=[regex matchesInString:e options:0 range:NSMakeRange(0, e.length)];
        for (NSTextCheckingResult *result in results){
            if ([result numberOfRanges]<2) break;
            NSString *classname=[e substringWithRange:[result rangeAtIndex:1]];
            Class cls=NSClassFromString(classname);
            if (!cls) break;
            [context registerClass:cls forJSName:classname];
            [context evaluateScript:context.script];
        }
    };
    [self loadCompnents];
    [self evaluateScript:[NSString stringWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"main" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil]];
    return self;
}

- (void)loadCompnents{
    FUConsole *console = [[FUConsole alloc]initWithName:@"console"];
    [self loadComponent:console];
}

- (void)loadComponent:(__kindof FUComponent*) component{
    self[component.name]=component;
}

- (void)registerClass:(Class)cls forJSName:(NSString*)jsname{
    FUClass *clz=[[FUClass alloc]initWithClass:cls];
    self.classmap[jsname]=clz;
    self[jsname]=[clz dictionary];
    NSString *(^processMethodname)(NSString *)=^(NSString* methodname){
        return [methodname stringByReplacingOccurrencesOfString:@":" withString:@"-"];
    };
    [clz.instancemethods enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, FUMethod * _Nonnull method, BOOL * _Nonnull stop) {
        [self[jsname] setValue:self.blocks[[method.returntype stringByAppendingString:[method.argumenttypes componentsJoinedByString:@""]]] forProperty:processMethodname(method.methodname)];
    }];
//    NSLog(@"%@",clz.dictionary);
}

@end




















