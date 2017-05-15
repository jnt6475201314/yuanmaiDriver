//
//  ServiceCollectionView.m
//  yuanmaiDriver
//
//  Created by 姜宁桃 on 2017/5/15.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "ServiceCollectionView.h"
#import "ServiceCollectionViewCell.h"

@interface ServiceCollectionView ()<CollectionViewEventDelegate>

@end

@implementation ServiceCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self registerNib:[UINib nibWithNibName:@"ServiceCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ServiceCollectionViewCell"];
        
    }
    return self;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ServiceCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceCollectionViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.data[indexPath.row];
    cell.service_image.image = [UIImage imageNamed:dic[@"image"]];
    cell.service_lab.text = dic[@"lab"];
    return cell;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
