//
//  JSValue+Fixup.h
//  Fixup
//
//  Created by emsihyo on 2018/7/5.
//  Copyright © 2018 Fixup. All rights reserved.
//

@import UIKit;

#import <JavaScriptCore/JavaScriptCore.h>

@interface JSValue (Fixup)

+ (JSValue *)valueWithEdgeInsets:(UIEdgeInsets)value inContext:(JSContext *)context;

#if TARGET_OS_IOS || TARGET_OS_TV
- (CATransform3D)toTransform3D;
+ (JSValue *)valueWithTransform3D:(CATransform3D)value inContext:(JSContext *)context;
#endif

#if TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH
- (CGVector)toVector;
- (CGAffineTransform)toAffineTransform;
- (UIOffset)toOffset;
+ (JSValue *)valueWithVector:(CGVector)value inContext:(JSContext *)context;
+ (JSValue *)valueWithAffineTransform:(CGAffineTransform)value inContext:(JSContext *)context;
+ (JSValue *)valueWithOffset:(UIOffset)value inContext:(JSContext *)context;
#endif

- (NSDirectionalEdgeInsets)toDirectionalEdgeInsets API_AVAILABLE(ios(11.0),tvos(11.0),watchos(4.0));
+ (JSValue *)valueWithDirectionalEdgeInsets:(NSDirectionalEdgeInsets)value inContext:(JSContext *)context API_AVAILABLE(ios(11.0),tvos(11.0),watchos(4.0));

@end
