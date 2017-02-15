//
//  AreaObject.m
//  BIZCarSpider
//
//  Created by fwios001 on 15/12/29.
//  Copyright © 2015年 feiwei. All rights reserved.
//

#import "AreaObject.h"

@implementation AreaObject

- (NSString *)description{
    return [NSString stringWithFormat:@"%@ %@ %@",self.province,self.city,self.area];
}

@end