//
//  AssetListViewController.h
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/28.
//  Copyright © 2016年 Key. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property BOOL isShowVideo;

@property (copy, nonatomic) void (^address)(NSString *address);

@end
