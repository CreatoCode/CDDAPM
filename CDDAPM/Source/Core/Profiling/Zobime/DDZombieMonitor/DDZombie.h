////  HYZombie.h
//  DDZombieDetector
//
//  Created by Alex Ting on 2018/7/14.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

// 如果打开这个，通常没有成员变量的类都会大于DDZombie的大小，导致不会跟踪
//#define TrackThreadStack

class DDThreadStack;

@interface DDZombie : NSObject

@property (nonatomic, assign)Class realClass;
#ifdef TrackThreadStack
@property (nonatomic, assign)DDThreadStack *threadStack;
#else
@property (nonatomic, assign, readonly)DDThreadStack *threadStack;
#endif

+ (Class)zombieIsa;
+ (NSInteger)zombieInstanceSize;

@end
