//
//  AssetListViewController.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/28.
//  Copyright © 2016年 Key. All rights reserved.
//

#import <Photos/Photos.h>
#import "Masonry.h"

#import "ExampleDefine.h"
#import "UIColor+ColorFormat.h"
#import "FileServer.h"

#import "AssetListViewController.h"
#import "AssetTableViewCell.h"

#define ASSET_CELL_ID @"AssetCellId"

@interface AssetListViewController ()

@property UITableView *assetTable;
@property NSMutableArray<PHAsset *> *assetArray;

@end

@implementation AssetListViewController

@synthesize isShowVideo;
@synthesize address;
@synthesize assetTable;
@synthesize assetArray;

- (instancetype)init
{
    self = [super init];
    if (self) {
        assetArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    UIView *statusBarView = [[UIView alloc] initWithFrame:statusBarFrame];
    statusBarView.backgroundColor = THEME_COLOR;
    [self.view addSubview:statusBarView];
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = [NSString stringWithFormat:@"选择%@", isShowVideo ? @"视频" : @"图片"];
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
    
    assetTable = [[UITableView alloc] init];
    assetTable.tableFooterView = [[UIView alloc] init];
    assetTable.rowHeight = 68;
    assetTable.dataSource = self;
    assetTable.delegate = self;
    [assetTable registerClass:AssetTableViewCell.class forCellReuseIdentifier:ASSET_CELL_ID];
    [self.view addSubview:assetTable];
    
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
    
    [assetTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLabel.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *result = [PHAsset fetchAssetsWithOptions:options];
    for (PHAsset *asset in result) {
        if (isShowVideo) {
            if (asset.mediaType == PHAssetMediaTypeVideo) {
                [assetArray addObject:asset];
            }
        } else {
            if (asset.mediaType == PHAssetMediaTypeImage) {
                [assetArray addObject:asset];
            }
        }
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [assetArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AssetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ASSET_CELL_ID forIndexPath:indexPath];
    
    PHAsset *asset = [assetArray objectAtIndex:indexPath.row];
    
    NSArray *resources = [PHAssetResource assetResourcesForAsset:asset];
    NSString *name = ((PHAssetResource *)[resources objectAtIndex:0]).originalFilename;
    cell.titleLabel.text = name;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(50, 50) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        if (result) {
            [cell.imageView setImage:result];
        }
        
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = [assetArray objectAtIndex:indexPath.row];
    NSString *url = [[FileServer shareServer] getUrlFromAsset:asset];
    address(url);
    [self back:nil];
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
