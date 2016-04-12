//
//  ViewController.m
//  MBNavigationBar
//
//  Created by user on 16/4/11.
//  Copyright © 2016年 mobin. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+MBNavigationBar.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.observerScrollView = self.tableView;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 250)];
    imageView.image = [UIImage imageNamed:@"lol.jpg"];
    self.tableView.tableHeaderView = imageView;
    self.rightBarAlpha = YES;
    self.titleBarAlpha = YES;
    self.scrollOffsetY = 200;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setUpNavBar];

}
- (void)setUpNavBar{
    
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];

    UILabel * titleLabel =[[UILabel alloc]init];
    titleLabel.text = @"Hello";
    [titleLabel sizeToFit];
    titleLabel.textColor = [UIColor redColor];
    self.navigationItem.titleView = titleLabel;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self setInViewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear: animated];
    [self setInViewWillDisappear];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self scrollViewDidScrollToControl];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString * Identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        cell.textLabel.text = [NSString stringWithFormat:@"第%d行",indexPath.row];
    }
    return cell;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
