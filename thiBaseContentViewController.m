//
//  thiBaseContentViewController.m
//  thiContainerViewController
//
//  Created by thi on 13-3-28.
//  Copyright (c) 2013年 thi. All rights reserved.
//

#import "thiBaseContentViewController.h"

@interface thiBaseContentViewController ()

@end

@implementation thiBaseContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [super dealloc];
}
@end
