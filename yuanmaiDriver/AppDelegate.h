//
//  AppDelegate.h
//  yuanmaiDriver
//
//  Created by 姜宁桃 on 2017/1/26.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

