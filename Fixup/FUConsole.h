//
//  FUConsole.h
//  Fixup iOS
//
//  Created by emsihyo on 2018/7/4.
//  Copyright © 2018年 Fixup. All rights reserved.
//

@import Foundation;
@import JavaScriptCore;

@protocol FUConsoleJSExport <JSExport>

- (void)log:(id)arg;

@end

@interface FUConsole : NSObject<FUConsoleJSExport>

@end
