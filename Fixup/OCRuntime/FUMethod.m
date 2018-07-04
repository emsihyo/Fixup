//
//  FUMethod.m
//  Fixup iOS
//
//  Created by emsihyo on 2018/7/4.
//  Copyright © 2018年 Fixup. All rights reserved.
//

#import "FUMethod.h"

@interface FUMethod()

@property (nonatomic,copy  ) NSString *methodname;
@property (nonatomic,copy  ) NSString *returntype;
@property (nonatomic,strong) NSArray  *argumenttypes;

@end

@implementation FUMethod

- (instancetype)initWithMethod:(Method)method{
    self=[super init];
    if (!self) return nil;
    self.argumenttypes=[NSMutableArray array];
    self.methodname=NSStringFromSelector(method_getName(method));
    char returntype[256];
    method_getReturnType(method, returntype, 256);
    self.returntype=[NSString stringWithUTF8String:returntype];
    int count = method_getNumberOfArguments(method);
    for (int i=0;i<count;i++){
        char argumenttype[256];
        method_getArgumentType(method, i, argumenttype, 256);
        [(NSMutableArray*)self.argumenttypes addObject:[NSString stringWithUTF8String:argumenttype]];
    }
    return self;
}

- (NSDictionary*)dictionary{
    return @{
             @"methodname":self.methodname,
             @"returntype":self.returntype,
             @"argumenttypes":self.argumenttypes
             };
}

@end
