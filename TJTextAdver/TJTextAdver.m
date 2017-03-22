//
//  TJTextAdver.m
//  TJKit
//
//  Created by Tang杰 on 17/3/17.
//  Copyright © 2017年 Tang杰. All rights reserved.
//

#import "TJTextAdver.h"

@interface TJTextAdverCell : UITableViewCell
@property (nonatomic, copy) void(^didSelect)(TJTextAdverCell *cell);
@property (nonatomic, copy) void(^touchesBegan)(TJTextAdverCell *cell);
@end
@implementation TJTextAdverCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = self.contentView.bounds;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.touchesBegan) {
        self.touchesBegan(self);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.didSelect) {
        self.didSelect(self);
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.didSelect) {
        self.didSelect(self);
    }
}

@end

@interface TJTextAdver ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation TJTextAdver

+ (instancetype)textAdverWithFrame:(CGRect)frame didSelect:(void(^)(UITableView *tableView, NSIndexPath *indexPath))select
{
    TJTextAdver *textAdver = [[TJTextAdver alloc] initWithFrame:frame style:UITableViewStylePlain];
    textAdver.didSelect = select;
    return textAdver;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.scrollTimeInterval = 3;
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.scrollEnabled = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self registerClass:[TJTextAdverCell class] forCellReuseIdentifier:NSStringFromClass([TJTextAdverCell class])];
        [self start];
    }
    
    return self;
}

- (void)scrollText
{
    NSInteger seletedRow = [self indexPathsForVisibleRows].firstObject.row;
    if (seletedRow == self.messageArray.count) {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        seletedRow = 0;
    }
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:seletedRow+1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)setMessageArray:(NSArray<NSString *> *)messageArray
{
    _messageArray = messageArray;
    
    [self reloadData];
    [self start];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJTextAdverCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TJTextAdverCell class])];
    __weak typeof(self) weakSelf = self;
    [cell setDidSelect:^(TJTextAdverCell *selectCell) {
        NSIndexPath *selectIndex = [tableView indexPathForCell:selectCell];
        if (weakSelf.didSelect) {
            weakSelf.didSelect(tableView, [NSIndexPath indexPathForItem:selectIndex.row == self.messageArray.count ? 0 : selectIndex.row inSection:selectIndex.section]);
        }
        [weakSelf start];
    }];
    [cell setTouchesBegan:^(TJTextAdverCell *touchCell) {
        [weakSelf stop];
    }];
    cell.textLabel.text = self.messageArray[indexPath.row == self.messageArray.count ? 0 : indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = self.backgroundColor;
    cell.textLabel.font = self.textFont;
    cell.textLabel.textColor = self.textColor;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGRectGetHeight(self.bounds);
}

- (void)start{
    
    [self stop];
    if (self.messageArray.count < 2) {
        return;
    }
    NSTimer *timer = [NSTimer timerWithTimeInterval:self.scrollTimeInterval target:self selector:@selector(scrollText) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)stop{
    [self.timer invalidate];
    self.timer = nil;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
