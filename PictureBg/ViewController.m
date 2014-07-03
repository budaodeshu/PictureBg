//
//  ViewController.m
//  PictureBg
//
//  Created by zheng on 13-5-9.
//  Copyright (c) 2013年 zheng. All rights reserved.
//

#import "ViewController.h"

#define COLUMNS 2
#define ROWS 3
#define ITEMSPERPAGE 6
#define SPACE 20
#define GRIDHIGHT 100
#define GRIDWITH 100
#define UNVALIDINDEX -1
#define THRESHOLD 30

@interface ViewController (private)
- (NSInteger)indexOfLocation:(CGPoint)location;
- (CGPoint)orginPointOfIndex:(NSInteger)index;
- (void)exchangeItem:(NSInteger)oldIndex withPosition:(NSInteger)newIndex;
@end

@implementation ViewController
@synthesize backgroundImage;
@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    page = 0;
    isEditing = NO;
    addButton = [[LSGridItem alloc] initWithTitle:@"Add" withImageName:@"blueButton.jpg" atIndex:0 editable:NO];
    addButton.frame = CGRectMake(20, 20, 100, 100);
    addButton.delegate = self;
    [scrollView addSubview:addButton];
    gridItems = [[NSMutableArray alloc] initWithCapacity:6];
    [gridItems addObject:addButton];
    
    scrollView.delegate = self;
    [scrollView setPagingEnabled:YES];
    
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singleTap setNumberOfTapsRequired:1];
    singleTap.delegate = self;
    [scrollView addGestureRecognizer:singleTap];
}

- (void)viewDidUnload {
    self.backgroundImage = nil;
    self.scrollView = nil;
    addButton = nil;
    [super viewDidUnload];
}

/*- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = self.backgroundImage.frame;
    frame.origin.x = preFrame.origin.x + (preX - scrollView.contentOffset.x)/10;
    if (frame.origin.x <= 0 && frame.origin.x >scrollView.frame.size.width - frame.size.width) {
        self.backgroundImage.frame = frame;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    preX = scrollView.contentOffset.x;
    preFrame = backgroundImage.frame;
}

- (void)addButton {
    CGRect frame = CGRectMake(20, 20, 100, 100);
    int n = [gridItems count];
    int row = (n-1)/2;
    int col = (n-1)%2;
    int curpage = (n-1) / ITEMSPERPAGE;
    row = row  % 3;
    if (n/6 + 1 > 6) {
        return;
    } else {
        frame.origin.x = frame.origin.x + frame.size.width * col + 20 * col + scrollView.frame.size.width *   curpage;
        frame.origin.y = frame.origin.y + frame.size.height * row + 20 *row;
        
        LSGridItem *gridItem = [[LSGridItem alloc] initWithTitle:[NSString stringWithFormat:@"%d",n-1] withImageName:@"blueButton.jpg" atIndex:n-1 editable:YES];
        [gridItem setFrame:frame];
        [gridItem setAlpha:0.5];
        gridItem.delegate = self;
        [gridItems insertObject:gridItem atIndex:n-1];
        [scrollView addSubview:gridItem];
        gridItem = nil;
        //move the add button
        row = n / 2;
        col = n % 2;
        curpage = n / 6;
        row  = row % 3;
        frame = CGRectMake(20, 20, 100, 100);
        frame.origin.x = frame.origin.x + frame.size.width * col + 20 * col + scrollView.frame.size.width * curpage;
        frame.origin.y = frame.origin.y + frame.size.height * row + 20 * row;
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width * (curpage + 1), scrollView.frame.size.height)];
        [scrollView scrollRectToVisible:CGRectMake(scrollView.frame.size.width * curpage, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height) animated:NO];
        [UIView animateWithDuration:0.2f animations:^{
            [addButton setFrame:frame];
        }];
        addButton.index += 1;
    }
}

#pragma  mark - LSGridItemDelegate
- (void)gridItemDidClicked:(LSGridItem *)gridItem {
    if (gridItem.index == [gridItems count]-1) {
        [self addButton];
    }
}
- (void)gridItemDidDeleted:(LSGridItem *)gridItem atIndex:(NSInteger)index {
    LSGridItem *item = [gridItems objectAtIndex:index];
    [gridItems removeObjectAtIndex:index];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect lastFrame = item.frame;
        CGRect curFrame;
        for (int i = index; i < [gridItems count]; i++) {
            LSGridItem *temp = [gridItems objectAtIndex:i];
            curFrame = temp.frame;
            [temp setFrame:lastFrame];
            lastFrame = curFrame;
            [temp setIndex:i];
        }
       // [addButton setFrame:lastFrame];
    }];
    [item removeFromSuperview];
    item = nil;
}

- (void)gridItemDidEditingMode:(LSGridItem *)gridItem {
    for (LSGridItem *item in gridItems) {
        [item enableEditing];
    }
    isEditing = YES;
}

- (void)gridItemDidMoved:(LSGridItem *)gridItem withLocation:(CGPoint)point moveGrestureRecognizer:(UILongPressGestureRecognizer *)recognizer {
    CGRect frame = gridItem.frame;
    CGPoint _point = [recognizer locationInView:self.scrollView];
    CGPoint pointInView = [recognizer locationInView:self.view];
    frame.origin.x = _point.x - point.x;
    frame.origin.y = _point.y - point.y;
    gridItem.frame = frame;
    
    NSInteger toIndex = [self indexOfLocation:_point];
    NSInteger fromIndex = gridItem.index;
    
    if (toIndex != UNVALIDINDEX && toIndex != fromIndex) {
        LSGridItem *moveItem = [gridItems objectAtIndex:toIndex];
        [scrollView sendSubviewToBack:moveItem];
        [UIView animateWithDuration:0.2 animations:^{
            CGPoint origin = [self orginPointOfIndex:fromIndex];
            moveItem.frame = CGRectMake(origin.x, origin.y, moveItem.frame.size.width, moveItem.frame.size.height);
        }];
        [self exchangeItem:fromIndex withPosition:toIndex];
    }
    
    if (pointInView.x >= scrollView.frame.size.width - THRESHOLD) {
        [scrollView scrollRectToVisible:CGRectMake(scrollView.contentOffset.x + scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
    } else if (pointInView.x < THRESHOLD) {
        [scrollView scrollRectToVisible:CGRectMake(scrollView.contentOffset.x - scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
    }
}
- (void)gridItemEndMoved:(LSGridItem *)gridItem withLocation:(CGPoint)point moveGrestureRecognizer:(UILongPressGestureRecognizer *)recognizer {
    CGPoint _point = [recognizer locationInView:self.scrollView];
    NSInteger toIndex = [self indexOfLocation:_point];
    if (toIndex == UNVALIDINDEX) {
        toIndex = gridItem.index;
    }
    CGPoint origin = [self orginPointOfIndex:toIndex];
    [UIView animateWithDuration:0.2 animations:^{
        gridItem.frame = CGRectMake(origin.x, origin.y, gridItem.frame.size.width, gridItem.frame.size.height);
    }];
}
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (isEditing) {
        for (LSGridItem *item in gridItems) {
            [item disableEditing];
        }
        [addButton disableEditing];
    }
    isEditing = NO;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view != scrollView) {
        return NO;
    } else
        return YES;
}

#pragma mark - private
- (NSInteger)indexOfLocation:(CGPoint)location {
    NSInteger index;
    NSInteger _page = location.x / 320;
    NSInteger row = location.y / (GRIDHIGHT + 20);
    NSInteger col = (location.x - _page * 320) / (GRIDWITH + 20);
    if (row >= ROWS || col >= COLUMNS) {
        return UNVALIDINDEX;
    } else {
    	index = ITEMSPERPAGE * _page + row *2 + col;
    }
    
    if (index >= [gridItems count]) {
        return UNVALIDINDEX;
    }
    
    return index;
}

- (CGPoint)orginPointOfIndex:(NSInteger)index {
    CGPoint point = CGPointZero;
    if (index > [gridItems count] || index < 0) {
        return point;
    } else {
        NSInteger _page = index / ITEMSPERPAGE;
        NSInteger row = (index - _page *ITEMSPERPAGE) / COLUMNS;
        NSInteger col = (index - _page *ITEMSPERPAGE) % COLUMNS;
        
        point.x = page *320 + col * GRIDWITH + (col + 1)*SPACE;
        point.y = row *GRIDHIGHT + (row + 1) * SPACE;
        return point;
    }
}

- (void)exchangeItem:(NSInteger)oldIndex withPosition:(NSInteger)newIndex {
    ((LSGridItem *)[gridItems objectAtIndex:oldIndex]).index = newIndex;
    ((LSGridItem *)[gridItems objectAtIndex:newIndex]).index = oldIndex;
    [gridItems exchangeObjectAtIndex:oldIndex withObjectAtIndex:newIndex];
}
@end














