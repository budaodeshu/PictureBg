//
//  LSGridItem.m
//  PictureBg
//
//  Created by zheng on 13-5-9.
//  Copyright (c) 2013年 zheng. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "LSGridItem.h"

@implementation LSGridItem
@synthesize isEditing;
@synthesize isRemovable;
@synthesize delegate;
@synthesize index;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title withImageName:(NSString *)image atIndex:(NSInteger)aIndex editable:(BOOL)removable
{
    self = [super initWithFrame:CGRectMake(0, 0, 100, 100)];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        normalImage = [UIImage imageNamed:image];
        titleText = title;
        self.isEditing = NO;
        self.index = aIndex;
        self.isRemovable = removable;
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:self.bounds];
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:titleText forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressedLong:)];
        [self addGestureRecognizer:longPressGR];
        longPressGR = nil;
        [self addSubview:button];
        
        if (self.isRemovable)
        {
            deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            float width = 20;
            float height= 20;
            
            deleteButton.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
            [deleteButton setImage:[UIImage imageNamed:@"deletbutton.png"] forState:UIControlStateNormal];
            deleteButton.backgroundColor = [UIColor clearColor];
            [deleteButton addTarget:self action:@selector(removeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [deleteButton setHidden:YES];
            [self addSubview:deleteButton];
        }
    }
    return self;
}

#pragma mark - 
- (void)clickItem:(id)sender
{
    [delegate gridItemDidClicked:self];
}

- (void)pressedLong:(UILongPressGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            point = [gestureRecognizer locationInView:self];
            [delegate gridItemDidEditingMode:self];
            [self setAlpha:1.0];
            break;
            
        case UIGestureRecognizerStateEnded:
            point = [gestureRecognizer locationInView:self];
            [delegate gridItemEndMoved:self withLocation:point moveGrestureRecognizer:gestureRecognizer];
            [self setAlpha:0.5];
            break;
        case UIGestureRecognizerStateFailed:
            break;
        case UIGestureRecognizerStateChanged:
            [delegate gridItemDidMoved:self withLocation:point moveGrestureRecognizer:gestureRecognizer];
        default:
            break;
    }
}

- (void)removeButtonClicked:(id)sender
{
    [delegate gridItemDidDeleted:self atIndex:index];
}

#pragma mark - Custom Methods
- (void)enableEditing
{
    if (self.isEditing)
        return;
    self.isEditing = YES;
    //mark the remove button visible
    deleteButton.hidden = NO;
    button.enabled = NO;
    //start the wiggling animation
    CGFloat rotation = 0.03;
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
    shake.duration = 0.13;
    shake.autoreverses = YES;
    shake.repeatCount = MAXFLOAT;
    shake.removedOnCompletion = NO;
    shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, -rotation, 0.0, 0.0, 1.0)];
    [self.layer addAnimation:shake forKey:@"shakeAnimation"];
}

- (void)disableEditing
{
    [self.layer removeAnimationForKey:@"shakeAnimation"];
    [deleteButton setHidden:YES];
    [button setEnabled:YES];
    self.isEditing = NO;
}

#pragma mark - Overriding UIView Methods
- (void)removeFromSuperview
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        self.frame = CGRectMake(self.frame.origin.x+50, self.frame.origin.y+50, 0,0);
        deleteButton.frame = CGRectMake(0, 0, 0, 0);
    }completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
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
