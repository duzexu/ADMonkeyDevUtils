//
//  FSLocalWebServer.m
//  Pie
//
//  Created by aa on 2018/6/4.
//  Copyright © 2018年 xx. All rights reserved.
//

#import "XXWebServer.h"
#import "HTTPServer.h"
#import "GCDAsyncSocket.h"
#import "SocketRocket.h"
#import "XXSettingConfig.h"

@interface XXWebServer ()<GCDAsyncSocketDelegate,SRWebSocketDelegate>

@property (nonatomic, strong) HTTPServer *localHttpServer;
@property (nonatomic, strong) SRWebSocket *webSocket;
@property (nonatomic, strong) NSTimer *pingTimer;

@end

@implementation XXWebServer

- (instancetype)init {
    self = [super init];
    if (self) {
        InstallSignalHandler();//信号量截断
        InstallUncaughtExceptionHandler();//系统异常捕获
        
        _pingTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(sendPing) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)startLocalServerWithConnectionClass:(Class)cls {
    _localHttpServer = [[HTTPServer alloc] init];
    [_localHttpServer setType:@"_http.tcp"];
    [_localHttpServer setPort:8888];
    [_localHttpServer setConnectionClass:cls];
    NSError *error;
    if([_localHttpServer start:&error]) {
        NSLog(@"[XXWebServer]Started HTTP Server on port %hu", [_localHttpServer listeningPort]);
        self.webPort = [NSString stringWithFormat:@"%d",[_localHttpServer listeningPort]];
        self.localServerUrl = [NSString stringWithFormat:@"http://localhost:%@",self.webPort];
    }
}

- (void)startWebServer {
    NSString *url = [NSString stringWithFormat:@"ws://%@/websocket/ttht_junFXINYU%@",[XXSettingConfig.shared.config host],[XXSettingConfig.shared.config socketNum]];
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    _webSocket.delegate = self;
    [_webSocket open];
}

- (void)sendData:(NSDictionary *)json {
    if (_webSocket.readyState == SR_OPEN) {
        if (json) {
            NSString *message = [self jsonEncodeString:json];
            NSDictionary *result = @{@"fromUsername":[@"ttht_junFXINYU" stringByAppendingString:[XXSettingConfig.shared.config socketNum]],@"toUsername": [@"ttht_junSXINYU" stringByAppendingString:[XXSettingConfig.shared.config socketNum]],@"message":message,@"messageType": @"single"};
            NSLog(@"[XXWebServer]返回数据：%@",result);
            [self.webSocket send:[self jsonEncodeData:result]];
        }
    }
}

- (void)sendPing {
    if(_webSocket.readyState == SR_OPEN){
        [_webSocket sendPing:nil];
    }
}

// SRWebSocketDelegate
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    if (_webSocket.readyState == SR_OPEN) {
        if (message) {
            [_delegate didReceiveMessage:message];
        }
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"[XXWebServer]webSocket连接成功 %@",[webSocket url]);
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"[XXWebServer]连接断开 %@",error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"[XXWebServer]连接关闭 %@", reason);
}

- (BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket {
    return NO;
}

- (NSString *)jsonEncodeString:(NSDictionary *)json {
    if (json) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return string ? string : @"";
    }
    return @"";
}

- (NSString *)jsonEncodeData:(NSDictionary *)json {
    if (json) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
        return data;
    }
    return @"";
}

//异常捕获
void SignalExceptionHandler(int signal)
{
    NSLog(@"[旺信]崩溃");
}

void InstallSignalHandler(void)
{
   signal(SIGHUP, SignalExceptionHandler);
   signal(SIGINT, SignalExceptionHandler);
   signal(SIGQUIT, SignalExceptionHandler);

   signal(SIGABRT, SignalExceptionHandler);
   signal(SIGILL, SignalExceptionHandler);
   signal(SIGSEGV, SignalExceptionHandler);
   signal(SIGFPE, SignalExceptionHandler);
   signal(SIGBUS, SignalExceptionHandler);
   signal(SIGPIPE, SignalExceptionHandler);
}

void HandleException(NSException *exception)
{
   // 异常的堆栈信息
   NSArray *stackArray = [exception callStackSymbols];
   // 出现异常的原因
   NSString *reason = [exception reason];
   // 异常名称
   NSString *name = [exception name];
   NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name:%@\nException stack：%@",name, reason, stackArray];
   NSLog(@"[旺信]崩溃信息%@", exceptionInfo);
}

void InstallUncaughtExceptionHandler(void)
{
   NSSetUncaughtExceptionHandler(&HandleException);
}

@end

