//
//  ViewController.m
//  socketTest
//
//  Created by 刘兴丰 on 16/7/3.
//  Copyright © 2016年 刘兴丰. All rights reserved.
//

#import "ViewController.h"
#import "ASSocketManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    ASSocketManager* socketManager = [ASSocketManager manager];
    socketManager.host = @"127.0.0.1";
    socketManager.port = 10005;
    
//    //手动断开
//    socketManager.socket.userData = SocketOfflineByUser;
//    [socketManager cutOffConnect];
    
    //开始连接
    socketManager.socket.userData = SocketOfflineByServer;
    [socketManager connectToHost];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
