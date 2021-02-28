//
//  XXSettingConfig.h
//  MessagerDylib
//
//  Created by MAC on 2021/2/20.
//  Copyright © 2021 123. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDSettingCenter.h"
#import "MDSettingsViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface ServerSettingForm : NSObject<FXForm>

@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSString *cookieType;
@property (nonatomic, copy) NSString *socketNum;
@property (nonatomic, assign) NSInteger rebotTime;

@end

@interface XXSettingConfig : NSObject

@property (nonatomic, strong) ServerSettingForm *config;

+ (instancetype)shared;
- (void)initSetting;

@end

NS_ASSUME_NONNULL_END
