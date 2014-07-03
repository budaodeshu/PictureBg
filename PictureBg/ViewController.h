//
//  ViewController.h
//  PictureBg
//
//  Created by zheng on 13-5-9.
//  Copyright (c) 2013年 zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSGridItem.h"
@interface ViewController : UIViewController<UIScrollViewDelegate, LSGridItemDelegate, UIGestureRecognizerDelegate>
{
    NSMutableArray *gridItems;
    LSGridItem *addButton;
    int page;
    float preX;
    BOOL isMoving;
    CGRect preFrame;
    BOOL isEditing;
    UITapGestureRecognizer *singleTap;
}

@property (nonatomic, assign) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, assign) IBOutlet UIScrollView *scrollView;

- (void)addButton;

@end
