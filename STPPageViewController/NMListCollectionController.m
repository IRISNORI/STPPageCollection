//
//  NMListCollectionController.m
//  STPPageViewController
//
//  Created by Norikazu on 2014/01/10.
//  Copyright (c) 2014年 Norikazu Muramoto. All rights reserved.
//

#import "NMListCollectionController.h"
#import "STPTransitionManager.h"
#import "STPListViewController.h"
#import "STPPickUpViewController.h"
#import "STPDataController.h"

@interface NMListCollectionController () <UINavigationControllerDelegate, STPTransitionManagerDelegate>

@property (nonatomic, strong) STPTransitionManager *transitionManager;
@property (nonatomic, strong) STPListViewController *collectionViewController;
@property (nonatomic) STPDataController *dataController;

@end

@implementation NMListCollectionController

@synthesize dataController = _dataController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithListViewController:(STPListViewController*)listViewController
{
    self = [super init];
    if (self) {
        _collectionViewController = listViewController;
    }
    return self;
}

- (STPDataController *)dataController
{
    if (!_dataController) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSArray *data = [[dateFormatter monthSymbols] copy];
        
        _dataController = [[STPDataController alloc] initWithDataSource:data];
    }
    return _dataController;
}

- (STPListViewController *)collectionViewController
{
    if (!_collectionViewController) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(320, 130);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionViewController = [[STPListViewController alloc] initWithCollectionViewLayout:layout dataController:self.dataController];
    }
    return _collectionViewController;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    
    
    _transitionManager = [[STPTransitionManager alloc] initWithCollectionViewController:_collectionViewController];
    
    self.transitionManager.delegate = self;
    
    [self setViewControllers:@[self.collectionViewController]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TransitionControllerDelegate

- (void)interactionBeganAtPoint:(CGPoint)point
{
    UIViewController *viewController =
    [(STPCollectionViewController *)self.topViewController nextViewControllerAtPoint:point];
    if (viewController != nil) {
        
        [self pushViewController:viewController animated:YES];
    } else {
        [self popViewControllerAnimated:YES];
    }
}

- (void)interactionBeganAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController =
    [(STPCollectionViewController *)self.topViewController nextViewControllerAtIndexPath:indexPath];
    if (viewController != nil) {
        [self pushViewController:viewController animated:YES];
    } else {
        [self popViewControllerAnimated:YES];
    }
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if (animationController == self.transitionManager){
        return self.transitionManager;
    }
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    id transitionManager = nil;
    
    if ([toVC isKindOfClass:[STPPickUpViewController class]]) {
        self.transitionManager.viewDelegate = (STPPickUpViewController *)toVC;
    }
    
    if ([fromVC isKindOfClass:[UICollectionViewController class]] &&
        [toVC isKindOfClass:[UICollectionViewController class]] &&
        self.transitionManager.hasActiveInteraction)
    {
        self.transitionManager.navigationOperation = operation;
        transitionManager = self.transitionManager;
    } else {
        transitionManager = self.transitionManager;
    }
    
    return transitionManager;
}

@end
