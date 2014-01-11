//
//  NMPageViewController.m
//  NMPageViewController
//
//  Created by Muramoto on 2013/12/26.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import "NMPageViewController.h"

NSString * const STPPageViewCurrentControllerKey = @"current";
NSString * const STPPageViewNextControllerKey = @"next";
NSString * const STPPageViewPreviousControllerKey = @"previous";

@interface NMPageViewController ()



@property (nonatomic) NMPageViewControllerNavigationDirection direction;

@property (nonatomic, assign) UIViewController *nextViewController;
@property (nonatomic, assign) UIViewController *previousViewController;


@property (nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic) BOOL hasActiveInteraction;
@property (nonatomic) CGRect initialFrame;
@property (nonatomic) CGFloat initialLocationX;
@property (nonatomic) NSMutableDictionary *controllers;
@property (nonatomic) NSMutableDictionary *backgroundViews;

@property (nonatomic) UIView *contentView;
@property (nonatomic) UIView *nextView;
@property (nonatomic) UIView *previousView;
@property (nonatomic, assign) CGPoint lastKnownVelocity;

@property (nonatomic, readonly) CGRect currentFrame;
@property (nonatomic, readonly) CGRect nextFrame;
@property (nonatomic, readonly) CGRect previousFrame;

@end

@implementation NMPageViewController

- (CGRect)previousFrame
{
    return [UIScreen mainScreen].bounds;
}

- (CGRect)currentFrame
{
    CGFloat frameWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat frameHeight = [UIScreen mainScreen].bounds.size.height;
    return CGRectMake(frameWidth, 0, frameWidth, frameHeight);
}

- (CGRect)nextFrame
{
    CGFloat frameWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat frameHeight = [UIScreen mainScreen].bounds.size.height;
    return CGRectMake(frameWidth * 2, 0, frameWidth, frameHeight);
}

- (id)init
{
    self = [super init];
    if (self) {
        _transitionStyle = NMPageViewControllerTransitionStyleBackgroundCrossDissolve;
        _controllers = [NSMutableDictionary new];
        _backgroundViews = [NSMutableDictionary new];
        
        CGFloat frameWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat frameHeight = [UIScreen mainScreen].bounds.size.height;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(-frameWidth, 0, frameWidth * 3, frameHeight)];
    }
    return self;
}

- (void)setStartViewController:(UIViewController *)controller
{
    if (controller) {
        [self.controllers setObject:controller forKey:STPPageViewCurrentControllerKey];
    }
}

- (void)setBackgroundView:(UIView *)backgroundView
{
    //clean
    
    UIView *view = [self.backgroundViews objectForKey:STPPageViewCurrentControllerKey];
    if (view) {
        [view removeFromSuperview];
    }
    
    _backgroundView = backgroundView;
    [self.backgroundViews removeObjectForKey:STPPageViewCurrentControllerKey];
    [self.backgroundViews setObject:backgroundView forKey:STPPageViewCurrentControllerKey];
    [self.view addSubview:_backgroundView];
    [self.view sendSubviewToBack:_backgroundView];
    
}

- (id)initWithStartViewController:(UIViewController *)controller
{
    self = [self init];
    if (self) {
        [self setStartViewController:controller];
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:self.contentView];
    
    UIViewController *currentViewController = [self.controllers objectForKey:STPPageViewCurrentControllerKey];
    
    if (currentViewController) {
        [self addChildViewController:currentViewController];
        currentViewController.view.frame = self.currentFrame;
        [self.contentView addSubview:currentViewController.view];
        [currentViewController didMoveToParentViewController:self];
        
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(userDidPan:)];
        [self.view addGestureRecognizer:_panGestureRecognizer];
        _gestureRecognizers = @[_panGestureRecognizer];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


-(void)userDidPan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint location = [recognizer locationInView:nil];
    CGPoint velocity = [recognizer velocityInView:nil];
    
    self.lastKnownVelocity = velocity;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (!self.hasActiveInteraction) {
            self.hasActiveInteraction = YES;
            self.initialLocationX = location.x;
            self.initialFrame = self.contentView.frame;
        
            // Controllers
            
            UIViewController *currentViewController = [self.controllers objectForKey:STPPageViewCurrentControllerKey];
            
            UIViewController *previousViewController = [self.dataSource pageViewController:self viewControllerBeforeViewController:currentViewController];
            UIViewController *nextViewController     = [self.dataSource pageViewController:self viewControllerAfterViewController:currentViewController];
            
            [self.controllers removeObjectForKey:STPPageViewPreviousControllerKey];
            [self.controllers removeObjectForKey:STPPageViewNextControllerKey];
            
            if (previousViewController) {
                [self.controllers setObject:previousViewController forKey:STPPageViewPreviousControllerKey];
                [self addChildViewController:previousViewController];
                previousViewController.view.frame = self.previousFrame;
                [self.contentView addSubview:previousViewController.view];
                [previousViewController didMoveToParentViewController:self];
            }
            
            if (nextViewController) {
                [self.controllers setObject:nextViewController forKey:STPPageViewNextControllerKey];
                [self addChildViewController:nextViewController];
                nextViewController.view.frame = self.nextFrame;
                [self.contentView addSubview:nextViewController.view];
                [nextViewController didMoveToParentViewController:self];
            }
            
            // Background Views
            UIView *previousBackgroundView = [self.dataSource pageViewController:self beforeBackgroundView:currentViewController];
            UIView *nextBackgroundView = [self.dataSource pageViewController:self afterBackgroundView:currentViewController];
            
            [self.backgroundViews removeObjectForKey:STPPageViewPreviousControllerKey];
            [self.backgroundViews removeObjectForKey:STPPageViewNextControllerKey];
            
            if (self.transitionStyle == NMPageViewControllerTransitionStyleBackgroundCrossDissolve) {
                if (previousBackgroundView) {
                    [self.backgroundViews setObject:previousBackgroundView forKey:STPPageViewPreviousControllerKey];
                    previousViewController.view.backgroundColor = [UIColor clearColor];
                    previousBackgroundView.alpha = 0.0f;
                    [self.view addSubview:previousBackgroundView];
                    [self.view sendSubviewToBack:previousBackgroundView];
                }
                
                if (nextBackgroundView) {
                    [self.backgroundViews setObject:nextBackgroundView forKey:STPPageViewNextControllerKey];
                    nextViewController.view.backgroundColor = [UIColor clearColor];
                    nextBackgroundView.alpha = 0.0f;
                    [self.view addSubview:nextBackgroundView];
                    [self.view sendSubviewToBack:nextBackgroundView];
                }
                [self.view sendSubviewToBack:[self.backgroundViews objectForKey:STPPageViewCurrentControllerKey]];
            }
            
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (self.hasActiveInteraction) {
            
            
            CGFloat locationDiff = location.x - self.initialLocationX;
            CGFloat ratioX = locationDiff / [UIScreen mainScreen].bounds.size.width;
            CGFloat sRatioX = sqrt(ratioX * ratioX);
            
            if (locationDiff < 0) {
                self.direction = NMPageViewControllerNavigationDirectionForward;
                if ([self.controllers objectForKey:STPPageViewNextControllerKey] == nil) {
                    locationDiff = locationDiff / 2;
                }
            } else {
                self.direction = NMPageViewControllerNavigationDirectionReverse;
                if ([self.controllers objectForKey:STPPageViewPreviousControllerKey] == nil) {
                    locationDiff = locationDiff / 2;
                }
            }
            
            
            CGRect currentFrame = CGRectOffset(self.initialFrame, locationDiff, 0);
            self.contentView.frame = currentFrame;
            [self updateInteractiveTransition:sRatioX];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.hasActiveInteraction) {
            CGFloat locationDiff = location.x - self.initialLocationX;
            CGFloat ratioX = locationDiff / [UIScreen mainScreen].bounds.size.width;
            CGFloat sRatioX = sqrt(ratioX * ratioX);
            
            CGFloat velocityX = velocity.x;
            CGFloat sVelocityX = sqrt(velocityX * velocityX);
            

            if (locationDiff < 0) {
                self.direction = NMPageViewControllerNavigationDirectionForward;
                if ([self.controllers objectForKey:STPPageViewNextControllerKey] == nil) {
                    [self cancelInteractiveTransition];
                    return;
                }
            } else {
                self.direction = NMPageViewControllerNavigationDirectionReverse;
                if ([self.controllers objectForKey:STPPageViewPreviousControllerKey] == nil) {
                    [self cancelInteractiveTransition];
                    return;
                }
            }
            
            if (sRatioX > PANGESTURE_LOCATION_THRESHOLD || sVelocityX > PANGESTURE_VELOCITY_THRESHOLD) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            
        }
    }
    
}

- (NSTimeInterval)transitionDuration
{
    return 0.3f;
}


- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    if (self.direction == NMPageViewControllerNavigationDirectionForward) {
        UIView *view = [self.backgroundViews objectForKey:STPPageViewNextControllerKey];
        view.alpha = percentComplete;
    } else if(self.direction == NMPageViewControllerNavigationDirectionReverse) {
        UIView *view = [self.backgroundViews objectForKey:STPPageViewPreviousControllerKey];
        view.alpha = percentComplete;
    }
    if ([self.delegate respondsToSelector:@selector(pageViewController:updateInteractiveTransition:)]) {
        [self.delegate pageViewController:self updateInteractiveTransition:percentComplete];
    }
}

- (void)finishInteractiveTransition {
    
    CGRect finishFrame;
    
    if (self.direction == NMPageViewControllerNavigationDirectionForward) {
        finishFrame.origin.x = -CGRectGetWidth([UIScreen mainScreen].bounds) * 2;
    } else if(self.direction == NMPageViewControllerNavigationDirectionReverse) {
        finishFrame.origin.x = 0;
    }

    [UIView animateWithDuration:[self transitionDuration] animations:^{
        self.contentView.frame = finishFrame;
        
        if (self.direction == NMPageViewControllerNavigationDirectionForward) {
            UIView *view = [self.backgroundViews objectForKey:STPPageViewNextControllerKey];
            view.alpha = 1.0f;
        } else if(self.direction == NMPageViewControllerNavigationDirectionReverse) {
            UIView *view = [self.backgroundViews objectForKey:STPPageViewPreviousControllerKey];
            view.alpha = 1.0f;
        }
        
    } completion:^(BOOL finished) {
        
        // content view clean
        self.contentView.frame = self.initialFrame;
        [self.contentView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            [view removeFromSuperview];
        }];
        
        [self.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *controller, NSUInteger idx, BOOL *stop) {
            [controller willMoveToParentViewController:self];
            [controller removeFromParentViewController];
        }];
        
        UIViewController *currentViewController;
        
        if (self.direction == NMPageViewControllerNavigationDirectionForward) {
            currentViewController = [self.controllers objectForKey:STPPageViewNextControllerKey];
            [self.controllers setObject:currentViewController forKey:STPPageViewCurrentControllerKey];
        } else if(self.direction == NMPageViewControllerNavigationDirectionReverse) {
            currentViewController = [self.controllers objectForKey:STPPageViewPreviousControllerKey];
            [self.controllers setObject:currentViewController forKey:STPPageViewCurrentControllerKey];
        }
        currentViewController.view.frame = self.currentFrame;
        [self.contentView addSubview:currentViewController.view];
        
        
        // background view clean
        
        if (self.direction == NMPageViewControllerNavigationDirectionForward) {
            UIView *currentView = [self.backgroundViews objectForKey:STPPageViewCurrentControllerKey];
            UIView *previousView = [self.backgroundViews objectForKey:STPPageViewPreviousControllerKey];
            [currentView removeFromSuperview];
            [previousView removeFromSuperview];
            UIView *nextView = [self.backgroundViews objectForKey:STPPageViewNextControllerKey];
            [self.backgroundViews setObject:nextView forKey:STPPageViewCurrentControllerKey];
        } else if(self.direction == NMPageViewControllerNavigationDirectionReverse) {
            UIView *currentView = [self.backgroundViews objectForKey:STPPageViewCurrentControllerKey];
            UIView *nextView = [self.backgroundViews objectForKey:STPPageViewNextControllerKey];
            [currentView removeFromSuperview];
            [nextView removeFromSuperview];
            UIView *previousView = [self.backgroundViews objectForKey:STPPageViewPreviousControllerKey];
            [self.backgroundViews setObject:previousView forKey:STPPageViewCurrentControllerKey];
        }
        
        
        [self.backgroundViews removeObjectForKey:STPPageViewPreviousControllerKey];
        [self.backgroundViews removeObjectForKey:STPPageViewNextControllerKey];
        
        if ([self.delegate respondsToSelector:@selector(pageViewController:didFinishAnimating:previousViewControllers:transitionCompleted:)]) {
            
            [self.delegate pageViewController:self didFinishAnimating:YES previousViewControllers:@[currentViewController] transitionCompleted:YES];
        }
        self.hasActiveInteraction = NO;
    }];
}

- (void)cancelInteractiveTransition {
    
    [UIView animateWithDuration:[self transitionDuration] animations:^{
        self.contentView.frame = self.initialFrame;
        
        if (self.direction == NMPageViewControllerNavigationDirectionForward) {
            UIView *view = [self.backgroundViews objectForKey:STPPageViewNextControllerKey];
            view.alpha = 0.0f;
        } else if(self.direction == NMPageViewControllerNavigationDirectionReverse) {
            UIView *view = [self.backgroundViews objectForKey:STPPageViewPreviousControllerKey];
            view.alpha = 0.0f;
        }
        
    } completion:^(BOOL finished) {
        
        UIViewController *nextViewController = [self.controllers objectForKey:STPPageViewNextControllerKey];
        UIViewController *previousController = [self.controllers objectForKey:STPPageViewPreviousControllerKey];
        
        [nextViewController willMoveToParentViewController:self];
        [nextViewController removeFromParentViewController];
        [previousController willMoveToParentViewController:self];
        [previousController removeFromParentViewController];
        
        
        UIView *previousView = [self.backgroundViews objectForKey:STPPageViewPreviousControllerKey];
        UIView *nextView = [self.backgroundViews objectForKey:STPPageViewNextControllerKey];
        
        [previousView removeFromSuperview];
        [nextView removeFromSuperview];
        
        [self.backgroundViews removeObjectForKey:STPPageViewPreviousControllerKey];
        [self.backgroundViews removeObjectForKey:STPPageViewNextControllerKey];
        

        if ([self.delegate respondsToSelector:@selector(pageViewController:didFinishAnimating:previousViewControllers:transitionCompleted:)]) {
            
            [self.delegate pageViewController:self didFinishAnimating:YES previousViewControllers:@[] transitionCompleted:NO];
        }
        self.hasActiveInteraction = NO;
    }];
    
}


@end