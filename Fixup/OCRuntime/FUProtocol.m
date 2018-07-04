//
//  FUProtocol.m
//  Fixup iOS
//
//  Created by emsihyo on 2018/7/4.
//  Copyright © 2018年 Fixup. All rights reserved.
//

#import "FUProtocol.h"

@interface FUProtocol()

@property (nonatomic,copy  ) NSString     *protocolname;
@property (nonatomic,strong) NSDictionary *properties;
@property (nonatomic,strong) NSDictionary *classmethods;
@property (nonatomic,strong) NSDictionary *instancemethods;

@end

@implementation FUProtocol

- (instancetype)initWithProtocol:(Protocol *)protocol{
    self=[super init];
    if (!self) return nil;
    
    return self;
}

- (NSDictionary*)dictionary{
    
    NSMutableDictionary *properties=[NSMutableDictionary dictionary];
    NSMutableDictionary *classmethods=[NSMutableDictionary dictionary];
    NSMutableDictionary *instancemethods=[NSMutableDictionary dictionary];
    
    [self.properties enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, FUProperty * _Nonnull obj, BOOL * _Nonnull stop) {
        properties[key]=[obj dictionary];
    }];
    [self.classmethods enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, FUMethod * _Nonnull obj, BOOL * _Nonnull stop) {
        classmethods[key]=[obj dictionary];
    }];
    [self.instancemethods enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, FUMethod * _Nonnull obj, BOOL * _Nonnull stop) {
        instancemethods[key]=[obj dictionary];
    }];
    return @{
             @"properties":properties,
             @"classmethods":classmethods,
             @"instancemethods":instancemethods
             };
}

@end
