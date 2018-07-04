//
//  FUClass.m
//  Fixup iOS
//
//  Created by emsihyo on 2018/7/4.
//  Copyright © 2018年 Fixup. All rights reserved.
//

#import <objc/runtime.h>

#import "FUClass.h"

@interface FUClass ()

@property (nonatomic,copy  ) NSString     *classname;
@property (nonatomic,copy  ) NSString     *superclassname;
@property (nonatomic,strong) NSDictionary *protocols;
@property (nonatomic,strong) NSDictionary *properties;
@property (nonatomic,strong) NSDictionary *classmethods;
@property (nonatomic,strong) NSDictionary *instancemethods;

@end

@implementation FUClass

- (instancetype)initWithClass:(Class)cls{
    self=[super init];
    if(!self) return nil;
    
    self.classname = NSStringFromClass(cls);
    self.superclassname = NSStringFromClass([cls superclass]);
    self.protocols = [NSMutableDictionary dictionary];
    self.properties = [NSMutableDictionary dictionary];
    self.classmethods = [NSMutableDictionary dictionary];
    self.instancemethods = [NSMutableDictionary dictionary];

    unsigned int count;
    Protocol * __unsafe_unretained *protocols = class_copyProtocolList(cls, &count);
    for (unsigned int i=0;i<count;i++){
        Protocol *protocol = protocols[i];
        [(NSMutableDictionary*)self.protocols setObject:[[FUProtocol alloc]initWithProtocol:protocol] forKey:[NSString stringWithUTF8String:protocol_getName(protocol)]];
    }
    objc_property_t * properties = class_copyPropertyList(cls, &count);
    for (unsigned int i=0;i<count;i++){
        objc_property_t property=properties[i];
        [(NSMutableDictionary*)self.properties setObject:[[FUProperty alloc]initWithProperty:property] forKey:[NSString stringWithUTF8String:property_getName(property)]];
    }
    Method _Nonnull * methods = class_copyMethodList(cls, &count);
    for (unsigned int i=0;i<count;i++){
        Method method=methods[i];
        [(NSMutableDictionary*)self.instancemethods setObject:[[FUMethod alloc]initWithMethod:method] forKey:NSStringFromSelector(method_getName(method))];
    }
    Class metaClass=object_getClass(cls);
    if (class_isMetaClass(metaClass)){
            methods=class_copyMethodList(metaClass, &count);
            for (unsigned int i=0;i<count;i++){
                Method method=methods[i];
                [(NSMutableDictionary*)self.classmethods setObject:[[FUMethod alloc]initWithMethod:method] forKey:NSStringFromSelector(method_getName(method))];
            }
    }

    return self;
}


- (NSDictionary*)dictionary{
    
    NSMutableDictionary *protocols=[NSMutableDictionary dictionary];
    NSMutableDictionary *properties=[NSMutableDictionary dictionary];
    NSMutableDictionary *classmethods=[NSMutableDictionary dictionary];
    NSMutableDictionary *instancemethods=[NSMutableDictionary dictionary];
    
    [self.protocols enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, FUProtocol * _Nonnull obj, BOOL * _Nonnull stop) {
        protocols[key]=[obj dictionary];
    }];
    [self.properties enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, FUProperty * _Nonnull obj, BOOL * _Nonnull stop) {
        properties[key]=[obj dictionary];
    }];
    [self.classmethods enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, FUMethod * _Nonnull obj, BOOL * _Nonnull stop) {
        classmethods[key]=[obj dictionary];
    }];
    [self.instancemethods enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, FUMethod * _Nonnull obj, BOOL * _Nonnull stop) {
        instancemethods[key]=[obj dictionary];
    }];
    
    return @{
             @"__classname__":self.classname,
             @"__superclassname__":self.superclassname,
             @"__protocols__":protocols,
             @"__properties__":properties,
             @"__classmethods__":classmethods,
             @"__instancemethods__":instancemethods
             };
}

@end











