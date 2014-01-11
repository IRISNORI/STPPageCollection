//
//  NMListCollectionController.h
//  STPPageViewController
//
//  Created by Norikazu on 2014/01/10.
//  Copyright (c) 2014年 Norikazu Muramoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STPDataController;
@class STPListPickUpCell;
@class STPListViewController;
@class STPPickUpViewController;

@interface NMListCollectionController : UINavigationController

@property (nonatomic) id listViewDelegate;

- (id)initWithListViewController:(STPListViewController*)listViewController;
@end
