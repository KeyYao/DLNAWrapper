//
//  DeviceListViewController.h
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/20.
//  Copyright © 2016年 Key. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic) void (^selectedDevice)(int index);

@end
