//
//  ASSocketManager.m
//  socketTest
//
//  Created by 刘兴丰 on 16/7/3.
//  Copyright © 2016年 刘兴丰. All rights reserved.
//

#import "ASSocketManager.h"

@interface ASSocketManager()
@property (nonatomic, retain)NSTimer* connectTimer;

@end

@implementation ASSocketManager

+(ASSocketManager*)manager{
    static ASSocketManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ASSocketManager alloc] init];
    });
    
    return manager;
}

-(void)connectToHost{
    self.socket = [[AsyncSocket alloc] initWithDelegate:self];
    NSError* err = nil;
    [self.socket connectToHost:self.host onPort:self.port withTimeout:3 error:&err];
}

-(void)longConnectToHost{
    
    //发送固定心跳包要和服务器端协商
    NSString *longConnect = @"hello socket !";
    NSData* dataStream = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:dataStream withTimeout:1 tag:1];
}

-(void)cutOffConnect{
    self.socket.userData = SocketOfflineByUser ; //声明是用户切断的
    
    [self.connectTimer invalidate];
    [self.socket disconnect];
}

#pragma mark asyncSocketDelegate
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    NSLog(@"socket connected successed!");
    
    //添加监听，接收服务器端的消息
    [self.socket readDataWithTimeout:-1 tag:0];
    
    //定时发送心跳包检测状态
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(longConnectToHost) userInfo:nil repeats:YES];
    [self.connectTimer fire];
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"received data : \n %@",dataString);
}

-(void)onSocketDidDisconnect:(AsyncSocket *)sock{
    
    NSLog(@"sorry the connect is failure %ld",sock.userData);
    if (sock.userData == SocketOfflineByServer) {
        // 服务器掉线，重连
        [self connectToHost];
    }
    else if (sock.userData == SocketOfflineByUser) {
        // 如果由用户断开，不进行重连
        return;
    }
}

@end
