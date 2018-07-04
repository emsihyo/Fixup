//
//  FUProperty.h
//  Fixup iOS
//
//  Created by emsihyo on 2018/7/4.
//  Copyright © 2018年 Fixup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface FUProperty : NSObject

@property (readonly) NSDictionary *dictionary;
@property (readonly) NSString     *propertyname;
@property (readonly) NSString     *settername;
@property (readonly) NSString     *gettername;
@property (readonly) NSString     *attributes;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithProperty:(objc_property_t)property NS_DESIGNATED_INITIALIZER;

@end
