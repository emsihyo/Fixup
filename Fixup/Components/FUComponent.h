//
//  FUComponent.h
//  Fixup iOS
//
//  Created by emsihyo on 2018/7/4.
//  Copyright © 2018年 Fixup. All rights reserved.
//

@import JavaScriptCore;

@interface FUComponent : NSObject

@property (readonly)NSString *name;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString*)name NS_DESIGNATED_INITIALIZER;

@end
