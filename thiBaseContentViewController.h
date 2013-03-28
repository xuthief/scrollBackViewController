//
//  thiBaseContentViewController.h
//  thiContainerViewController
//
//  Created by thi on 13-3-28.
//  Copyright (c) 2013年 thi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "thiContainerViewControllerDelegate.h"

@interface thiBaseContentViewController : UIViewController
@property (nonatomic, assign) id<thiContainerViewControllerDelegate> thiContainerDelegate;
@end
