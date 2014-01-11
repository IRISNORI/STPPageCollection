//
//  STPDataViewController.m
//  Page
//
//  Created by Norikazu on 2014/01/04.
//  Copyright (c) 2014年 Norikazu Muramoto. All rights reserved.
//

#import "STPDataViewController.h"

@interface STPDataViewController ()

@end

@implementation STPDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}

@end
