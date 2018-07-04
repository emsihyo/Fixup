//
//  FUProperty.m
//  Fixup iOS
//
//  Created by emsihyo on 2018/7/4.
//  Copyright © 2018年 Fixup. All rights reserved.
//

#import "FUProperty.h"

@interface FUProperty()

@property (nonatomic,copy) NSString *propertyname;
@property (nonatomic,copy) NSString *settername;
@property (nonatomic,copy) NSString *gettername;
@property (nonatomic,copy) NSString *attributes;

@end

@implementation FUProperty

- (instancetype)initWithProperty:(objc_property_t)property{
    self=[super init];
    if(!self) return self;
    self.propertyname=[NSString stringWithUTF8String:property_getName(property)];
    self.attributes=[NSString stringWithUTF8String:property_getAttributes(property)];
    unsigned int count;
    objc_property_attribute_t *attributes = property_copyAttributeList(property, &count);
    for (unsigned int i=0;i<count;i++){
        objc_property_attribute_t attribute = attributes[i];
        switch (attribute.name[0]) {
            case 'G': {
                if (strlen(attribute.value)) self.gettername = [NSString stringWithUTF8String:attribute.value];
            } break;
            case 'S': {
                if (strlen(attribute.value)) self.settername = [NSString stringWithUTF8String:attribute.value];
            } break;
            default: break;
        }
    }
    if (!self.gettername) self.gettername=self.propertyname;
    if (!self.settername) self.settername=self.propertyname.length>1 ? [NSString stringWithFormat:@"set%@%@:",[[self.propertyname substringToIndex:1] capitalizedString],[self.propertyname substringFromIndex:1]]:[NSString stringWithFormat:@"set%@:",[self.propertyname capitalizedString]];
    return self;
}

- (NSDictionary*)dictionary{
    return @{
             @"propertyname":self.propertyname,
             @"settername":self.settername,
             @"gettername":self.gettername,
             @"attributes":self.attributes
             };
}

@end
