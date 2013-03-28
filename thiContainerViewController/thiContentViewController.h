//
//  thiContentViewController.h
//  thiContainerViewController
//
//  Created by thi on 13-3-20.
//  Copyright (c) 2013年 thi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "thiBaseContentViewController.h"
@interface thiContentViewController : thiBaseContentViewController

@property (nonatomic, assign) int i;
@property (nonatomic, readonly) CALayer *coverLayer;

@end
