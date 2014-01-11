//
//  STPAppDelegate.m
//  STPPageViewController
//
//  Created by Norikazu on 2013/12/26.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import "STPAppDelegate.h"
#import "STPTransitionManager.h"
#import "STPListViewController.h"
#import "STPPickUpViewController.h"
#import "STPDataController.h"

@interface STPAppDelegate () <UINavigationControllerDelegate, STPTransitionManagerDelegate>

@property (nonatomic, strong) STPTransitionManager *transitionManager;
@property (nonatomic, strong) STPListViewController *collectionViewController;

@end

@implementation STPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    navigationController.delegate = self;
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(320, 130);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSArray *data = [[dateFormatter monthSymbols] copy];
    
    STPDataController *dataController = [[STPDataController alloc] initWithDataSource:data];
    _collectionViewController = [[STPListViewController alloc] initWithCollectionViewLayout:layout dataController:dataController];
    _transitionManager = [[STPTransitionManager alloc] initWithCollectionViewController:_collectionViewController];
    
    self.transitionManager.delegate = self;
    
    [navigationController setViewControllers:@[_collectionViewController]];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - TransitionControllerDelegate

- (void)interactionBeganAtPoint:(CGPoint)point
{

    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    UIViewController *viewController =
    [(STPCollectionViewController *)navigationController.topViewController nextViewControllerAtPoint:point];
    if (viewController != nil) {
        
        [navigationController pushViewController:viewController animated:YES];
    } else {
        [navigationController popViewControllerAnimated:YES];
    }
}

- (void)interactionBeganAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    UIViewController *viewController =
    [(STPCollectionViewController *)navigationController.topViewController nextViewControllerAtIndexPath:indexPath];
    if (viewController != nil) {
        [navigationController pushViewController:viewController animated:YES];
    } else {
        [navigationController popViewControllerAnimated:YES];
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
