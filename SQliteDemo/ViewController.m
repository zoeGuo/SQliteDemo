//
//  ViewController.m
//  SQliteDemo
//
//  Created by deveplopper on 15/7/27.
//  Copyright (c) 2015年 deveplopper. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "PersonTool.h"

@interface ViewController ()

@end

@implementation ViewController


 #pragma mark-懒加载
-(NSArray *)persons
 {
         if (_persons==nil) {
                 _persons=[PersonTool query];
             }
         return _persons;
     }

 //1.在初始化方法中添加一个搜索框
- (void)viewDidLoad
 {
         [super viewDidLoad];
    
         //设置搜索框
         UISearchBar *search=[[UISearchBar alloc]init];
         search.frame=CGRectMake(0, 0, 300, 44);
         search.delegate=self;
         self.navigationItem.titleView=search;
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"添加"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(add:)];
     _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height ) style:UITableViewStylePlain];
     _tableView.delegate = self;
     _tableView.dataSource = self;
     [self.view addSubview:_tableView];
     
     }

 //2.设置tableView的数据
 //设置有多少行数据
 -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
     //    return 10;
         return self.persons.count;
     }
 -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
        //1.去缓存中取cll,若没有则自己创建并标记
         static NSString *ID=@"ID";
         UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
         if (cell==nil) {
                 cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
             }
    
         //2.设置每个cell的数据
         //先取出数据模型
         Person *person=self.persons[indexPath.row];
         //设置这个cell的姓名（name）和年龄
         cell.textLabel.text=person.name;
         cell.detailTextLabel.text=[NSString stringWithFormat:@"年龄  %d",person.age];
         //3.返回cell
         return cell;
     }

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)add: (id)sender{
        // 初始化一些假数据
        NSArray *names = @[@"西门抽血", @"西门抽筋", @"西门抽风", @"西门吹雪", @"东门抽血", @"东门抽筋", @"东门抽风", @"东门吹雪", @"北门抽血", @"北门抽筋", @"南门抽风", @"南门吹雪"];
         for (int i = 0; i<20; i++) {
                 Person *p = [[Person alloc] init];
             p.name = [NSString stringWithFormat:@"%@-%d", names[arc4random_uniform(names.count)], arc4random_uniform(100)];
            p.age = arc4random_uniform(20) + 20;
                [PersonTool save:p];
             }
     }

 #pragma mark-搜索框的代理方法
 -(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
 {
         self.persons=[PersonTool queryWithCondition:searchText];
         //刷新表格
         [self.tableView reloadData];
         [searchBar resignFirstResponder];
     }


@end
