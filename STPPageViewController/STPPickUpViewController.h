//
//  STPPageViewController.h
//  LPCollection
//
//  Created by Muramoto on 2013/12/03.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import "STPCollectionViewController.h"
#import "STPPickUpLayout.h"
#import "STPRootViewController.h"
#import "STPTransitionManager.h"
#import "NMPageViewController.h"


@interface STPPickUpViewController : STPCollectionViewController <STPTransitionViewDelegate>

@property (nonatomic) STPRootViewController *pagingViewController;

@end
