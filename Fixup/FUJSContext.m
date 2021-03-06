//
//  FUJSContext.m
//  Fixup iOS
//
//  Created by emsihyo on 2018/7/4.
//  Copyright © 2018年 Fixup. All rights reserved.
//

#import "FUConsole.h"
#import "FUJSContext.h"
#import "FURuntime.h"
@interface FUJSContext()

@property (nonatomic,copy  ) NSString            *script;
@property (nonatomic,strong) NSDictionary        *blocks;

@end

@implementation FUJSContext

+ (FUJSContext*)shared{
    static FUJSContext *shared; static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ shared=[[FUJSContext alloc]init]; });
    return shared;
}

- (JSValue*)evaluateScriptWithURL:(NSURL*)url error:(NSError**)error{
    NSURL *sourceURL=[url URLByDeletingLastPathComponent];
    NSString *script=[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:error];
    return [self evaluateScript:script withSourceURL:sourceURL error:error];
}

- (JSValue*)evaluateScript:(NSString *)script{
    return [self evaluateScript:script withSourceURL:nil error:nil];
}

- (JSValue*)evaluateScript:(NSString *)script withSourceURL:(NSURL *)sourceURL{
    return [self evaluateScript:script withSourceURL:sourceURL error:nil];
}

- (JSValue*)evaluateScript:(NSString *)script withSourceURL:(NSURL *)sourceURL error:(NSError**)error{
    return [self evaluateScript:script replaceable:YES withSourceURL:sourceURL error:error];
}

- (JSValue*)evaluateScript:(NSString *)script replaceable:(BOOL)replaceable withSourceURL:(NSURL *)sourceURL  error:(NSError**)error{
    if (script.length==0) return nil;
    //replace scrpit
    if (replaceable){
        static NSRegularExpression *regexProperty;
        static NSRegularExpression *regexFunction;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            regexProperty=[NSRegularExpression regularExpressionWithPattern:@"\\s*([\\w\\$\\&]+)\\s*(?=\\.)" options:0 error:nil];
            regexFunction=[NSRegularExpression regularExpressionWithPattern:@"\\.\\s*([\\w\\$\\&]+)\\s*\\(" options:0 error:nil];
        });
        NSLog(@"%@",script);
        script = [regexProperty stringByReplacingMatchesInString:script options:0 range:NSMakeRange(0, script.length) withTemplate:@"ċȧŀŀ(\"$1\")"];
        script = [regexFunction stringByReplacingMatchesInString:script options:0 range:NSMakeRange(0, script.length) withTemplate:@"ċȧŀŀ(\"$1\")("];
        NSLog(@"%@",script);
    }
    JSContextRef contextRef = self.JSGlobalContextRef;
    JSStringRef scriptRef = JSStringCreateWithUTF8CString(script.UTF8String);
    JSStringRef sourceURLRef = NULL;
    if (sourceURL) sourceURLRef=JSStringCreateWithUTF8CString(sourceURL.absoluteString.UTF8String);
    JSValueRef exceptionRef = NULL;
    JSValueRef value = JSEvaluateScript(contextRef, scriptRef, NULL, sourceURLRef, 1, &exceptionRef);
    JSStringRelease(scriptRef);
    if (sourceURLRef) JSStringRelease(sourceURLRef);
    if (exceptionRef){
        JSValue *e=[JSValue valueWithJSValueRef:exceptionRef inContext:self];
        if (error) *error = [NSError errorWithDomain:@"JSErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n%@\n%@",[e toString],[e toDictionary]]}];
    }
    return [JSValue valueWithJSValueRef:value inContext:self];
}



- (instancetype)init{
    self=[super init];
    if (!self) return nil;
//    [self evaluateScript:@"(function(){\
//     Object.defineProperty(Object.prototype, 'Ċạḷḷ', {value: function(){\
//        //property name or method name\
//        var name = arguments[0]\
//        console.log('property js '+'name:'+name)\
//        if (this.hasOwnProperty(name)) return this.name\
//            //get property value outside virtual machine\
//            console.log('property oc '+'name:'+name)\
//            var property = $.__property__(this,name)\
//            if (property!=null && typeof(property)!='undefined') return property\
//                console.log('function '+'name:'+name)\
//                //call method outside virtual machine\
//                var target = this\
//                return function(){\
//                    return $.__call__(target,name,Array.prototype.slice.call(arguments))\
//                }\
//    }})\
//     })()" replaceable:NO withSourceURL:nil error:nil];
    self[@"ṆẠṬỊṾẸ"]=[[FURuntime alloc]initWithContext:self];
    self[@"console"]=[[FUConsole alloc]init];
    NSURL *sourceURL=[[[NSBundle bundleForClass:self.class] URLForResource:@"main" withExtension:@"js"] URLByDeletingLastPathComponent];
    NSString *script=[NSString stringWithContentsOfURL:[[NSBundle bundleForClass:self.class] URLForResource:@"main" withExtension:@"js"] encoding:NSUTF8StringEncoding error:nil];
    NSError *error;
    [self evaluateScript:script replaceable:NO withSourceURL:sourceURL error:&error];
    if (error) NSLog(@"%@",error.localizedDescription);
    return self;
}


@end




















