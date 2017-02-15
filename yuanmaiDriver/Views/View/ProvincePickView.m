//
//  ProvincePickView.m
//  ProvinceSelectView
//
//  Created by 李挺哲 on 2016/11/25.
//  Copyright © 2016年 李挺哲. All rights reserved.
//

#import "ProvincePickView.h"
#define kPVH (kWinH*0.35>230?230:(kWinH*0.35<200?200:kWinH*0.35))
#define kWinH [[UIScreen mainScreen] bounds].size.height
#define kWinW [[UIScreen mainScreen] bounds].size.width

#import "ProvinceCollectionViewCell.h"
@interface ProvincePickView()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation ProvincePickView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (instancetype)init
{
    if (self = [super initWithFrame:[[UIScreen mainScreen] bounds]]) {
        
//        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        //半透明背景按钮
        _bgButton = [[UIButton alloc] init];
        [self addSubview:_bgButton];
        [_bgButton addTarget:self action:@selector(dismissPicker) forControlEvents:UIControlEventTouchUpInside];
        _bgButton.backgroundColor = [UIColor blackColor];
        //        _bgButton.alpha = 0.1;
        _bgButton.frame = CGRectMake(0, 0, kWinW, kWinH);
        
        //时间选择View
        _pickerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ProvinceView class]) owner:self options:nil].lastObject;
        [self addSubview:_pickerView];
        _pickerView.frame = CGRectMake(0, kWinH, kWinW, kPVH);
        
        _pickerView.collectionView.delegate=self;
        
        _pickerView.collectionView.dataSource=self;
        [_pickerView.collectionView registerNib:[UINib nibWithNibName:@"ProvinceCollectionViewCell"
                                                               bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"ProvinceCollectionViewCell"];
        
        _provinceArray=[NSMutableArray array];
        
    }
    return self;
}

#pragma  mark UICollectionView delegate 方法

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSInteger count= _provinceArray.count;
    

    return _provinceArray.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    

    return 1;
    
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"ProvinceCollectionViewCell";
    
    ProvinceCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.label.text=_provinceArray[indexPath.row][@"name"];
    
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
////定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(_pickerView.collectionView.frame.size.width/8-10, _pickerView.collectionView.frame.size.height/4-10);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(2, 2 , 2,2);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    if ([_delegate respondsToSelector:@selector(provincePickViewDidPick:)]) {
        [_delegate provincePickViewDidPick:indexPath.row];
    }
    
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


//出现
- (void)showPicker
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.pickerView.frame = CGRectMake(0, kWinH - kPVH, kWinW, kPVH);
        weakSelf.bgButton.alpha = 0.2;
        
        weakSelf.hidden=NO;
    }];
}

//消失
- (void)dismissPicker
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.pickerView.frame = CGRectMake(0, kWinH, kWinW, kPVH);
        weakSelf.bgButton.alpha = 0.0;
    } completion:^(BOOL finished) {

         weakSelf.hidden=YES;
        
        if ([_delegate respondsToSelector:@selector(provincePickViewDisMissed) ]) {
            [_delegate provincePickViewDisMissed];
        }
        
    }];
}


-(void)reLoadData{
    
    [self.pickerView.collectionView reloadData];

}

@end
