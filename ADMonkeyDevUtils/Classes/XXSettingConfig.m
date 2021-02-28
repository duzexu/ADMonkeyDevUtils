//
//  XXSettingConfig.m
//  MessagerDylib
//
//  Created by MAC on 2021/2/20.
//  Copyright © 2021 123. All rights reserved.
//

#import "XXSettingConfig.h"

@interface ServerSettingForm() {
    NSUserDefaults *userDefaults;
}

@end

@implementation ServerSettingForm

- (instancetype)init
{
    self = [super init];
    if (self) {
        userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (NSDictionary*)setting {
    return @{
    };
}

- (void)setHost:(NSString *)host {
    [userDefaults setValue:host forKey:@"host"];
}

- (NSString *)host {
    NSString *value = [userDefaults stringForKey:@"host"];
    if (value == nil) {
        return @"129.28.203.112:8090";
    }
    return value;
}

- (void)setCookieType:(NSString *)cookieType {
    [userDefaults setValue:cookieType forKey:@"cookieType"];
}

- (NSString *)cookieType {
    NSString *value = [userDefaults stringForKey:@"cookieType"];
    if (value == nil) {
        return @"100";
    }
    return value;
}

- (void)setSocketNum:(NSString *)socketNum {
    [userDefaults setValue:socketNum forKey:@"socketNum"];
}

- (NSString *)socketNum {
    NSString *value = [userDefaults stringForKey:@"socketNum"];
    if (value == nil) {
        return @"11";
    }
    return value;
}

- (void)setRebotTime:(NSInteger)rebotTime {
    [userDefaults setInteger:rebotTime forKey:@"rebotTime"];
}

- (NSInteger)rebotTime {
    NSInteger value = [userDefaults integerForKey:@"rebotTime"];
    if (value == 0) {
        return 60*10;
    }
    return value;
}

@end

@implementation XXSettingConfig

+ (instancetype)shared {
    static XXSettingConfig *_sharedConfig = nil;
    static dispatch_once_t onceToken_config;
    dispatch_once(&onceToken_config, ^{
        _sharedConfig = [[self alloc] init];
    });
    return _sharedConfig;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _config = [[ServerSettingForm alloc] init];
        SettingForm *form = [SettingForm sharedInstance];
        [form registerForm:_config];
    }
    return self;
}

- (void)initSetting {
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeContactAdd];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    btn.backgroundColor = UIColor.systemBlueColor;
    [btn setTitle:@"切换配置" forState:UIControlStateNormal];
    btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-120, [UIScreen mainScreen].bounds.size.height-84, 100, 44);
    [btn addTarget:self action:@selector(presentSettingVC) forControlEvents:UIControlEventTouchUpInside];
    [UIApplication.sharedApplication.keyWindow addSubview:btn];
}

- (void)presentSettingVC {
    MDSettingsViewController *vc = [MDSettingsViewController sharedInstance];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:nav animated:true completion:^{
        
    }];
}

@end
