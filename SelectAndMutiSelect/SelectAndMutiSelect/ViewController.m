//
//  ViewController.m
//  SelectAndMutiSelect
//
//  Created by offcn_c on 16/5/20.
//  Copyright © 2016年 offcn_c. All rights reserved.
//

#import "ViewController.h"
#import "SelectTableViewCell.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;//数据源
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *selectedArray;//存储被选择的数据
@property (nonatomic, strong) NSMutableArray *deleteIndexPaths;//存储indexpath

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数组
    _selectedArray = [NSMutableArray array];
    _deleteIndexPaths = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    
    //导航栏按钮用系统定制，当然如果你自定义导航栏，按钮需要自己定制
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //初始化数据源
    for (int i = 0; i < 10; i++) {
        [self.dataArray addObject:[NSString stringWithFormat:@"row %d",i]];
    }
    //创建tableview和button
    [self createUI];
}

-(void)createUI {
    [self.view addSubview:self.listTableView];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setBackgroundColor:[UIColor orangeColor]];
    deleteButton.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) - 40, self.view.frame.size.width, 40);
    [self.view addSubview:deleteButton];
    [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

//点击删除的实现方法
- (void)deleteButtonClick:(UIButton *)button
{
    [_dataArray removeObjectsInArray:_selectedArray];
    
    [_listTableView deleteRowsAtIndexPaths:_deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [_deleteIndexPaths removeAllObjects];
    [_selectedArray removeAllObjects];
    NSLog(@"buttonClick:");

}

//更新编辑和done之间的切换及tableview的编辑状态。
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if ([_listTableView isEditing]) {
        self.editButtonItem.title = @"Edit";
        [_listTableView setEditing:NO animated:YES];
        
    } else {
        self.editButtonItem.title = @"Done";
        [_listTableView setEditing:YES animated:YES];
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_dataArray removeObjectAtIndex:indexPath.row];
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


//左滑添加按钮
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *likeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"喜欢" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 实现相关的逻辑代码
        // ...
        // 在最后希望cell可以自动回到默认状态，所以需要退出编辑模式
        NSLog(@"点击了喜欢按钮");
        tableView.editing = NO;
    }];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了删除按钮");
        
        [_dataArray removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    return @[deleteAction, likeAction];

}


- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {



}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([tableView isEditing]) {
        //说明 在这里对左边选择的圆圈按钮进行定制，系统默认的为蓝色，这里有时候可能层级会发生过变化，因此做了判断。
        if (cell.subviews.count > 3) {
            if (cell.subviews[3].subviews[0]) {
                ((UIImageView *)(cell.subviews[3].subviews[0])).image = [UIImage imageNamed:@"xz"];
            }
        } else {
            if (cell.subviews[2].subviews[0]) {
                ((UIImageView *)(cell.subviews[2].subviews[0])).image = [UIImage imageNamed:@"xz"];
            }
        }
        [_selectedArray addObject:_dataArray [indexPath.row]];
        [_deleteIndexPaths addObject:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if ([tableView isEditing]) {
        if (cell.subviews.count > 3) {
            if (cell.subviews[3].subviews[0]) {
                ((UIImageView *)(cell.subviews[3].subviews[0])).image = [UIImage imageNamed:@""];
            } else {
                if (cell.subviews[2].subviews[0]) {
                    ((UIImageView *)(cell.subviews[2].subviews[0])).image = [UIImage imageNamed:@""];
                }
            
            }
        }

        if ([_selectedArray containsObject:_dataArray[indexPath.row]]) {
            [_selectedArray removeObject:_dataArray[indexPath.row]];
            [_deleteIndexPaths removeObject:indexPath];
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark -- property
- (UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.allowsMultipleSelectionDuringEditing = YES;
    }
    return _listTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
