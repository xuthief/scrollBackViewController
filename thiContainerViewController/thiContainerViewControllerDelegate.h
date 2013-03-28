//
//  thiContainerViewControllerDelegate.h
//  thiContainerViewController
//
//  Created by thi on 13-3-20.
//  Copyright (c) 2013年 thi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class thiBaseContentViewController;

@protocol thiContainerViewControllerDelegate <NSObject>
// if vc is not a kind of thiBaseContentViewController, you have to store the thiContainer view controller by your self
- (void)pushScrollViewController:(UIViewController*)vc animated:(BOOL)animated scrollEnabled:(BOOL)scrollEnabled;
- (void)popScrollViewController:(BOOL)animated;
- (void)popToRootViewController:(BOOL)animated;
@end
