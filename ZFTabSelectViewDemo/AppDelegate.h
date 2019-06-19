//
//  AppDelegate.h
//  ZFTabSelectViewDemo
//
//  Created by 张学飞 on 2019/6/19.
//  Copyright © 2019 zxf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

