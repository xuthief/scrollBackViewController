//
//  thiContainerViewController.m
//  thiContainerViewController
//
//  Created by thi on 13-3-20.
//  Copyright (c) 2013年 thi. All rights reserved.
//

#import "thiContainerViewController.h"
#import "thiBaseContentViewController.h"
#import <QuartzCore/QuartzCore.h>

#define MAIN_SCREEN_BOUNDS ([UIScreen mainScreen].bounds)
#define MAIN_APP_FRAME ([UIScreen mainScreen].applicationFrame)

#define kPUSH_VIEW_TIME_LINE_TYPE (UIViewAnimationOptionCurveEaseOut)   //begin fast, then slow
#define kPOP_VIEW_TIME_LINE_TYPE (UIViewAnimationOptionCurveEaseIn)     //begin slow, then fast

#define MAX_COVER_ALPHA (.6f)
#define MIN_VIEW_TRANS_SCALE (.960f)
#define MAX_DURATION (.2f)
#define MIN_DURATION (.1f)

@interface thiContainerViewController ()

@end

@implementation thiContainerViewController {
    UIViewController *_lastVC;
    UIViewController *_curVC;
    UIView *_curCoverView;
    NSMutableArray *_viewControllers;
    NSMutableArray *_coverViews;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - life circle
- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
    if (!_viewControllers) {
        _viewControllers = [[NSMutableArray alloc] init];
        _coverViews = [[NSMutableArray alloc] init];
    }
}

- (void)dealloc {
    [_viewControllers release];
    [_coverViews release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [_curVC beginAppearanceTransition:YES animated:animated];
    [_lastVC beginAppearanceTransition:YES animated:animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    [_curVC endAppearanceTransition];
    [_lastVC endAppearanceTransition];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [_lastVC beginAppearanceTransition:NO animated:animated];
    [_curVC beginAppearanceTransition:NO animated:animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [_lastVC endAppearanceTransition];
    [_curVC endAppearanceTransition];
}

//do not forawrd appearance methods
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

#pragma mark - push/pop scroll view controller
- (void)pushScrollViewController:(UIViewController*)vc animated:(BOOL)animated scrollEnabled:(BOOL)scrollEnabled {
    if (!self.view) {
        return;
    }
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:MAIN_SCREEN_BOUNDS];
    scrollView.backgroundColor = [UIColor colorWithWhite:.0f alpha:.0f];
    scrollView.contentSize = CGSizeMake(2*MAIN_SCREEN_BOUNDS.size.width, MAIN_SCREEN_BOUNDS.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    scrollView.scrollEnabled = scrollEnabled;
    
    vc.view.frame = CGRectMake(MAIN_SCREEN_BOUNDS.size.width, 0, MAIN_SCREEN_BOUNDS.size.width, MAIN_APP_FRAME.size.height);
    //set shadown for vc view
    CGPathRef shadowPath = CGPathCreateWithRect(vc.view.bounds, nil);
    vc.view.layer.shadowPath = shadowPath;
    CGPathRelease(shadowPath);
    vc.view.layer.shadowOffset = CGSizeMake(-4.f, 0);
    vc.view.layer.shadowRadius = 5.f;
    vc.view.layer.shadowOpacity = .35f;
    vc.view.clipsToBounds = NO;
    
    vc.view.layer.anchorPoint = CGPointMake(.5f*MAIN_APP_FRAME.size.height/MAIN_SCREEN_BOUNDS.size.width, .5f);
    vc.view.layer.position = CGPointMake(MAIN_SCREEN_BOUNDS.size.width+ .5f*MAIN_APP_FRAME.size.height, .5f*MAIN_APP_FRAME.size.height);
    
    //cover view
    _curCoverView = [[UIView alloc] initWithFrame:MAIN_SCREEN_BOUNDS];
    _curCoverView.backgroundColor = [UIColor blackColor];
    _curCoverView.alpha = 0;
    [scrollView addSubview:_curCoverView];

    [self addChildViewController:vc];
    [self.view addSubview:scrollView];
    [vc beginAppearanceTransition:YES animated:animated];
    [scrollView addSubview:vc.view];
    [vc endAppearanceTransition];
    [vc didMoveToParentViewController:self];
    
    [_viewControllers addObject:vc];
    [_coverViews addObject:_curCoverView];

    if (_lastVC) {
        //remove last view to reduce views in window
        [_lastVC beginAppearanceTransition:NO animated:NO];
        [_lastVC.view.superview removeFromSuperview];
        [_lastVC endAppearanceTransition];
    }
    _lastVC = _curVC;
    _curVC = [vc retain];;
    if ([_curVC isKindOfClass:[thiBaseContentViewController class]]) {
        ((thiBaseContentViewController*)vc).thiContainerDelegate = self;
    }
    
    if (animated) {
        CGFloat duration = MIN_DURATION + MAX_DURATION*(MAIN_SCREEN_BOUNDS.size.width-scrollView.contentOffset.x)/MAIN_SCREEN_BOUNDS.size.width;
        [UIView transitionWithView:scrollView duration:duration options:kPUSH_VIEW_TIME_LINE_TYPE animations:^{
            scrollView.contentOffset = CGPointMake(MAIN_SCREEN_BOUNDS.size.width, 0);
        }completion:nil];
    } else {
        scrollView.contentOffset = CGPointMake(MAIN_SCREEN_BOUNDS.size.width, 0);
    }
}

- (void)popScrollViewController:(BOOL)animated {
    if (_curVC) {
        if (animated) {
            UIScrollView *scrollView = (UIScrollView*)_curVC.view.superview;
            CGFloat duration = MIN_DURATION + MAX_DURATION*scrollView.contentOffset.x/MAIN_SCREEN_BOUNDS.size.width;
            [UIView transitionWithView:scrollView duration:duration options:kPOP_VIEW_TIME_LINE_TYPE animations:^{
                scrollView.contentOffset = CGPointMake(0, 0);
            }completion:^(BOOL com){
                [self doPopScrollViewController:YES];
            }];
        } else {
            [self doPopScrollViewController:NO];
        }
    }
}

- (void)doPopScrollViewController:(BOOL)animated {
    _curCoverView.alpha = 0;
    _lastVC.view.layer.transform = CATransform3DIdentity;
    
    UIScrollView *scrollView = (UIScrollView*)_curVC.view.superview;

    [_curVC willMoveToParentViewController:nil];
    [_curVC beginAppearanceTransition:NO animated:animated];
    [_curVC.view removeFromSuperview];
    [_curVC endAppearanceTransition];
    [scrollView removeFromSuperview];
    [_curVC removeFromParentViewController];
    
    [_viewControllers removeObject:_curVC];
    [_coverViews removeObject:_curCoverView];
    [_curVC release];
    [scrollView release];
    [_curCoverView release];
    
    _curCoverView = _coverViews.count>0 ? [_coverViews lastObject]:nil;
    _curVC = _lastVC;
    _lastVC = _viewControllers.count>1 ? [_viewControllers objectAtIndex:_viewControllers.count-2]:nil;
    
    if (_lastVC) {
        //readd last view
        [_lastVC beginAppearanceTransition:YES animated:NO];
        [self.view insertSubview:_lastVC.view.superview belowSubview:_curVC.view.superview];
        [_lastVC endAppearanceTransition];
    }
}

- (void)popToRootViewController:(BOOL)animated {
    if (_viewControllers.count < 2) {
        return;
    }
    
    //handle last VC
    if (_viewControllers.count > 2) {
        UIScrollView *lastScrollView = (UIScrollView*)_lastVC.view.superview;
        [_lastVC willMoveToParentViewController:nil];
        [_lastVC beginAppearanceTransition:NO animated:NO];
        [_lastVC.view removeFromSuperview];
        [_lastVC endAppearanceTransition];
        [lastScrollView removeFromSuperview];
        [_lastVC removeFromParentViewController];
        [_viewControllers removeObject:_lastVC];
        [_lastVC release];
    }

    NSMutableArray *otherVCs = [_viewControllers mutableCopy];
    
    //handle root VC
    UIViewController *rootVC = [_viewControllers objectAtIndex:0];
    if (rootVC != _lastVC) {
        [rootVC beginAppearanceTransition:YES animated:NO];
        [self.view insertSubview:rootVC.view.superview belowSubview:_curVC.view.superview];
        [rootVC endAppearanceTransition];
        _lastVC = rootVC;
    }

    [otherVCs removeObject:rootVC];
    [otherVCs removeObject:_curVC];
    
    //handle current VC
    [_viewControllers removeObjectsInArray:otherVCs];
    [self popScrollViewController:animated];
    
    //handle other invisable VCs
    for (UIViewController* vc in otherVCs) {
        [vc willMoveToParentViewController:nil];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
        [vc release];
    }
    [otherVCs release];
}

#pragma mark - uiscrollview delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate && scrollView==_curVC.view.superview) {
        [self curScrollDidEnd:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _curVC.view.superview) {
        CGFloat transParam = scrollView.contentOffset.x;
        CGFloat transScale = 1.0f - (1.0f-MIN_VIEW_TRANS_SCALE)*transParam/MAIN_SCREEN_BOUNDS.size.width;
        _curCoverView.alpha = MAX_COVER_ALPHA*(transParam/MAIN_SCREEN_BOUNDS.size.width);
        _lastVC.view.layer.transform = CATransform3DMakeScale(transScale, transScale, 1);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _curVC.view.superview) {
        [self curScrollDidEnd:scrollView];
    }
}

- (void)curScrollDidEnd:(UIScrollView*)scrollView {
    if (scrollView.contentOffset.x < 5.f) {
        [self popScrollViewController:YES];
    }
}


@end
