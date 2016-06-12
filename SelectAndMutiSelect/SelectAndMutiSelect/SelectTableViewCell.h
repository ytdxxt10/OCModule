//
//  SelectTableViewCell.h
//  SelectAndMutiSelect
//
//  Created by offcn_c on 16/5/20.
//  Copyright © 2016年 offcn_c. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectTableViewCell;
@protocol SelectTableCellDelegate <NSObject>

- (void)deleteRow:(SelectTableViewCell *)cell;

@end

@interface SelectTableViewCell : UITableViewCell

@property (nonatomic, weak) id<SelectTableCellDelegate>delegate;
@property (nonatomic, weak) UILabel *infoLabel;

- (void)closeLeftPan;

@end
