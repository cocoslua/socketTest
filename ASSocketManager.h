//
//  ASSocketManager.h
//  socketTest
//
//  Created by 刘兴丰 on 16/7/3.
//  Copyright © 2016年 刘兴丰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "AsyncUdpSocket.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

enum{
    SocketOfflineByServer, //服务器掉线
    SocketOfflineByUser , //用户挂断
};

@interface ASSocketManager : NSObject<AsyncSocketDelegate>
@property (nonatomic, retain)AsyncSocket* socket;
@property (nonatomic, retain)NSString *host;
@property (nonatomic)UInt16 port;

+(ASSocketManager*)manager;
-(void)connectToHost;
-(void)cutOffConnect;

@end
