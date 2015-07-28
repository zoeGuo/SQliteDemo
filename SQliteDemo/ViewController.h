//
//  ViewController.h
//  SQliteDemo
//
//  Created by deveplopper on 15/7/27.
//  Copyright (c) 2015年 deveplopper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *persons;

@property (nonatomic, strong) UITableView *tableView;

@end

