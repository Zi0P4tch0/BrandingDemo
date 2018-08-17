//
//  ViewController+ThemeOne.m
//  ThemeOne
//
//  Created by Matteo Pacini on 16/08/2018.
//  Copyright © 2018 Codecraft Limited. All rights reserved.
//

#import "ThemeOneClass.h"

#import <objc/runtime.h>

#import <UIKit/UIKit.h>

@implementation ThemeOneClass

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class viewControllerClass = NSClassFromString(@"ViewController");
        if (viewControllerClass) {
            
            // Get original viewWillAppear:
            Method viewWillAppear = class_getInstanceMethod(viewControllerClass,
                                                            @selector(viewWillAppear:));
            
            // Get its type encoding
            const char *typeEncoding = method_getTypeEncoding(viewWillAppear);
            
            // Implement themeOne_viewWillAppear:
            IMP themeOneIMP = imp_implementationWithBlock(^(id self, BOOL animated){
                
                [self performSelector:@selector(themeOne_viewWillAppear:)];
                UIViewController *selfViewController = self;
                selfViewController.view.backgroundColor = [UIColor greenColor];
                
            });
            
            // Add/replace themeOne_viewWillAppear: method at runtime on ViewController class
            if (!class_addMethod(viewControllerClass,
                                 @selector(themeOne_viewWillAppear:),
                                 themeOneIMP,
                                 typeEncoding)) {
                
                class_replaceMethod(viewControllerClass,
                                    @selector(themeOne_viewWillAppear:),
                                    themeOneIMP,
                                    typeEncoding);
                
            }
            
            // Get the newly added method
            Method swizzledViewWillAppear = class_getInstanceMethod(viewControllerClass,
                                                            @selector(themeOne_viewWillAppear:));

            
            // Swizzle methods
            method_exchangeImplementations(viewWillAppear, swizzledViewWillAppear);
            
        }
        
    });
    
}

#pragma clang diagnostic pop

@end
