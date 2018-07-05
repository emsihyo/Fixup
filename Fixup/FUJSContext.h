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

- (JSValue*)evaluateScriptWithURL:(NSURL*)url error:(NSError**)error;

- (JSValue*)evaluateScript:(NSString *)script withSourceURL:(NSURL *)sourceURL error:(NSError**)error;

@end
