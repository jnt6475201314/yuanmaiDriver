//
//  AreaObject.h
//  BIZCarSpider
//
//  Created by fwios001 on 15/12/29.
//  Copyright © 2015年 feiwei. All rights reserved.
//
//区域对象
#import <Foundation/Foundation.h>

@interface AreaObject : NSObject

//省名
@property (copy, nonatomic) NSString *province;
//城市名
@property (copy, nonatomic) NSString *city;
//区县名
@property (copy, nonatomic) NSString *area;

//省id
@property (copy, nonatomic) NSString *provinceId;
//城市id
@property (copy, nonatomic) NSString *cityId;
//区县id
@property (copy, nonatomic) NSString *areaId;

@end