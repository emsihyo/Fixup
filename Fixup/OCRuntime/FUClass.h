//
//  FUClass.h
//  Fixup iOS
//
//  Created by emsihyo on 2018/7/4.
//  Copyright © 2018年 Fixup. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FUMethod.h"
#import "FUProperty.h"
#import "FUProtocol.h"

@interface FUClass : NSObject

@property (readonly) NSDictionary *dictionary;
@property (readonly) NSString     *classname;
@property (readonly) NSString     *superclassname;

@property (readonly) NSDictionary<NSString *,FUProtocol *> *protocols;
@property (readonly) NSDictionary<NSString *,FUProperty *> *properties;
@property (readonly) NSDictionary<NSString *,FUMethod *>   *classmethods;
@property (readonly) NSDictionary<NSString *,FUMethod *>   *instancemethods;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithClass:(Class)cls NS_DESIGNATED_INITIALIZER;

@end
