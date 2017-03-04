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
#import "ImageCollectionViewCell.h"
#import "UIViewController+XHPhoto.h"
#import "YTAnimation.h"

@interface SuggestionViewController ()<TableViewSelectedEvent, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CellDelegate>
{
    UIView * _bgViewOfBtn;
    UIButton * _typeBtn;
    UIImageView * _btnArrowImgView;
    
    CABasicAnimation *animation;
    BOOL arrowImgDown;
    
    BOOL deleteBtnFlag;
    BOOL rotateAniFlag;
    
    UIButton * _submitButton;
}
@property (nonatomic, strong) SuggestTableView * tableView;
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) PlaceholderTextView * suggestTV;
@property (nonatomic, strong) UICollectionView * imageCollectionView;
@property (nonatomic, strong) NSMutableArray * imageArray;
@property (nonatomic, strong) NSMutableDictionary * params;

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
    
    deleteBtnFlag = YES;
    rotateAniFlag = YES;
    [self addDoubleTapGesture];
    
    UILabel * tvTitleLabel = [UILabel labelWithFrame:CGRectMake(30*widthScale,_bgViewOfBtn.bottom + 30*heightScale, _bgViewOfBtn.width, 20) text:@"建议内容：" font:16 textColor:[UIColor darkTextColor]];
    [self.view addSubview:tvTitleLabel];
    
    [self.view addSubview:self.suggestTV];
    
    UILabel * imgTitleLabel = [UILabel labelWithFrame:CGRectMake(30*widthScale,_bgViewOfBtn.bottom + 220*heightScale, _bgViewOfBtn.width, 20) text:@"附加图片：" font:16 textColor:[UIColor darkTextColor]];
    [self.view addSubview:imgTitleLabel];
    
    self.tableView.tabViewDataSource = [[NSMutableArray alloc] initWithArray:self.dataSource];
    [self.view addSubview:self.tableView];
    self.tableView.height = 0;
    
    [self.view addSubview:self.imageCollectionView];
    
    UILabel * tipTitleLabel = [UILabel labelWithFrame:CGRectMake(20*widthScale, self.imageCollectionView.bottom+10*heightScale, _bgViewOfBtn.width, 15*heightScale) text:@"（长按图片可进行编辑、双击空白出退出编辑）" font:12*widthScale textColor:[UIColor lightGrayColor]];
    [self.view addSubview:tipTitleLabel];
    
    _submitButton = [UIButton buttonWithFrame:CGRectMake(screen_width/2-130*widthScale, tipTitleLabel.bottom+40*heightScale, 260*widthScale, 36*heightScale) title:@"提交建议" image:nil target:self action:@selector(submitButtonEvent:)];
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
        
        [self DealwithSubmitSuggestionParams];  // 处理网络请求的参数
        [self NetWorkOfSubmitSuggestion];   // 提交建议的网络请求
    }];
}

- (void)DealwithSubmitSuggestionParams
{
    if (![_typeBtn.currentTitle isEqualToString:@"请选择建议类型"]) {
        [self.params setValue:[NSString stringWithFormat:@"意见类型：%@，建议内容：%@", _typeBtn.currentTitle,self.suggestTV.text] forKey:@"content"];
    }else
    {
        [self.params setValue:[NSString stringWithFormat:@"建议内容：%@", self.suggestTV.text] forKey:@"content"];
    }
    
#warning 其实可以本来可以节省很多代码，原来是宿静不会这样弄。。。。😓
#if 0
    NSMutableArray * imgArray = [NSMutableArray arrayWithArray:self.imageArray];
    NSMutableArray * baseImgArr = [[NSMutableArray alloc] init];
    for (int i = 1; i < imgArray.count; i++) {
        UIImage * image = imgArray[i];
        NSData * imgData = UIImageJPEGRepresentation(image, 0.5f);
        NSString * image64 = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [baseImgArr addObject:image64];
    }
    
    //    NSLog(@"baseImgArr : **%@***  count :%ld", baseImgArr, baseImgArr.count);
    [self.params setObject:baseImgArr forKey:@"arr"];
#endif
    
#if 1
    
    NSInteger count = self.imageArray.count;
    switch (count) {
        case 1:
            // 没有添加图片
            break;
        case 2:
            // 1张
        {
            UIImage * image = self.imageArray[1];
            NSData * imgData = UIImageJPEGRepresentation(image, 1.0f);
            NSString * image64 = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [self.params setObject:image64 forKey:@"photo_a"];
        }
            break;
        case 3:
            // 2。。
        {
            for (int i = 1; i<3; i++) {
                UIImage * image = self.imageArray[i];
                NSData * imgData = UIImageJPEGRepresentation(image, 1.0f);
                NSString * image64 = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                if (i == 1) {
                    [self.params setObject:image64 forKey:@"photo_a"];
                }else if (i == 2){
                    [self.params setObject:image64 forKey:@"photo_b"];
                }
            }
        }
            break;
        default:
            break;
    }
    
#endif
    
    
}

- (void)NetWorkOfSubmitSuggestion
{
    NSLog(@"%@?%@", API_SUGGESTION_URL, self.params);
    [self showHUD:@"正在提交，请稍候。。。" isDim:YES];
    [NetRequest postDataWithUrlString:API_SUGGESTION_URL withParams:self.params success:^(id data) {
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

#pragma mark - UICollectionView delegate dataSource
#pragma mark 定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

#pragma mark 定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark 每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"imageCollectionView";
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        cell.imgView.image = [UIImage imageNamed:self.imageArray[indexPath.item]];
        //        cell.userInteractionEnabled = NO;
        cell.deleteBtn.hidden = YES;
    }else{
        cell.indexPath = indexPath;
        cell.deleteBtn.hidden = deleteBtnFlag?YES:NO;
        cell.delegate = self;
        if (!rotateAniFlag) {
            [YTAnimation vibrateAnimation:cell];
        }else{
            [cell.layer removeAnimationForKey:@"shake"];
        }
        cell.imgView.image = self.imageArray[indexPath.item];
    }
    return cell;
}

// 点击每个cell触发的事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == 0) {
        // 点击了添加相片按钮
        NSLog(@"点击了添加相片按钮");
        [self.view endEditing:YES];
        if (self.imageArray.count < 3) {
            [self hideAllDeleteBtn];
            [self showCanEdit:YES photo:^(UIImage *photo) {
                [self.imageArray addObject:photo];
                [self.imageCollectionView reloadData];
            }];
        }else{
            [self showTipView:@"图片数量不能超过2张哦😯"];
        }
        
    }
}

#pragma mark - CellDelegate
-(void)deleteCellAtIndexpath:(NSIndexPath *)indexPath cellView:(ImageCollectionViewCell *)cell{
    if (self.imageArray.count < 1) {
        [self hideAllDeleteBtn];
        return;
    }
    
    [self.imageCollectionView performBatchUpdates:^{
        cell.imgView.image = nil;
        cell.deleteBtn.hidden = YES;
        
        [YTAnimation fadeAnimation:cell];
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ULL * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            
            // 延时1s执行， 下面这两行执行删除cell的操作，包括移除数据源和删除item， 如果你用到数据库或者coreData
            // 要先删掉数据库里的内容，再执行移除数据源和删除item
            [self.imageArray removeObjectAtIndex:indexPath.row];
            [self.imageCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        });
    } completion:^(BOOL finished) {
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ULL * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            
            [self.imageCollectionView reloadData];
        });
    }];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *) gestureRecognizer
{
    [self hideAllDeleteBtn];
}

-(void)addDoubleTapGesture{
    UITapGestureRecognizer *doubletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubletap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubletap];
}

-(void)hideAllDeleteBtn{
    if (!deleteBtnFlag) {
        deleteBtnFlag = YES;
        rotateAniFlag = YES;
        [self.imageCollectionView reloadData];
    }
}

-(void)showAllDeleteBtn{
    deleteBtnFlag = NO;
    rotateAniFlag = NO;
    [self.imageCollectionView reloadData];
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

-(UICollectionView *)imageCollectionView{
    if (_imageCollectionView == nil) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        //        flowLayout.headerReferenceSize = CGSizeMake(screen_width, screen_height/4);
        
        _imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(screen_width/2-140*widthScale, _suggestTV.bottom + 50*heightScale, 280*widthScale, 86*heightScale) collectionViewLayout:flowLayout];
        
        // 定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake(83, 76);
        // 定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 5*widthScale;
        // 定义每个UICollectionView 的纵向间距
        flowLayout.minimumInteritemSpacing = 0;
        // 定义每个UICollectionView 的边距
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5); // 上左下右
        
        //注册cell和ReusableView（相当于头部）
        [_imageCollectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"imageCollectionView"];
        
        //设置代理
        _imageCollectionView.delegate = self;
        _imageCollectionView.dataSource = self;
        
        //背景颜色
        _imageCollectionView.backgroundColor = [UIColor clearColor];
        //自适应大小
        _imageCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _imageCollectionView;
}

-(NSMutableArray *)imageArray{
    if (_imageArray == nil) {
        _imageArray = [[NSMutableArray alloc] initWithObjects:@"addPhoto_img", nil];
    }
    return _imageArray;
}

-(NSMutableDictionary *)params
{
    if (!_params) {
        _params = [[NSMutableDictionary alloc] initWithDictionary:@{@"driver_id":GETDriver_ID}];
    }
    return _params;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backClick:(UIButton *)button
{
    [self addAnimationWithType:TAnimationReveal Derection:FAnimationFromBottom];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
