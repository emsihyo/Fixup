//
//  FURuntime.m
//  Fixup iOS
//
//  Created by emsihyo on 2018/7/5.
//  Copyright © 2018 Fixup. All rights reserved.
//

#import <objc/runtime.h>
#import <TargetConditionals.h>

#import "FURuntime.h"
#import "JSValue+Fixup.h"

static bool processArgument(NSInvocation *invocation,JSValue *argument,const char * type,NSUInteger i){
    BOOL ret=true;
    switch (type[0]) {
        case 'v':
            NSCParameterAssert(0);
            ret=false;
            break;
        case 'B':{
            BOOL v = [[argument toNumber] boolValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'c':{
            char v = [[argument toNumber] charValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'C': {
            unsigned char v = [[argument toNumber] unsignedCharValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 's': {
            short v = [[argument toNumber] shortValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'S': {
            unsigned short v = [[argument toNumber] unsignedShortValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'i': {
            int v = [[argument toNumber] intValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'I': {
            unsigned int v = [[argument toNumber] unsignedIntValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'l': {
            long v = [[argument toNumber] longValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'L': {
            unsigned long v = [[argument toNumber] longValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'q': {
            long long v = [[argument toNumber] longLongValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'Q': {
            unsigned long long v = [[argument toNumber] unsignedLongLongValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'f': {
            float v = [[argument toNumber] floatValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'd': {
            double v = [[argument toNumber] doubleValue];
            [invocation setArgument:&v atIndex:i];
        } break;
        case 'D':  {
            long double v = [[argument toNumber] doubleValue];
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
            NSScanner *scanner = [NSScanner scannerWithString:[NSString stringWithUTF8String:type]];
            if (![scanner scanString:@"@\"" intoString:NULL]) break;
            NSString *clsName = nil;
            if (![scanner scanUpToCharactersFromSet: [NSCharacterSet characterSetWithCharactersInString:@"\"<"] intoString:&clsName]||!clsName.length) break;
            Class cls = NSClassFromString(clsName);
            if (cls==NSString.class) {
                NSString * v=[argument toString];
                [invocation setArgument:&v atIndex:i];
            }else if(cls==NSMutableString.class) {
                NSMutableString * v=[[argument toString] mutableCopy];
                [invocation setArgument:&v atIndex:i];
            } else if(cls==NSURL.class) {
                NSURL * v=[NSURL URLWithString:[argument toString]];
                [invocation setArgument:&v atIndex:i];
            } else if(cls==NSNumber.class) {
                NSNumber * v=[argument toNumber];
                [invocation setArgument:&v atIndex:i];
            } else if(cls==NSDate.class){
                NSDate * v=[argument toDate];
                [invocation setArgument:&v atIndex:i];
            } else if(cls==NSData.class){
                NSData *v = [[argument toString] dataUsingEncoding:NSISOLatin1StringEncoding];
                [invocation setArgument:&v atIndex:i];
            } else if(cls==NSMutableData.class) {
                NSMutableData *v = [[[argument toString] dataUsingEncoding:NSISOLatin1StringEncoding] mutableCopy];
                [invocation setArgument:&v atIndex:i];
            } else if(cls==NSArray.class) {
                NSArray * v = [argument toArray];
                [invocation setArgument:&v atIndex:i];
            } else if(cls==NSMutableArray.class) {
                NSMutableArray * v = [[argument toArray] mutableCopy];
                [invocation setArgument:&v atIndex:i];
            } else if(cls==NSSet.class){
                NSSet *v=[NSSet setWithArray:[argument toArray]];
                [invocation setArgument:&v atIndex:i];
            } else if(cls==NSMutableSet.class) {
                NSMutableSet *v=[[NSSet setWithArray:[argument toArray]] mutableCopy];
                [invocation setArgument:&v atIndex:i];
            } else if(cls==NSDictionary.class) {
                NSDictionary *v=[argument toDictionary];
                [invocation setArgument:&v atIndex:i];
            } else if(cls==NSMutableDictionary.class){
                NSMutableDictionary *v=[[argument toDictionary]mutableCopy];
                [invocation setArgument:&v atIndex:i];
            } else {
                NSObject *v =[argument toObject];
                [invocation setArgument:&v atIndex:i];
            }
        }
        default:
            ret=false;
            break;
    }
    return ret;
}


static JSValue * processReturn(NSInvocation *invocation,const char * returntype,JSContext *context){
    [invocation invoke];
    JSValue *returnvalue;
    switch (returntype[0]) {
        case 'v':
            NSCParameterAssert(0);
            break;
        case 'B':{
            BOOL v;
            [invocation getReturnValue:&v];
            returnvalue = [JSValue valueWithBool:v inContext:context];
        } break;
        case 'c':{
            char v;
            [invocation getReturnValue:&v];
            returnvalue = [JSValue valueWithInt32:(int)v inContext:context];
        } break;
        case 'C': {
            unsigned char v;
            [invocation getReturnValue:&v];
            returnvalue = [JSValue valueWithUInt32:(unsigned int)v inContext:context];
        } break;
        case 's': {
            short v;
            [invocation getReturnValue:&v];
            returnvalue = [JSValue valueWithInt32:(int)v inContext:context];
        } break;
        case 'S': {
            unsigned short v;
            [invocation getReturnValue:&v];
            returnvalue = [JSValue valueWithUInt32:(unsigned int)v inContext:context];
        } break;
        case 'i': {
            int v;
            [invocation getReturnValue:&v];
            returnvalue = [JSValue valueWithInt32:v inContext:context];
        } break;
        case 'I': {
            unsigned int v;
            [invocation getReturnValue:&v];
            returnvalue = [JSValue valueWithUInt32:v inContext:context];
        } break;
        case 'l': {
            long v;
            [invocation getReturnValue:&v];
            returnvalue = [JSValue valueWithObject:@(v) inContext:context];
        } break;
        case 'L': {
            unsigned long v;
            [invocation getReturnValue:&v];
            returnvalue = [JSValue valueWithObject:@(v) inContext:context];
        } break;
        case 'q': {
            long long v;
            [invocation getReturnValue:&v];
            returnvalue = [JSValue valueWithObject:@(v) inContext:context];
        } break;
        case 'Q': {
            unsigned long long v;
            [invocation getReturnValue:&v];
            returnvalue = [JSValue valueWithObject:@(v) inContext:context];
        } break;
        case 'f': {
            float v;
            [invocation getReturnValue:&v];
            returnvalue = [JSValue valueWithDouble:(double)v inContext:context];
        } break;
        case 'd': {
            double v;
            [invocation getReturnValue:&v];
            returnvalue = [JSValue valueWithDouble:v inContext:context];
        } break;
        case 'D':  {
            long double v;
            [invocation getReturnValue:&v];
            returnvalue = [JSValue valueWithDouble:(double)v inContext:context];
        } break;
        case '#': {
            Class v;
            [invocation getReturnValue:&v];
            returnvalue = [JSValue valueWithObject:v inContext:context];
        } break;
        case ':': {
            SEL v;
            [invocation getReturnValue:&v];
            returnvalue = [JSValue valueWithObject:NSStringFromSelector(v) inContext:context];
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
                NSCParameterAssert(0);
            }
        } break;
        case '*': {
            const char * v;
            [invocation getReturnValue:&v];
            NSCParameterAssert(0);
        } break;
        case '^': {
            //c point
            NSCParameterAssert(0);
        }break;
        case '[': {
            //c array
            NSCParameterAssert(0);
        } break;
        case '(': {
            //c union
            NSCParameterAssert(0);
        } break;
        case '@': {
            void * v;
            [invocation getReturnValue:&v];
            returnvalue=[JSValue valueWithObject:(__bridge id)v inContext:context];
        }
    }
    return returnvalue;
}

@protocol  FURuntimeJSExport <JSExport>

JSExportAs(__call__, - (JSValue*)callWithValue:(JSValue*)value withSelectorname:(NSString*)selectorname withArguments:(NSArray<JSValue *>*)arguments);
JSExportAs(__property__, - (JSValue*)propertyOfValue:(JSValue*)value byPropertyname:(NSString*)propertyname);

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


- (JSValue*)callWithValue:(JSValue*)value withSelectorname:(NSString*)selectorname withArguments:(NSArray<JSValue *>*)arguments{
    SEL selector=NSSelectorFromString(selectorname);
    //object or class
    id target = [value toObject];
    //class or metaclass
    Class targetclass=object_getClass(target);
   
    if (![targetclass respondsToSelector:selector]) return [JSValue valueWithObject:nil inContext:self.context];
    
    NSMethodSignature *signature=[target methodSignatureForSelector:selector];
    NSInvocation *invocation=[NSInvocation invocationWithMethodSignature:signature];
    invocation.target=target;
    invocation.selector=selector;
    NSUInteger count = signature.numberOfArguments;
    for (NSUInteger i=2;i<count;i++){
        const char * argumenttype = [signature getArgumentTypeAtIndex:i];
        JSValue * argumentvalue = [arguments objectAtIndex:i];
        if(!processArgument(invocation, argumentvalue, argumenttype, i-2)){
            NSParameterAssert(0);
        }
    }
    const char * returntype=signature.methodReturnType;
    return processReturn(invocation, returntype,self.context);
}

- (JSValue*)propertyOfValue:(JSValue*)value byPropertyname:(NSString*)propertyname{
    if (propertyname.length==0) return [JSValue valueWithObject:nil inContext:self.context];
    //1.context property,duplicated,do not work
     JSValue *ret=value[propertyname];
    if (![ret isNull]&&![ret isUndefined]) return ret;
    //2.class
    NSString *classname=propertyname;
    Class cls=NSClassFromString(classname);
    if (cls)return [JSValue valueWithObject:cls inContext:self.context];
    return [JSValue valueWithObject:nil inContext:self.context];
}

@end
