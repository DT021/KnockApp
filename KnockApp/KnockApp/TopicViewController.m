//
//  TopicViewController.m
//  KnockApp
//
//  Created by Fangzhou Sun on 11/24/15.
//  Copyright © 2015 Fangzhou Sun. All rights reserved.
//

#import "TopicViewController.h"
#import "QRViewController.h"
#import "AFNetworking.h"
#import "StatusView.h"

enum ViewStatus {
    ViewStatus_original,
    ViewStatus_answerQuestion
};

@interface TopicViewController () {
    NSArray *questionArray;
    enum ViewStatus viewStatus;
    UILabel *uILabel_answerResponse;
    NSArray *configs;
    StatusView *statusView;
}

@end

@implementation TopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cSAV_view.alpha = 0;
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:@"reloadQuestionTable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:@"appWillEnterForeground" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    viewStatus = ViewStatus_original;
    [self updateViewsByStatus];
    
    [self getQuestions];
    
    [self startAnimation];
}

- (void)appWillEnterForeground {
    [self getQuestions];
    [self performSelector:@selector(startAnimation) withObject:nil afterDelay:0.4];
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

- (void)reloadTable:(NSNotification *)notification
{
    statusView = [[StatusView alloc] initWithText:@"You have a new question to answer." delayToHide:2.2 iconIndex:1];
    [self.view addSubview:statusView];
    
    [self getQuestions];
}

-(void)getQuestions {
    NSLog(@"getQuestions");
    
    NSURL *URL=[NSURL URLWithString: @"http://10.67.152.111:5000/questions/"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    [policy setValidatesDomainName:NO];
    [policy setAllowInvalidCertificates:YES];
    
    AFHTTPRequestOperation *downloadRequest = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    downloadRequest.securityPolicy.allowInvalidCertificates = YES;
    [downloadRequest setSecurityPolicy:policy];
    downloadRequest.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [downloadRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        questionArray = [(NSDictionary *)responseObject objectForKey:@"data"];
        [self.uITableView_questions reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"file downloading error : %@", [error localizedDescription]);
    }];
    
    // Step 5: begin asynchronous download
    [downloadRequest start];
}

- (void) doneBtnClicked {
    [self.view endEditing:YES];
//    [self keyboardWillBeHidden2:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (questionArray)
        return [questionArray count];
    else
        return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.uITableView_questions deselectRowAtIndexPath:indexPath animated:YES];
    
    [[self.uIView_newQuestion subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDictionary *questionDic = [questionArray objectAtIndex:indexPath.row];
    configs = [questionDic objectForKey:@"configs"];
    if ([configs count]>0) {
        //
        UIToolbar *boolbar = [UIToolbar new];
        boolbar.barStyle = UIBarStyleDefault;
        [boolbar sizeToFit];
        
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnClicked)];
        NSArray *array = [NSArray arrayWithObjects:leftBarButton, nil];
        [boolbar setItems:array];
        
        CGFloat alignment_horizontal = 8;
        CGFloat alignment_vertical_margin = 20;
        CGFloat alignment_vertical_padding = 7;
        CGFloat height_question = 0;
        CGFloat height_textarea = 30;
        CGFloat viewWidth = self.uIView_newQuestion.frame.size.width;
        UIColor *textColor = [UIColor darkGrayColor];
        UIColor *greenColor = [UIColor colorWithRed:28.0/255.0 green:134.0/255.0 blue:39.0/255.0 alpha:1];
        
        // Add title label
        NSString *title = [[configs objectAtIndex:0] objectForKey:@"say_text"];
        if (title) {
            CGRect nameValueRectangle = CGRectMake(alignment_horizontal, alignment_vertical_margin, viewWidth-2*alignment_horizontal, 15);
            UILabel *lbl_title = [[UILabel alloc]initWithFrame:nameValueRectangle];
            lbl_title.textColor = textColor;
            lbl_title.text = title;
            lbl_title.font = [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:17];
            lbl_title.numberOfLines=0;
            [lbl_title sizeToFit];
            lbl_title.frame = CGRectMake(lbl_title.frame.origin.x, lbl_title.frame.origin.y, viewWidth-2*alignment_horizontal, lbl_title.frame.size.height);
            height_question += lbl_title.frame.size.height+ alignment_vertical_margin;
            [self.uIView_newQuestion addSubview:lbl_title];
        }
        
        NSInteger data_type = [[[configs objectAtIndex:0] objectForKey:@"data_type"] integerValue];
        if (data_type==1 || data_type==4 || data_type==7) {
            CGRect textareaRectangle = CGRectMake(alignment_horizontal, height_question+alignment_vertical_padding, viewWidth-2*alignment_horizontal, height_textarea);
            UITextField *textField = [[UITextField alloc] initWithFrame:textareaRectangle];
            textField.borderStyle = UITextBorderStyleNone;
            textField.layer.borderColor = greenColor.CGColor;
            textField.layer.borderWidth = 1.0f;
            [textField setKeyboardType:UIKeyboardTypePhonePad];
            textField.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
//            textField.tag = [[answer objectForKey:@"id"] integerValue];
            
//            [textFieldArray addObject:textField];
            
            // check
//            if ([[answer objectForKey:@"properties"] objectForKey:@"input" ]) {
//                if ([[[answer objectForKey:@"properties"] objectForKey:@"input" ] isEqualToString:@"Numerical"]) {
//                    textField.keyboardType = UIKeyboardTypeNumberPad;
//                } else if ([[[answer objectForKey:@"properties"] objectForKey:@"input" ] isEqualToString:@"Time"]) {
//                    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
//                    datePicker.datePickerMode = UIDatePickerModeTime;
//                    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
//                    datePicker.tag = [textFieldArray indexOfObject:textField];
//                    textField.inputView = datePicker;
//                    
//                    //Set default time
//                    //                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//                    //                    [df setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
//                    //                    textField.text =[NSString stringWithFormat:@"%@",[df stringFromDate:[[NSDate alloc] init]]];
//                }
//            }
            
//            if ([self.temporarySavedAnswerMap objectForKey:[answer objectForKey:@"answerVersionId"]])
//                textField.text = [self.temporarySavedAnswerMap objectForKey:[answer objectForKey:@"answerVersionId"]];
            
            textField.delegate = self;
            // just for test
            
            //            textField.text = [NSString stringWithFormat:@"%ld", (long)textField.tag ];
            
            [textField addTarget:self action:@selector(controlValueModified:) forControlEvents:UIControlEventEditingChanged];
            
            // Clear button
            textField.clearButtonMode = UITextFieldViewModeAlways;
            
            height_question += alignment_vertical_padding+height_textarea;
            
            textField.inputAccessoryView = boolbar;
            [self.uIView_newQuestion addSubview:textField];
        }
        
        //
        CGRect nameValueRectangle = CGRectMake(alignment_horizontal, height_question+alignment_vertical_padding, viewWidth-2*alignment_horizontal, 40);
        uILabel_answerResponse = [[UILabel alloc]initWithFrame:nameValueRectangle];
        uILabel_answerResponse.textColor = greenColor;
        uILabel_answerResponse.text = @"";
        uILabel_answerResponse.font = [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:17];
        uILabel_answerResponse.numberOfLines=0;
        height_question += uILabel_answerResponse.frame.size.height+ alignment_vertical_margin;
        [self.uIView_newQuestion addSubview:uILabel_answerResponse];
    }

    
    viewStatus = ViewStatus_answerQuestion;
    [self updateViewsByStatus];
}

- (void)controlValueModified:(id)sender {
    if ([sender isKindOfClass:[UITextField class]]) {
        
        UITextField *textField = (UITextField *)sender;
        if ([textField.text isEqualToString:@""]) {
            uILabel_answerResponse.text = @"";
            return;
        }
//        NSLog(@"%@",textField.text);
//        uILabel_answerResponse.text = textField.text;
        NSString *op_kind = [[configs objectAtIndex:0] objectForKey:@"op_kind"];
        if (op_kind && [op_kind isEqualToString:@"ifop"]) {
            NSString *ifop_condition = [[configs objectAtIndex:0] objectForKey:@"ifop_condition"];
            NSArray *array = [ifop_condition componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
            
            NSInteger value = [[array objectAtIndex:1] integerValue];
            NSString *ifop_false_block = [[configs objectAtIndex:0] objectForKey:@"ifop_false_block"];
//            NSString *ifop_true_block = [[configs objectAtIndex:0] objectForKey:@"ifop_true_block"];
            
            NSString *trueText=@"";
            NSString *falseText=@"";
            
            if ([[[configs objectAtIndex:1] objectForKey:@"key"] isEqualToString:ifop_false_block]) {
                trueText=[[configs objectAtIndex:2] objectForKey:@"say_text"];
                falseText=[[configs objectAtIndex:1] objectForKey:@"say_text"];
            } else {
                trueText=[[configs objectAtIndex:1] objectForKey:@"say_text"];
                falseText=[[configs objectAtIndex:2] objectForKey:@"say_text"];
            }
            
            if ([[array objectAtIndex:0] isEqualToString:@"<"]) {
                if ([textField.text integerValue]<value)
                    uILabel_answerResponse.text = trueText;
                else
                    uILabel_answerResponse.text = falseText;
            } else if ([[array objectAtIndex:0] isEqualToString:@">"]) {
                if ([textField.text integerValue]>value)
                    uILabel_answerResponse.text = trueText;
                else
                    uILabel_answerResponse.text = falseText;
            } else if ([[array objectAtIndex:0] isEqualToString:@"=="]) {
                if ([textField.text integerValue]==value)
                    uILabel_answerResponse.text = trueText;
                else
                    uILabel_answerResponse.text = falseText;
            }
        }
    }
}

- (void)updateViewsByStatus {
    if (viewStatus==ViewStatus_original) {
        self.cSAV_newQuestion.hidden = YES;
        self.cSAV_newQuestion.type = CSAnimationTypeFadeOut;
        self.cSAV_newQuestion.duration = 0.3;
        self.cSAV_newQuestion.delay = 0.0;
        [self.cSAV_newQuestion startCanvasAnimation];
        self.cSAV_newQuestion.alpha = 0;
    } else if (viewStatus==ViewStatus_answerQuestion) {
        self.cSAV_newQuestion.hidden = NO;
        self.cSAV_newQuestion.type = CSAnimationTypePop;
        self.cSAV_newQuestion.duration = 0.3;
        self.cSAV_newQuestion.delay = 0.0;
        [self.cSAV_newQuestion startCanvasAnimation];
        self.cSAV_newQuestion.alpha = 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell" forIndexPath:indexPath];
    
    NSDictionary *questionDic = [questionArray objectAtIndex:indexPath.row];
    NSArray *configs = [questionDic objectForKey:@"configs"];
    cell.textLabel.text = @"Question";
    if ([configs count]>0) {
        NSString *sayText = [[configs objectAtIndex:0] objectForKey:@"say_text"];
        if (sayText)
            cell.textLabel.text = sayText;
    }
    
    cell.detailTextLabel.text = @"Due Today";
    
    return cell;
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)didTapCancelNewQuestion:(id)sender {
    viewStatus = ViewStatus_original;
    [self updateViewsByStatus];
}

- (IBAction)didTapSubmitNewQuestion:(id)sender {
}
@end
