//
//  FURuntime.h
//  Fixup iOS
//
//  Created by emsihyo on 2018/7/5.
//  Copyright © 2018 Fixup. All rights reserved.
//

@import JavaScriptCore;

#if TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH

#import <UIKit/UIKit.h>

typedef CGPoint NSPoint;
typedef CGSize NSSize;
typedef CGRect NSRect;
typedef UIEdgeInsets NSEdgeInsets;

#endif

#import <Foundation/Foundation.h>

@interface FURuntime : NSObject

@property(nonatomic,weak)JSContext *context;

@end
