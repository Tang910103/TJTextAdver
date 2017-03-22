//
//  TJTextAdver.h
//  TJKit
//
//  Created by Tang杰 on 17/3/17.
//  Copyright © 2017年 Tang杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJTextAdver : UITableView
@property (nonatomic, copy) void (^didSelect)(UITableView *tableView, NSIndexPath *indexPath);

@property (nonatomic,strong) UIColor         *textColor;
/**
 *  text font for message label
 */
@property (nonatomic,strong) UIFont          *textFont;

+ (instancetype)textAdverWithFrame:(CGRect)frame didSelect:(void(^)(UITableView *tableView, NSIndexPath *indexPath))select;
@property (nonatomic, strong) NSArray <NSString *>*messageArray;
@property (nonatomic,assign) NSTimeInterval scrollTimeInterval;

- (void)start;
- (void)stop;

@end
