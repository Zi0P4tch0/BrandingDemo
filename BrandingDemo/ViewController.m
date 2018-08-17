//
//  ViewController.m
//  BrandingDemo
//
//  Created by Matteo Pacini on 16/08/2018.
//  Copyright © 2018 Codecraft Limited. All rights reserved.
//

#import "ViewController.h"

#import <objc/runtime.h>

@interface ViewController ()

@property (assign, nonatomic) BOOL shouldSetConstraints;

@property (strong, nonatomic) UIButton *themeOneButton;

@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shouldSetConstraints = YES;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    self.themeOneButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.themeOneButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.themeOneButton setTitle:@"Toggle Theme One" forState:UIControlStateNormal];
    [self.themeOneButton addTarget:self
                            action:@selector(themeOneButtonHasBeenPressed:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.themeOneButton];
    
    
}

- (void)themeOneButtonHasBeenPressed:(id)sender {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ThemeOne"
                                         withExtension:@"framework"];
    NSBundle *themeOneBundle = [NSBundle bundleWithURL:url];
    
    if (!NSClassFromString(@"ThemeOneClass")) {
        [themeOneBundle load];
    } else {
        [themeOneBundle unload];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        Method lhs = class_getInstanceMethod([self class], @selector(viewWillAppear:));
        Method rhs = class_getInstanceMethod([self class], @selector(themeOne_viewWillAppear:));
#pragma clang diagnostic pop
        method_exchangeImplementations(lhs, rhs);
        
    }
    
    [self presentViewController:[ViewController new] animated:YES completion:nil];
}

- (void)viewSafeAreaInsetsDidChange {
    
    [super viewSafeAreaInsetsDidChange];
    
    if (self.shouldSetConstraints) {
        
        [NSLayoutConstraint constraintWithItem:self.themeOneButton
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeCenterX
                                    multiplier:1.f
                                      constant:0.f].active = YES;
        
        [NSLayoutConstraint constraintWithItem:self.themeOneButton
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view.safeAreaLayoutGuide
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.f
                                      constant:16].active = YES;
        
        self.shouldSetConstraints = NO;
        
    }
    
}

@end
