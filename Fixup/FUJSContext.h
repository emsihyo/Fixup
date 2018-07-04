//
//  FUJSContext.h
//  Fixup iOS
//
//  Created by emsihyo on 2018/7/4.
//  Copyright © 2018年 Fixup. All rights reserved.
//

@import JavaScriptCore;

@interface FUJSContext : JSContext

@property(class,readonly)FUJSContext *shared;

- (void)registerClass:(Class)cls forJSName:(NSString*)jsname;

@end
