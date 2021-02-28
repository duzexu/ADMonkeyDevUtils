//
//  FSLocalWebServer.h
//  Pie
//
//  Created by aa on 2018/6/4.
//  Copyright © 2018年 xx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol XXWebServerDelegate <NSObject>

@optional
- (void)didReceiveMessage:(id)message;
- (void)appWillCrash;

@end

@interface XXWebServer : NSObject

@property (nonatomic, weak) id<XXWebServerDelegate> delegate;

@property (nonatomic, copy) NSString *webPort;//端口号
@property (nonatomic, copy) NSString *localServerUrl;//本地服务器url

- (void)startLocalServerWithConnectionClass:(Class)cls;
- (void)startWebServer;

- (void)sendData:(NSDictionary *)json;

@end
