//
//  FUMethod.h
//  Fixup iOS
//
//  Created by emsihyo on 2018/7/4.
//  Copyright © 2018年 Fixup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface FUMethod : NSObject

@property (readonly) NSDictionary *dictionary;

@property (readonly) NSString     *methodname;
@property (readonly) NSString     *returntype;
@property (readonly) NSArray<NSString*> *argumenttypes;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithMethod:(Method)method NS_DESIGNATED_INITIALIZER;

@end
