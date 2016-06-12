//
//  SelectTableViewCell.m
//  SelectAndMutiSelect
//
//  Created by offcn_c on 16/5/20.
//  Copyright © 2016年 offcn_c. All rights reserved.
//

#import "SelectTableViewCell.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define CELLHEIGHT 60.f //设置单元格高度

@interface SelectTableViewCell()

@property (nonatomic, weak) UIView *containerView;

//@property (nonatomic, weak) UILabel *infoLabel;
@property (nonatomic, weak) UIButton *deleteBtn;

@property (nonatomic, weak) UIPanGestureRecognizer *panGes;//拖拽手势

@end
@implementation SelectTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubControls];
    }
    return  self;
}

- (void)initSubControls {
    //1.添加底层的删除按钮
    
    UIButton *deleteBtn = [[UIButton alloc]init];
    [self.contentView addSubview:deleteBtn];
    self.deleteBtn = deleteBtn;
    
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn setBackgroundColor:[UIColor redColor]];
    
    [self.deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加外层显示控件
    UIView *containerView = [[UIView alloc]init];
    [self.contentView addSubview:containerView];
    
    self.containerView = containerView;
    self.containerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *infoLabel = [[UILabel alloc]init];
    [self.containerView addSubview:infoLabel];
    self.infoLabel = infoLabel;
    self.infoLabel.textColor = [UIColor blackColor];
    
    //给容器containerView加入手势
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    self.panGes = panGes;
    [self.containerView addGestureRecognizer:panGes];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView bringSubviewToFront:self.containerView];

}

- (void)layoutSubviews {
    CGFloat deleteWidth = SCREENWIDTH * 0.2;
    self.deleteBtn.frame = CGRectMake(SCREENWIDTH * 0.8, 0, deleteWidth, CELLHEIGHT);
    self.containerView.frame = self.contentView.bounds;
    self.infoLabel.frame = CGRectMake(0, 0, SCREENWIDTH, CELLHEIGHT - 1);
    

}


- (void)pan:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
//        if (self.delegate respondsToSelector:@selector(<#selector#>)) {
//            <#statements#>
//        }
        if (sender.view.frame.origin.x < -SCREENWIDTH * 0.25) {
            sender.view.transform = CGAffineTransformMakeTranslation(-SCREENWIDTH * 0.5, 0);
            [sender setTranslation:CGPointZero inView:sender.view];
        } else {
            [self closeLeftPan];
        }
    }
    
    CGPoint point = [sender translationInView:self.contentView];
    
    CGFloat tx = sender.view.transform.tx;
    
    if (tx < - SCREENWIDTH * 0.5 || tx > 0) return;
    
    //形变
    sender.view.transform = CGAffineTransformTranslate(sender.view.transform, point.x, 0);
    [sender setTranslation:CGPointZero inView:sender.view];  //必须归0

}

- (void)closeLeftPan {
    self.panGes.view.transform = CGAffineTransformMakeTranslation(0, 0);
    [self.panGes setTranslation:CGPointZero inView:self.panGes.view];  //必须归0

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
