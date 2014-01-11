//
//  STPListPickUpCell.m
//  LPInterface
//
//  Created by Norikazu on 2013/11/30.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import "STPListPickUpCell.h"

@interface STPListPickUpCell ()

@property (nonatomic) CGRect initialFrame;

@end


@implementation STPListPickUpCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _initialFrame = frame;
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.nameLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    UIEdgeInsets inset = {30,20,10,10};
    CGRect frame = self.bounds;
    CGRect rect = UIEdgeInsetsInsetRect(frame, inset);
    self.nameLabel.frame = rect;
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.font = [UIFont systemFontOfSize:30];
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    
    self.backgroundView.contentMode = UIViewContentModeTop;
    self.backgroundView.clipsToBounds = YES;
    self.contentMode = UIViewContentModeTop;
    self.clipsToBounds = YES;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
