//
//  TopicViewController.h
//  KnockApp
//
//  Created by Fangzhou Sun on 11/24/15.
//  Copyright © 2015 Fangzhou Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Canvas.h"

@interface TopicViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *uITableView_questions;

- (IBAction)didTapAddingNewQuestions:(id)sender;
- (IBAction)didTapLogout:(id)sender;
@property (weak, nonatomic) IBOutlet CSAnimationView *cSAV_view;
@end
