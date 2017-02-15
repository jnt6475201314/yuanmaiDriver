//
//  ScanModel.h
//  yuanmaiDriver
//
//  Created by 姜宁桃 on 2017/2/9.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ScanModel : JSONModel

@property (nonatomic, copy) NSString<Optional> * gid;
@property (nonatomic, copy) NSString<Optional> * qr_code;
@property (nonatomic, copy) NSString<Optional> * state;

@end
