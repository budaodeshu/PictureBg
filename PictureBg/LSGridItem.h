//
//  LSGridItem.h
//  PictureBg
//
//  Created by zheng on 13-5-9.
//  Copyright (c) 2013年 zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  enum
{
    LSGridItemNormalMode = 0,
    LSGridItemEditingMode = 1,
}LSMode;
@protocol LSGridItemDelegate;

@interface LSGridItem : UIView
{
    UIImage *normalImage;
    UIImage *editingImage;
    NSString *titleText;
    BOOL isEditing;
    BOOL isRemovable;
    UIButton *deleteButton;
    UIButton *button;
    NSInteger index;
    CGPoint point;
}
@property (nonatomic, getter = isEditing) BOOL isEditing;
@property (nonatomic, getter = isRemovable) BOOL isRemovable;
@property (nonatomic) NSInteger index;
@property (nonatomic, assign)id<LSGridItemDelegate>delegate;
- (id)initWithTitle:(NSString *)title withImageName:(NSString *)image atIndex:(NSInteger)aIndex editable:(BOOL)removable;
- (void)enableEditing;
- (void)disableEditing;
@end
@protocol LSGridItemDelegate <NSObject>

- (void)gridItemDidClicked:(LSGridItem *)gridItem;
- (void)gridItemDidEditingMode:(LSGridItem *)gridItem;
- (void)gridItemDidDeleted:(LSGridItem *)gridItem atIndex:(NSInteger)index;
- (void)gridItemDidMoved:(LSGridItem *)gridItem withLocation:(CGPoint)point moveGrestureRecognizer:(UILongPressGestureRecognizer *)recognizer;
- (void)gridItemEndMoved:(LSGridItem *)gridItem withLocation:(CGPoint)point moveGrestureRecognizer:(UILongPressGestureRecognizer *)recognizer;

@end
