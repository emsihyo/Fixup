//
//  JSValue+Fixup.m
//  Fixup
//
//  Created by emsihyo on 2018/7/5.
//  Copyright © 2018 Fixup. All rights reserved.
//

#import "JSValue+Fixup.h"

@implementation JSValue (Fixup)

+ (JSValue *)valueWithEdgeInsets:(UIEdgeInsets)value inContext:(JSContext *)context{
    return [JSValue valueWithObject:@{
                                      @"top":@(value.top),
                                      @"left":@(value.left),
                                      @"right":@(value.right),
                                      @"bottom":@(value.bottom)
                                      } inContext:context];
}

#if TARGET_OS_IOS || TARGET_OS_TV

- (CATransform3D)toTransform3D{
    CATransform3D v;
    NSDictionary *dic=[self toDictionary];
    v.m11=[dic[@"m11"] doubleValue];
    v.m12=[dic[@"m12"] doubleValue];
    v.m13=[dic[@"m13"] doubleValue];
    v.m14=[dic[@"m14"] doubleValue];
    v.m21=[dic[@"m21"] doubleValue];
    v.m22=[dic[@"m22"] doubleValue];
    v.m23=[dic[@"m23"] doubleValue];
    v.m24=[dic[@"m24"] doubleValue];
    v.m31=[dic[@"m31"] doubleValue];
    v.m32=[dic[@"m32"] doubleValue];
    v.m33=[dic[@"m33"] doubleValue];
    v.m34=[dic[@"m34"] doubleValue];
    v.m41=[dic[@"m41"] doubleValue];
    v.m42=[dic[@"m42"] doubleValue];
    v.m43=[dic[@"m43"] doubleValue];
    v.m44=[dic[@"m44"] doubleValue];
    return v;
}

+ (JSValue *)valueWithTransform3D:(CATransform3D)value inContext:(JSContext *)context{
    return [JSValue valueWithObject:@{
                                      @"m11":@(value.m11),
                                      @"m12":@(value.m12),
                                      @"m13":@(value.m13),
                                      @"m14":@(value.m14),
                                      @"m21":@(value.m21),
                                      @"m22":@(value.m22),
                                      @"m23":@(value.m23),
                                      @"m24":@(value.m24),
                                      @"m31":@(value.m31),
                                      @"m32":@(value.m32),
                                      @"m33":@(value.m33),
                                      @"m34":@(value.m34),
                                      @"m41":@(value.m41),
                                      @"m42":@(value.m42),
                                      @"m43":@(value.m43),
                                      @"m44":@(value.m44)
                                      } inContext:context];
}

#endif

#if TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH

- (CGVector)toVector{
    CGVector v;
    NSDictionary *dic=[self toDictionary];
    v.dx=[dic[@"dx"] doubleValue];
    v.dy=[dic[@"dy"] doubleValue];
    return v;
}

- (CGAffineTransform)toAffineTransform{
    CGAffineTransform v;
    NSDictionary *dic=[self toDictionary];
    v.a=[dic[@"a"] doubleValue];
    v.b=[dic[@"b"] doubleValue];
    v.c=[dic[@"c"] doubleValue];
    v.d=[dic[@"d"] doubleValue];
    v.tx=[dic[@"tx"] doubleValue];
    v.ty=[dic[@"ty"] doubleValue];
    return v;
}

- (UIOffset)toOffset{
    UIOffset v;
    NSDictionary *dic=[self toDictionary];
    v.horizontal=[dic[@"horizontal"] doubleValue];
    v.vertical=[dic[@"vertical"] doubleValue];
    return v;
}

+ (JSValue *)valueWithVector:(CGVector)value inContext:(JSContext *)context{
    return [JSValue valueWithObject:@{
                                      @"dx":@(value.dx),
                                      @"dy":@(value.dy)
                                      } inContext:context];
}

+ (JSValue *)valueWithAffineTransform:(CGAffineTransform)value inContext:(JSContext *)context{
    return [JSValue valueWithObject:@{
                                      @"a":@(value.a),
                                      @"b":@(value.b),
                                      @"c":@(value.c),
                                      @"d":@(value.d),
                                      @"tx":@(value.tx),
                                      @"ty":@(value.ty)
                                      } inContext:context];
}

+ (JSValue *)valueWithOffset:(UIOffset)value inContext:(JSContext *)context{
    return [JSValue valueWithObject:@{
                                      @"horizontal":@(value.horizontal),
                                      @"vertical":@(value.vertical)
                                      } inContext:context];
}

#endif

- (NSDirectionalEdgeInsets)toDirectionalEdgeInsets{
    NSDirectionalEdgeInsets v;
    NSDictionary *dic=[self toDictionary];
    v.top=[dic[@"top"] doubleValue];
    v.leading=[dic[@"leading"] doubleValue];
    v.trailing=[dic[@"trailing"] doubleValue];
    v.bottom=[dic[@"bottom"] doubleValue];
    return v;
}

+ (JSValue *)valueWithDirectionalEdgeInsets:(NSDirectionalEdgeInsets)value inContext:(JSContext *)context{
    return [JSValue valueWithObject:@{
                                      @"top":@(value.top),
                                      @"leading":@(value.leading),
                                      @"bottom":@(value.bottom),
                                      @"trailing":@(value.trailing),
                                      } inContext:context];
}

@end
