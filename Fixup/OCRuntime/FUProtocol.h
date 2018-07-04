//
//  FUProtocol.h
//  Fixup iOS
//
//  Created by emsihyo on 2018/7/4.
//  Copyright © 2018年 Fixup. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "FUMethod.h"
#import "FUProperty.h"

@interface FUProtocol : NSObject

@property (readonly) NSDictionary *dictionary;

@property (readonly) NSString     *protocolname;

@property (readonly) NSDictionary<NSString *,FUProperty *> *properties;
@property (readonly) NSDictionary<NSString *,FUMethod *>   *classmethods;
@property (readonly) NSDictionary<NSString *,FUMethod *>   *instancemethods;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithProtocol:(Protocol *)protocol NS_DESIGNATED_INITIALIZER;

@end
