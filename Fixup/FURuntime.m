//
//  FURuntime.m
//  Fixup iOS
//
//  Created by emsihyo on 2018/7/5.
//  Copyright © 2018 Fixup. All rights reserved.
//

#import <objc/message.h>
#import <objc/runtime.h>
#import <TargetConditionals.h>

#import "FURuntime.h"
#import "JSValue+Fixup.h"


static bool processArgument(NSInvocation *invocation,id argument,const char * type,NSUInteger i){
    BOOL ret=true;
    switch (type[0]) {
        case 'v':
            NSCParameterAssert(0);
            ret=false;
            break;
        case 'B':{
            BOOL v = [argument boolValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'c':{
            char v = [argument charValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'C': {
            unsigned char v = [argument unsignedCharValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 's': {
            short v = [argument  shortValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'S': {
            unsigned short v = [argument unsignedShortValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'i': {
            int v = [argument intValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'I': {
            unsigned int v = [argument unsignedIntValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'l': {
            long v = [argument longValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'L': {
            unsigned long v = [argument longValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'q': {
            long long v = [argument longLongValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'Q': {
            unsigned long long v = [argument unsignedLongLongValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'f': {
            float v = [argument floatValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'd': {
            double v = [argument doubleValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'D':  {
            long double v = [argument doubleValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case '#': {
            Class v = [argument toObject];
            [invocation setArgument:&v atIndex:i];
        } break;
        case ':': {
            SEL v = NSSelectorFromString([argument toString]);
            [invocation setArgument:&v atIndex:i];
        } break;
        case '{': {
            char * v;
            if(strcmp(v,@encode(NSRange))==0) {
                NSRange v = [argument toRange];
                [invocation setArgument:&v atIndex:i];
            }else if(strcmp(v,@encode(NSPoint))==0) {
                NSPoint v = [argument toPoint];
                [invocation setArgument:&v atIndex:i];
            }else if(strcmp(v,@encode(NSSize))==0) {
                NSSize v = [argument toSize];
                [invocation setArgument:&v atIndex:i];
            }else if(strcmp(v,@encode(NSRect))==0) {
                NSRect v = [argument toRect];
                [invocation setArgument:&v atIndex:i];
            }else if(strcmp(v,@encode(NSEdgeInsets))==0) {
                NSRect v = [argument toRect];
                [invocation setArgument:&v atIndex:i];
            }
#if TARGET_OS_IOS || TARGET_OS_TV
            else if(strcmp(v,@encode(CATransform3D))==0) {
                CATransform3D v = [argument toTransform3D];
                [invocation setArgument:&v atIndex:i];
            }
#endif
#if TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH
            else if(strcmp(v,@encode(CGVector))==0) {
                CGVector v = [argument toVector];
                [invocation setArgument:&v atIndex:i];
            }else if(strcmp(v,@encode(CGAffineTransform))==0) {
                CGAffineTransform v = [argument toAffineTransform];
                [invocation setArgument:&v atIndex:i];
            }else if(strcmp(v,@encode(UIOffset))==0) {
                UIOffset v = [argument toOffset];
                [invocation setArgument:&v atIndex:i];
            }
#endif
            else{
#if TARGET_OS_IOS
                if (@available(iOS 11.0, *)) {
                    if(strcmp(v,@encode(NSDirectionalEdgeInsets))==0){
                        NSDirectionalEdgeInsets v = [argument toDirectionalEdgeInsets];
                        [invocation setArgument:&v atIndex:i];
                        break;
                    }
                }
#endif
                
#if TARGET_OS_TV
                if (@available(tvOS 11.0, *)) {
                    if(strcmp(v,@encode(NSDirectionalEdgeInsets))==0){
                        NSDirectionalEdgeInsets v = [argument toDirectionalEdgeInsets];
                        [invocation setArgument:&v atIndex:i];
                        break;
                    }
                }
#endif
#if TARGET_OS_WATCH
                if (@available(watchOS 4.0, *)) {
                    if(strcmp(v,@encode(NSDirectionalEdgeInsets))==0){
                        NSDirectionalEdgeInsets v = [argument toDirectionalEdgeInsets];
                        [invocation setArgument:&v atIndex:i];
                        break;
                    }
                }
#endif
                NSCParameterAssert(0);
            }
        } break;
        case '*': {
            const char * v =[[argument toString] UTF8String];
            [invocation setArgument:&v atIndex:i];
        } break;
        case '^': {
            //c point
            NSCParameterAssert(0);
            ret=false;
        }break;
        case '[': {
            //c array
            NSCParameterAssert(0);
            ret=false;
        } break;
        case '(': {
            //c union
            NSCParameterAssert(0);
            ret=false;
        } break;
        case '@': {
            if (strlen(type)==3&&type[2] =='?'){
                NSCParameterAssert(0);
                ret=false;
                break;
            }
            if ([argument isKindOfClass:JSValue.class]){
                argument=[argument toObject];
            }
            [invocation setArgument:&argument atIndex:i];
        }break;
        default:
            ret=false;
            break;
    }
    return ret;
}


static id processReturn(NSInvocation *invocation,const char * returntype,NSUInteger returnlength,JSContext *context){
    id returnvalue=nil;
    switch (returntype[0]) {
        case 'v':
            break;
        case 'B':{
            BOOL v;
            [invocation getReturnValue:&v];
            returnvalue = @(v);
        } break;
        case 'c':{
            char v;
            [invocation getReturnValue:&v];
            returnvalue = @(v);
        } break;
        case 'C': {
            unsigned char v;
            [invocation getReturnValue:&v];
            returnvalue = @(v);
        } break;
        case 's': {
            short v;
            [invocation getReturnValue:&v];
            returnvalue = @(v);
        } break;
        case 'S': {
            unsigned short v;
            [invocation getReturnValue:&v];
            returnvalue = @(v);
        } break;
        case 'i': {
            int v;
            [invocation getReturnValue:&v];
            returnvalue = @(v);
        } break;
        case 'I': {
            unsigned int v;
            [invocation getReturnValue:&v];
            returnvalue = @(v);
        } break;
        case 'l': {
            long v;
            [invocation getReturnValue:&v];
            returnvalue = @(v);
        } break;
        case 'L': {
            unsigned long v;
            [invocation getReturnValue:&v];
            returnvalue = @(v);
        } break;
        case 'q': {
            long long v;
            [invocation getReturnValue:&v];
            returnvalue = @(v);
        } break;
        case 'Q': {
            unsigned long long v;
            [invocation getReturnValue:&v];
            returnvalue = @(v);
        } break;
        case 'f': {
            float v;
            [invocation getReturnValue:&v];
            returnvalue = @(v);
        } break;
        case 'd': {
            double v;
            [invocation getReturnValue:&v];
            returnvalue = @(v);
        } break;
        case 'D':  {
            long double v;
            [invocation getReturnValue:&v];
            returnvalue = @((double)v);
        } break;
        case '#': {
            Class v;
            [invocation getReturnValue:&v];
            returnvalue = v;
        } break;
        case ':': {
            SEL v;
            [invocation getReturnValue:&v];
            returnvalue = NSStringFromSelector(v);
        } break;
        case '{': {
            char * v;
            if(strcmp(v,@encode(NSRange))==0) {
                NSRange v;
                [invocation getReturnValue:&v];
                returnvalue = [JSValue valueWithRange:v inContext:context];
            }else if(strcmp(v,@encode(NSPoint))==0) {
                NSPoint v;
                [invocation getReturnValue:&v];
                returnvalue = [JSValue valueWithPoint:v inContext:context];
            }else if(strcmp(v,@encode(NSSize))==0) {
                NSSize v;
                [invocation getReturnValue:&v];
                returnvalue = [JSValue valueWithSize:v inContext:context];
            }else if(strcmp(v,@encode(NSRect))==0) {
                NSRect v;
                [invocation getReturnValue:&v];
                returnvalue = [JSValue valueWithRect:v inContext:context];
            }else if(strcmp(v,@encode(NSEdgeInsets))==0) {
                NSEdgeInsets v;
                [invocation getReturnValue:&v];
                returnvalue = [JSValue valueWithEdgeInsets:v inContext:context];
            }
#if TARGET_OS_IOS || TARGET_OS_TV
            else if(strcmp(v,@encode(CATransform3D))==0) {
                CATransform3D v;
                [invocation getReturnValue:&v];
                returnvalue = [JSValue valueWithTransform3D:v inContext:context];
            }
#endif
#if TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH
            else if(strcmp(v,@encode(CGVector))==0) {
                CGVector v;
                [invocation getReturnValue:&v];
                returnvalue = [JSValue valueWithVector:v inContext:context];
            }else if(strcmp(v,@encode(CGAffineTransform))==0) {
                CGAffineTransform v;
                [invocation getReturnValue:&v];
                returnvalue = [JSValue valueWithAffineTransform:v inContext:context];
            }else if(strcmp(v,@encode(UIOffset))==0) {
                UIOffset v;
                [invocation getReturnValue:&v];
                returnvalue = [JSValue valueWithOffset:v inContext:context];
            }
#endif
            else{
#if TARGET_OS_IOS
                if (@available(iOS 11.0, *)) {
                    if(strcmp(v,@encode(NSDirectionalEdgeInsets))==0){
                        NSDirectionalEdgeInsets v;
                        [invocation getReturnValue:&v];
                        returnvalue = [JSValue valueWithDirectionalEdgeInsets:v inContext:context];
                        break;
                    }
                }
#endif
                
#if TARGET_OS_TV
                if (@available(tvOS 11.0, *)) {
                    if(strcmp(v,@encode(NSDirectionalEdgeInsets))==0){
                        NSDirectionalEdgeInsets v;
                        [invocation getReturnValue:&v];
                        returnvalue = [JSValue valueWithDirectionalEdgeInsets:v inContext:context];
                        break;
                    }
                }
#endif
#if TARGET_OS_WATCH
                if (@available(watchOS 4.0, *)) {
                    if(strcmp(v,@encode(NSDirectionalEdgeInsets))==0){
                        NSDirectionalEdgeInsets v;
                        [invocation getReturnValue:&v];
                        returnvalue = [JSValue valueWithDirectionalEdgeInsets:v inContext:context];
                        break;
                    }
                }
#endif
                void * v=malloc(returnlength);
                [invocation getReturnValue:v];
                returnvalue=[NSValue valueWithBytes:v objCType:v];
                free(v);
                NSCParameterAssert(0);
            }
        } break;
        case '*': {
            //char *
            const char * v;
            [invocation getReturnValue:&v];
            NSCParameterAssert(0);
        } break;
        case '^': {
            //c point
            void * v;
            [invocation getReturnValue:&v];
            returnvalue=[NSValue valueWithPointer:v];
            NSCParameterAssert(0);
        }break;
        case '[': {
            //c array
            void * v=malloc(returnlength);
            [invocation getReturnValue:v];
            returnvalue=[NSData dataWithBytes:v length:returnlength];
            free(v);
            NSCParameterAssert(0);
        } break;
        case '(': {
            //c union
            void * v=malloc(returnlength);
            [invocation getReturnValue:v];
            returnvalue=[NSData dataWithBytes:v length:returnlength];
            free(v);
            NSCParameterAssert(0);
        } break;
        case '@': {
            void * v;
            [invocation getReturnValue:&v];
            returnvalue=(__bridge id)v;
        }
    }
    return returnvalue;
}

@protocol  FURuntimeJSExport <JSExport>

JSExportAs(call, - (id)callWithValue:(id)value withSelectorname:(NSString*)selectorname withArguments:(NSArray*)arguments);
JSExportAs(property, - (id)propertyOfValue:(id)value byPropertyname:(NSString*)propertyname);

@end

@interface FURuntime() <FURuntimeJSExport>

@property (nonatomic,strong) NSMapTable           *caches;
@property (nonatomic,strong) dispatch_semaphore_t semaphore;

@end

@implementation FURuntime
- (instancetype)initWithContext:(JSContext*)context{
    self=[super init];
    if (!self) return nil;
    self.context=context;
    self.caches=[NSMapTable weakToStrongObjectsMapTable];
    self.semaphore=dispatch_semaphore_create(1);
    return self;
}


- (id)callWithValue:(id)value withSelectorname:(NSString*)selectorname withArguments:(NSArray*)arguments{
    selectorname=[selectorname stringByReplacingOccurrencesOfString:@"&" withString:@":"];
    id target;
    NSMethodSignature *signature;
    SEL selector=NSSelectorFromString(selectorname);
    if ([selectorname hasPrefix:@"alloc"]){
        return value;
    }else if([selectorname hasPrefix:@"init"]){
        Class cls=value;
        target = [cls alloc];
        void * voidTarget = (__bridge void *)target;
        target = (__bridge_transfer id)voidTarget;
        signature = [cls instanceMethodSignatureForSelector:selector];
    }else{
        target = value;
        signature=[target methodSignatureForSelector:selector];
    }
    if (!target||!signature||!selector) return nil;
    NSInvocation *invocation=[NSInvocation invocationWithMethodSignature:signature];
    invocation.target=target;
    invocation.selector=selector;
    NSUInteger count = signature.numberOfArguments;
    for (NSUInteger i=2;i<count;i++){
        const char * argumenttype = [signature getArgumentTypeAtIndex:i];
        id argumentvalue = [arguments objectAtIndex:i-2];
        if(!processArgument(invocation, argumentvalue, argumenttype, i)){
            NSParameterAssert(0);
            return nil;
        }
    }
    NSUInteger returnlength=signature.methodReturnLength;
    const char * returntype=signature.methodReturnType;
    [invocation invoke];
    return processReturn(invocation, returntype,returnlength,self.context);
}

- (id)propertyOfValue:(id)value byPropertyname:(NSString*)propertyname{
    if (propertyname.length==0) return nil;
    NSString *classname=propertyname;
    Class cls=NSClassFromString(classname);
    if (cls)return cls;
    return nil;
}

@end
