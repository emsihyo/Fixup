//
//  FUComponent.m
//  Fixup iOS
//
//  Created by emsihyo on 2018/7/4.
//  Copyright © 2018年 Fixup. All rights reserved.
//

#import "FUComponent.h"

@interface FUComponent()
@property(nonatomic,copy)NSString *name;
@end

@implementation FUComponent
- (instancetype)initWithName:(NSString*)name{
    self=[super init];
    if(!self) return nil;
    self.name=name;
    return self;
}
@end
