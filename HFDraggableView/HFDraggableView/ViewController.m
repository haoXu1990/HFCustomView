//
//  ViewController.m
//  HFDraggableView
//
//  Created by Henry on 08/11/2017.
//  Copyright © 2017 Henry. All rights reserved.
//

#import "ViewController.h"
#import "HFDraggableView.h"
#import "HFAngleIndicator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    HFDraggableView *view1 = [[HFDraggableView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view1.backgroundColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x33/255.0 alpha:1.0];
    [self.view addSubview:view1];
    
    HFDraggableView *view2 = [[HFDraggableView alloc] initWithFrame:CGRectMake(100, 200, 200, 100)];
    view2.angle = M_PI / 6;
    view2.backgroundColor = [UIColor colorWithRed:0 green:0xcc/255.0 blue:0xcc/255.0 alpha:1.0];
    [self.view addSubview:view2];
    
//    
//    HFAngleIndicator *view3 = [[HFAngleIndicator alloc] init];
//    view3.center = CGPointMake(200, 400);
//    view3.angle = 33.0;
//    [self.view addSubview:view3];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
