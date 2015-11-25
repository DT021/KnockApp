//
//  TopicViewController.m
//  KnockApp
//
//  Created by Fangzhou Sun on 11/24/15.
//  Copyright © 2015 Fangzhou Sun. All rights reserved.
//

#import "TopicViewController.h"
#import "QRViewController.h"

@interface TopicViewController ()

@end

@implementation TopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cSAV_view.alpha = 0;
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startAnimation];
}

- (void)startAnimation {
    self.cSAV_view.type = CSAnimationTypeBounceLeft;
    self.cSAV_view.duration = 0.3;
    self.cSAV_view.delay = 0.0;
    [self.cSAV_view startCanvasAnimation];
    self.cSAV_view.alpha = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapAddingNewQuestions:(id)sender {
    QRViewController *qRViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QRViewController"];
    [self presentViewController:qRViewController animated:YES completion:nil];
}

- (IBAction)didTapLogout:(id)sender {
}
@end
