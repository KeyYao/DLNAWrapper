//
//  InputAddressViewController.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/28.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "InputAddressViewController.h"

#import "Masonry.h"

#import "ExampleDefine.h"
#import "UIColor+ColorFormat.h"


@interface InputAddressViewController ()

@property UITextField *inputView;

@end

@implementation InputAddressViewController

@synthesize address;
@synthesize inputView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    UIView *statusBarView = [[UIView alloc] initWithFrame:statusBarFrame];
    statusBarView.backgroundColor = THEME_COLOR;
    [self.view addSubview:statusBarView];
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = @"输入地址";
    topLabel.textColor = [UIColor whiteColor];
    topLabel.backgroundColor = THEME_COLOR;
    topLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:topLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    inputView = [[UITextField alloc] init];
    [inputView setBorderStyle:UITextBorderStyleRoundedRect];
    [inputView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [inputView setAutocorrectionType:UITextAutocorrectionTypeNo];
    inputView.placeholder = @"请输入地址";
    inputView.returnKeyType = UIReturnKeyDone;
    inputView.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputView.delegate = self;
    [self.view addSubview:inputView];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.layer.cornerRadius = 8;
    [confirmBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:THEME_COLOR];
    [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(statusBarView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@50);
    }];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(5);
        make.centerY.equalTo(topLabel);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLabel.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirm:(id)sender {
    if ([inputView.text isEqualToString:@""]) {
        return;
    }
    address(inputView.text);
    [self back:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.inputView resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
