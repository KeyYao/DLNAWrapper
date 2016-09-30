//
//  InputAddressViewController.h
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/28.
//  Copyright © 2016年 Key. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputAddressViewController : UIViewController <UITextFieldDelegate>

@property (copy, nonatomic) void (^address)(NSString *address);

@end
