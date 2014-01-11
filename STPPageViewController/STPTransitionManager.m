//
//  STPTransitionManager.m
//  LPInterface
//
//  Created by Muramoto on 2013/11/29.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import "STPTransitionManager.h"


@interface STPTransitionManager ()
@property (nonatomic) UICollectionViewTransitionLayout *transitionLayout;
@property (nonatomic) id <UIViewControllerContextTransitioning> context;
@property (nonatomic) CGFloat initialPinchDistance;
@property (nonatomic) CGPoint initialPinchPoint;
@property (nonatomic) CGSize  initialSize;
@property (nonatomic) BOOL presenting;
@end

@implementation STPTransitionManager

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
{
    self = [super init];
    if (self != nil)
    {
        // setup our pinch gesture:
        //  pinch in closes photos down into a stack,
        //  pinch out expands the photos intoa  grid
        //
        _pinchGesture =
        [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [collectionView addGestureRecognizer:_pinchGesture];
        
        self.collectionView = collectionView;
    }
    return self;
}

- (instancetype)initWithCollectionViewController:(UICollectionViewController *)collectionViewController
{
    self = [super init];
    if (self != nil)
    {

        _pinchGesture =
        [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [collectionViewController.collectionView addGestureRecognizer:_pinchGesture];
        self.parentViewController = collectionViewController;
        self.collectionView = collectionViewController.collectionView;
        
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // transition animation time between grid and stack layout
    
    return 0.5;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{

    self.context = transitionContext;
    UICollectionViewController *fromCollectionViewController =
    (UICollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UICollectionViewController *toCollectionViewController =
    (UICollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    
    
    [containerView addSubview:[toCollectionViewController view]];
    //[containerView addSubview:[fromCollectionViewController view]];
    
    UICollectionViewLayout *layout = toCollectionViewController.collectionViewLayout;
    

    [fromCollectionViewController.collectionView setCollectionViewLayout:layout animated:YES completion:^(BOOL finished){
        [self.context finishInteractiveTransition];
        [self.context completeTransition:finished];
        self.context = nil;
    }];

    self.presenting = [layout isKindOfClass:[STPPickUpLayout class]] ? YES : NO;
    
    if (self.presenting) {
        [self.viewDelegate selectedIndexPath:((STPPickUpLayout *)layout).selectedIndexPath];
    }
    
    [self.viewDelegate startAnimation:[self transitionDuration:transitionContext] presenting:self.presenting];
    
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    if (self.presenting) {
        [self.viewDelegate addGesture:self.pinchGesture];
    } else {
        [self.collectionView addGestureRecognizer:self.pinchGesture];
    }
    
}

// required method for view controller transitions, called when the system needs to set up
// the interactive portions of a view controller transition and start the animations
//
- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    self.context = transitionContext;
    if (!self.hasActiveInteraction) {
        [self animateTransition:transitionContext];
        return;
    }
    
    UICollectionViewController *fromCollectionViewController =
    (UICollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UICollectionViewController *toCollectionViewController =
    (UICollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:[toCollectionViewController view]];
    //[containerView addSubview:[fromCollectionViewController view]];
    
    self.transitionLayout = [fromCollectionViewController.collectionView startInteractiveTransitionToCollectionViewLayout:toCollectionViewController.collectionViewLayout completion:^(BOOL didFinish, BOOL didComplete) {
        [self.context completeTransition:didComplete];
        self.transitionLayout = nil;
        self.context = nil;
        self.hasActiveInteraction = NO;
    }];
    
    [self.viewDelegate startWithIndexPath:self.selectedIndexPath presenting:self.presenting];
}

- (void)updateWithProgress:(CGFloat)progress andSize:(CGSize)size
{
    if (self.context != nil && (progress != self.transitionLayout.transitionProgress)){
        //[self.transitionLayout setSelectedItemSize:size];
        [self.transitionLayout setTransitionProgress:progress];
        [self.transitionLayout invalidateLayout];
        [self.context updateInteractiveTransition:progress];
        [self.viewDelegate updateWithProgress:progress presenting:self.presenting];
    }
}

// called by our pinch gesture recognizer when the gesture has finished or cancelled, which
// in turn is responsible for finishing or cancelling the transition.
//
- (void)endInteractionWithSuccess:(BOOL)success
{
    if (self.context == nil)
    {
        self.hasActiveInteraction = NO;
    }
    // allow for the transition to finish when it's progress has started as a threshold of 10%,
    // if you want to require the pinch gesture with a wider threshold, change it it a value closer to 1.0
    //
    else if ((self.transitionLayout.transitionProgress > 0.1) && success)
    {
        [self.collectionView finishInteractiveTransition];
        [self.context finishInteractiveTransition];
        [self.viewDelegate finishInteractiveTransition:self.transitionLayout.transitionProgress presenting:self.presenting];
        if (self.presenting) {
            [self.viewDelegate addGesture:self.pinchGesture];
        } else {
            [self.collectionView addGestureRecognizer:self.pinchGesture];
        }
    }
    else
    {
        [self.collectionView cancelInteractiveTransition];
        [self.context cancelInteractiveTransition];
        [self.viewDelegate cancelInteractiveTransition:self.transitionLayout.transitionProgress presenting:self.presenting];
    }
}

// action method for our pinch gesture recognizer
//
- (void)handlePinch:(UIPinchGestureRecognizer *)sender
{
    // here we want to end the transition interaction if the user stops or finishes the pinch gesture
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self endInteractionWithSuccess:YES];
    }
    else if (sender.state == UIGestureRecognizerStateCancelled)
    {
        [self endInteractionWithSuccess:NO];
    }
    else if (sender.numberOfTouches == 2)
    {
        // here we expect two finger touch
        CGPoint point;      // the main touch point
        CGPoint point1;     // location of touch #1
        CGPoint point2;     // location of touch #2
        CGFloat distance;   // computed distance between both touches
        
        // return the locations of each gesture’s touches in the local coordinate system of a given view
        point1 = [sender locationOfTouch:0 inView:sender.view];
        point2 = [sender locationOfTouch:1 inView:sender.view];
        distance = sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
        
        // get the main touch point
        point = [sender locationInView:self.collectionView];
        
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            // start the pinch in our out
            if (!self.hasActiveInteraction)
            {
                self.initialPinchDistance = distance;
                self.initialPinchPoint = point;
                self.hasActiveInteraction = YES;    // the transition is in active motion
                [self.viewDelegate selectedIndexPath:[self.collectionView indexPathForItemAtPoint:point]];
                
                self.selectedIndexPath = [self.collectionView indexPathForItemAtPoint:point];
                if ([self.collectionView.collectionViewLayout isKindOfClass:[STPPickUpLayout class]]) {
                    self.presenting = NO;
                } else {
                    self.presenting = YES;
                }
                
                //[self.delegate interactionBeganAtIndexPath:[self.collectionView indexPathForItemAtPoint:point]];
                [self.delegate interactionBeganAtIndexPath:[self.collectionView indexPathForItemAtPoint:point]];
                
            }
        }
        
        if (self.hasActiveInteraction)
        {
            if (sender.state == UIGestureRecognizerStateChanged)
            {
                
                CGFloat distanceDelta = distance - self.initialPinchDistance;
                if (self.navigationOperation == UINavigationControllerOperationPush)
                {
                    distanceDelta = distance - self.initialPinchDistance;
                } else {
                    distanceDelta = self.initialPinchDistance - distance;
                }
                CGFloat dimension = sqrt(self.collectionView.bounds.size.width * self.collectionView.bounds.size.width + self.collectionView.bounds.size.height * self.collectionView.bounds.size.height);
                CGFloat progress = MAX(MIN((distanceDelta / dimension), 1.0), 0.0);
                CGFloat height = self.initialSize.height * sender.scale;

                [self updateWithProgress:progress andSize:CGSizeMake(self.initialSize.width, height)];
            }
        }
    }
}
@end
