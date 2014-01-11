//
//  STPRootViewController.m
//  NMPageViewController
//
//  Created by Norikazu on 2013/12/26.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import "STPRootViewController.h"
#import "STPDataCollectionViewController.h"

@interface STPRootViewController ()

@end

@implementation STPRootViewController

- (id)initWithDataController:(STPDataController *)dataController indexPath:(NSIndexPath *)indexPath
{
    self = [super init];
    if (self) {
        _dataController = dataController;
        _selectedIndexPath = indexPath;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.pageViewController = [[NMPageViewController alloc] init];
    self.pageViewController.delegate = self;

    
    STPDataViewController *startingViewController = [self.dataController viewControllerAtIndex:self.selectedIndexPath.row];
    [self.pageViewController setStartViewController:(UIViewController *)startingViewController];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    [self.pageViewController setBackgroundView:backgroundView];
    
    self.pageViewController.dataSource = self.dataController;

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];

    
    CGRect pageViewRect = self.view.bounds;
    self.pageViewController.view.frame = pageViewRect;

    [self.pageViewController didMoveToParentViewController:self];

    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (STPDataController *)dataController
{
     // Return the model controller object, creating it if necessary.
     // In more complex implementations, the model controller may be passed to the view controller.
    if (!_dataController) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSArray *data = [[dateFormatter monthSymbols] copy];
        
        _dataController = [[STPDataController alloc] initWithDataSource:data];
    }
    return _dataController;
}

#pragma mark - UIPageViewController delegate methods


- (void)pageViewController:(NMPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        NSUInteger index = [self.dataController indexOfViewController:[previousViewControllers lastObject]];
        [self.delegate pagingViewDidChange:index];
    }
}



@end
