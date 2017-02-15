//
//  SuggestionViewController.m
//  SpecialLine
//
//  Created by 姜宁桃 on 2017/1/7.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "SuggestionViewController.h"
#import "SuggestTableView.h"
#import "SuggestionTableViewCell.h"
#import "PlaceholderTextView.h"
//#import "ImageCollectionViewCell.h"
//#import "UIViewController+XHPhoto.h"
//#import "YTAnimation.h"

@interface SuggestionViewController ()<TableViewSelectedEvent, UITextViewDelegate, UITextFieldDelegate> // UICollectionViewDelegate, UICollectionViewDataSource, CellDelegate>
{
    UIView * _bgViewOfBtn;
    UIButton * _typeBtn;
    UIImageView * _btnArrowImgView;
    
    CABasicAnimation *animation;
    BOOL arrowImgDown;
//
//    BOOL deleteBtnFlag;
//    BOOL rotateAniFlag;
    
    UITextField * _contactTF;
    UIButton * _submitButton;
}
@property (nonatomic, strong) SuggestTableView * tableView;
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) PlaceholderTextView * suggestTV;
//@property (nonatomic, strong) UICollectionView * imageCollectionView;
//@property (nonatomic, strong) NSMutableArray * imageArray;
//@property (nonatomic, strong) NSMutableDictionary * params;

@end

@implementation SuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"意见建议";
    [self showBackBtn];
    [self configUI];
}

- (void)configUI
{
    _bgViewOfBtn = [[UIView alloc] initWithFrame:CGRectMake(screen_width/2-130*widthScale, 64+20*heightScale, 260*widthScale, 40)];
    _bgViewOfBtn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_bgViewOfBtn];
    
    _typeBtn = [UIButton buttonWithFrame:CGRectMake(_bgViewOfBtn.width/2-72*widthScale, 5, 120*widthScale, 30) title:@"请选择建议类型" image:nil target:self action:@selector(suggestTypeButtonEvent:)];
    [_typeBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    _typeBtn.titleLabel.font = systemFont(16);
    [_bgViewOfBtn addSubview:_typeBtn];
    
    _btnArrowImgView = [UIImageView imageViewWithFrame:CGRectMake(_typeBtn.right+1, 14, 23, 12) image:@"suggest-arrow-down"];
    [_bgViewOfBtn addSubview:_btnArrowImgView];
    
    animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI*2];
    animation.duration  = 0.2;
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = 1;
    
    arrowImgDown = YES;
    
//    deleteBtnFlag = YES;
//    rotateAniFlag = YES;
//    [self addDoubleTapGesture];
    
    UILabel * tvTitleLabel = [UILabel labelWithFrame:CGRectMake(30*widthScale,_bgViewOfBtn.bottom + 30*heightScale, _bgViewOfBtn.width, 20) text:@"建议内容：" font:16 textColor:[UIColor darkTextColor]];
    [self.view addSubview:tvTitleLabel];
    
    [self.view addSubview:self.suggestTV];
    
    UILabel * imgTitleLabel = [UILabel labelWithFrame:CGRectMake(30*widthScale,_bgViewOfBtn.bottom + 220*heightScale, _bgViewOfBtn.width, 20) text:@"联系方式：" font:16 textColor:[UIColor darkTextColor]];
    [self.view addSubview:imgTitleLabel];
    
    self.tableView.tabViewDataSource = [[NSMutableArray alloc] initWithArray:self.dataSource];
    [self.view addSubview:self.tableView];
    self.tableView.height = 0;
    
    _contactTF = [[UITextField alloc] initWithFrame:CGRectMake(screen_width/2-130*widthScale, imgTitleLabel.bottom+10*heightScale, 260*widthScale, 40*heightScale)];
    _contactTF.backgroundColor = [UIColor whiteColor];
    _contactTF.placeholder = @"请输入您的手机号或邮箱";
    _contactTF.delegate = self;
    _contactTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _contactTF.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:_contactTF];
//    [self.view addSubview:self.imageCollectionView];
    
//    UILabel * tipTitleLabel = [UILabel labelWithFrame:CGRectMake(20*widthScale, self.imageCollectionView.bottom+10*heightScale, _bgViewOfBtn.width, 15*heightScale) text:@"（长按图片可进行编辑、双击空白出退出编辑）" font:12*widthScale textColor:[UIColor lightGrayColor]];
//    [self.view addSubview:tipTitleLabel];
    
    _submitButton = [UIButton buttonWithFrame:CGRectMake(screen_width/2-130*widthScale, screen_height - 42*heightScale, 260*widthScale, 36*heightScale) title:@"提交建议" image:nil target:self action:@selector(submitButtonEvent:)];
    _submitButton.enabled = NO;
    _submitButton.backgroundColor = [UIColor grayColor];
    _submitButton.titleLabel.font = boldSystemFont(16);
    _submitButton.layer.cornerRadius = 18*widthScale;
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_submitButton];
}

#pragma mark - Event Hander
- (void)suggestTypeButtonEvent:(UIButton *)btn
{
    [self.view endEditing:YES];
    if (arrowImgDown) {
        [UIView animateWithDuration:0.3 animations:^{
            
            [_typeBtn setTitleColor:color(20, 150, 219, 1) forState:UIControlStateNormal];
            [_btnArrowImgView.layer addAnimation:animation forKey:nil];
            _bgViewOfBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
            _btnArrowImgView.image = [UIImage imageNamed:@"suggestion-arrow-up"];
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
                
                self.tableView.height = 180*heightScale;
            } completion:nil];
            
        }completion:^(BOOL finished) {
            
            arrowImgDown = !arrowImgDown;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            
            [_btnArrowImgView.layer addAnimation:animation forKey:nil];
            _bgViewOfBtn.backgroundColor = [UIColor lightGrayColor];
            _btnArrowImgView.image = [UIImage imageNamed:@"suggest-arrow-down"];
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                
                self.tableView.height = 0;
            } completion:nil];
            
        }completion:^(BOOL finished) {
            
            arrowImgDown = !arrowImgDown;
        }];
    }
    
}

- (void)submitButtonEvent:(UIButton *)btn
{
    _submitButton.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _submitButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
        if (_suggestTV.text.length == 0 || _contactTF.text.length == 0) {
            
            [self showTipView:@"建议内容或联系方式不能为空！"];
        }else
        {
            [self NetWorkOfSubmitSuggestion];   // 提交建议的网络请求
        }
    }];
}

- (void)NetWorkOfSubmitSuggestion
{
    NSString * suggestionContent;
    if (![_typeBtn.currentTitle isEqualToString:@"请选择建议类型"]) {
        suggestionContent = [NSString stringWithFormat:@"意见类型：%@，建议内容：%@", _typeBtn.currentTitle,self.suggestTV.text];
    }else
    {
        suggestionContent = [NSString stringWithFormat:@"建议内容：%@", self.suggestTV.text];
    }
    
    NSDictionary *params = @{@"content":suggestionContent,@"tel":_contactTF.text,@"driver_id":GETDriver_ID};
    [self showHUD:@"正在提交，请稍候。。。" isDim:YES];
    [NetRequest postDataWithUrlString:API_SUGGESTION_URL withParams:params success:^(id data) {
        [self hideHUD];
        NSLog(@"%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showTipView:data[@"message"]];
            });
        }else if ([data[@"code"] isEqualToString:@"2"]){
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showTipView:data[@"message"]];
            });
        }
    } fail:^(NSString *errorDes) {
        NSLog(@"%@", errorDes);
        [self hideHUD];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showTipView:@"提交失败！请检查当前网络状态或联系客服"];
        });
    }];
}

#pragma mark - TableViewSelectedEvent
-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [_btnArrowImgView.layer addAnimation:animation forKey:nil];
        _bgViewOfBtn.backgroundColor = [UIColor lightGrayColor];
        _btnArrowImgView.image = [UIImage imageNamed:@"suggest-arrow-down"];
        [_typeBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [_typeBtn setTitle:self.tableView.tabViewDataSource[indexPath.section] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            
            self.tableView.height = 0;
        } completion:nil];
        
    }completion:^(BOOL finished) {
        
        arrowImgDown = !arrowImgDown;
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.suggestTV.text.length > 0) {
        [UIView animateWithDuration:0.2 animations:^{
            
            _submitButton.backgroundColor = color(39, 173, 93, 1);
        }completion:^(BOOL finished) {
            _submitButton.enabled = YES;
        }];
    }else
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            _submitButton.backgroundColor = [UIColor grayColor];
        }completion:^(BOOL finished) {
            _submitButton.enabled = NO;
        }];
    }
}

#pragma mark - Getter
-(SuggestTableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[SuggestTableView alloc] initWithFrame:CGRectMake(screen_width/2-130*widthScale, _bgViewOfBtn.bottom, 260*widthScale, 180*heightScale) style:UITableViewStylePlain cellHeight:40];
        _tableView.tableViewEventDelegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"SuggestionTableViewCell" bundle:nil] forCellReuseIdentifier:@"suggestionCell"];
        [_tableView.mj_header removeFromSuperview];
        [_tableView.mj_footer removeFromSuperview];
        _tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _tableView.layer.borderWidth = 1;
    }
    return _tableView;
}

-(NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@"APP功能", @"服务态度", @"收派服务", @"其他建议"];
    }
    return _dataSource;
}

-(PlaceholderTextView *)suggestTV
{
    if (!_suggestTV) {
        _suggestTV = [[PlaceholderTextView alloc] initWithFrame:CGRectMake(screen_width/2-130*widthScale, _bgViewOfBtn.bottom+60*heightScale, 260*widthScale, 140*heightScale)];
        _suggestTV.delegate = self;
        _suggestTV.font = systemFont(15);
        _suggestTV.textColor = [UIColor blackColor];
        _suggestTV.placeholder = @"请在这里填写建议内容";
        _suggestTV.layer.borderWidth = 1.0;
        _suggestTV.layer.borderColor = [UIColor darkTextColor].CGColor;
        _suggestTV.clipsToBounds = YES;
    }
    return _suggestTV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backClick:(UIButton *)button
{
    [self addAnimationWithType:TAnimationPageUnCurl Derection:FAnimationFromLeft];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
