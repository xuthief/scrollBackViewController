//
//  thiContentViewController.m
//  thiContainerViewController
//
//  Created by thi on 13-3-20.
//  Copyright (c) 2013年 thi. All rights reserved.
//

#import "thiContentViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface thiContentViewController ()

@end

@implementation thiContentViewController {
    UILabel *_label;
    NSTimer *_timer;
    int _j;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)loadView {
    [super loadView];

    //self.view.backgroundColor = [UIColor colorWithRed:rand()%1000/1000.f green:rand()%1000/1000.f blue:rand()%1000/1000.f alpha:1.f];
    self.view.backgroundColor = [UIColor colorWithRed:rand()%1000/1000.f green:rand()%1000/1000.f blue:rand()%1000/1000.f alpha:1.f];

    static int i = 0;
    _i = i++;
    _label = [[UILabel alloc] initWithFrame:CGRectMake(8, 138, 100, 300)];
    _label.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:50];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = [NSString stringWithFormat:@"%d:%d", _i, _i];
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor colorWithRed:rand()%1000/1000.f green:rand()%1000/1000.f blue:rand()%1000/1000.f alpha:1.f];
    [self.view addSubview:_label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    button.frame = CGRectMake(200, 350, button.frame.size.width, button.frame.size.height);
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeInfoDark];
    button.frame = CGRectMake(200, 300, button.frame.size.width, button.frame.size.height);
    [button addTarget:self action:@selector(buttonTapped2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeInfoDark];
    button.frame = CGRectMake(200, 250, button.frame.size.width, button.frame.size.height);
    [button addTarget:self action:@selector(buttonTapped3:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    /*
     _coverLayer = [[CALayer alloc] init];
    _coverLayer.frame = CGRectMake(0, 0, 320, 548);
    _coverLayer.opacity = 0.5f;
    _coverLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:_coverLayer];
     */

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(100, 10, 200, 200)];
    scrollView.contentSize = CGSizeMake(300, 300);
    scrollView.backgroundColor = [UIColor lightGrayColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [scrollView addSubview:view];
    view.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:scrollView];
    scrollView.bounces = NO;
    [scrollView release];
    [view release];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self labelAnimate];
    _timer = [[NSTimer scheduledTimerWithTimeInterval:5.1f target:self selector:@selector(labelAnimate) userInfo:nil repeats:YES] retain];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_timer invalidate];
    [_timer release];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    NSLog(@"%s : %d", __FUNCTION__, _i);
    [super dealloc];
}
- (void)labelAnimate{
    if (1) {
        [UIView transitionWithView:_label duration:5.f options:UIViewAnimationOptionCurveEaseOut animations:^{
            //_label.layer.transform = CATransform3DMakeRotation((rand()%1000-500)/100.f, (rand()%1000-500)/500.f, (rand()%1000-500)/500.f, (rand()%1000-500)/500.f);
            _label.layer.transform = (++_j%2) ? CATransform3DMakeRotation(M_PI, 1, 0, 0):CATransform3DIdentity;
        }completion:nil];
    }
}

- (void)buttonTapped:(id)sender {
    thiContentViewController *content = [[thiContentViewController alloc] init];
    [self.thiContainerDelegate pushScrollViewController:content animated:YES scrollEnabled:YES];
    [content release];
}

- (void)buttonTapped2:(id)sender {
    [self.thiContainerDelegate popScrollViewController:YES];
}

- (void)buttonTapped3:(id)sender {
    [self.thiContainerDelegate popToRootViewController:YES];
}
@end
