//
//  ViewController.m
//  CatchGhost
//
//  Created by yiner on 2017/10/10.
//  Copyright © 2017年 yiner. All rights reserved.
//

#import "ViewController.h"
#import "EndViewController.h"
#import <Masonry/Masonry.h>
#import "demoHitEventView.h"

/**
 获取屏幕宽度
 */
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
/**
 获取屏幕高度
 */
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

typedef enum: NSUInteger {
    mGameType,  //手动模式
    autoGameType    //自动模式
}GameType;

typedef enum: NSUInteger {
    SillyBmore,  //傻瓜多
    GhostMore    //鬼多
}WhichMoreType; //选取鬼多还是傻瓜多的模式  默认傻瓜多
@interface ViewController ()
@property (nonatomic, strong) UIImageView *bgview;

@property (nonatomic, strong) UIButton *peopleButton;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *randomButton;
@property (nonatomic, strong) UIButton *exchangeButton;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UILabel *peopleNumLab;
@property (nonatomic, strong) UILabel *pingminLab;
@property (nonatomic, strong) UILabel *shaziLab;

@property (nonatomic, strong) UITextField *pingminTxt;
@property (nonatomic, strong) UITextField *shaziTxt;

@property (nonatomic, strong) UISwitch * switchMore;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, copy) NSString *peopleNum;
@property (nonatomic, copy) NSString *pingmin;
@property (nonatomic, copy) NSString *shazi;
@property (nonatomic, assign) NSArray *allWord;

@property (nonatomic, copy) NSString *autoPingMin;
@property (nonatomic, copy) NSString *autoShazi;
@property (nonatomic, copy) NSString *autoPeople;
@property (nonatomic, copy) NSArray * wordPlistArray;
@property (nonatomic, assign)GameType  gameType;
@property (nonatomic, assign)WhichMoreType  whichMoreType;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gameType = mGameType;
    self.whichMoreType = GhostMore;
    //self.title = @"捉👻";
    if (self.whichMoreType == SillyBmore) {
        self.navigationItem.title = @"捉👻（多傻瓜模式）";
    } else {
        self.navigationItem.title = @"捉👻（多鬼模式）";
    }
//    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.bgview];
    [self.view addSubview:self.peopleButton];
    [self.view addSubview:self.randomButton];
    [self.view addSubview:self.peopleNumLab];
    [self.view addSubview:self.pingminLab];
    [self.view addSubview:self.shaziLab];
    [self.view addSubview:self.pingminTxt];
    [self.view addSubview:self.shaziTxt];
    [self.view addSubview:self.exchangeButton];
    [self.view addSubview:self.pickerView];
    [self.view addSubview:self.submitButton];
    [self.view addSubview:self.switchMore];
    self.peopleNum = @"";
    [self navigation];
    [self configureUI];
    [self addActivityView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self autoFromPlist];
    NSArray * defaultsArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"allWordArr"];
    self.allWord = defaultsArray;
    if (self.allWord && self.allWord.count > 0) {
        self.randomButton.hidden = NO;
        [_randomButton setTitle:[NSString stringWithFormat:@"🎲🎲\n  随机选词   \n%ld个",(long)self.allWord.count] forState:UIControlStateNormal];
    }
    else {
        self.randomButton.hidden = YES;
    }
    if (self.gameType == autoGameType) {
        [self randomButton:nil];
    }
}

-(void)navigation{
//    UIButton *button = [[UIButton alloc] init];
//    button.frame = CGRectMake(0, 0, 60, 40);
//    button.titleLabel.font = [UIFont systemFontOfSize:15];
//    [button setTitle:@"   自动上帝" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blackColor] forState:0];
//    [button addTarget:self action:@selector(autoGod) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = item;
//    
//    UIButton *button2 = [[UIButton alloc] init];
//    button2.frame = CGRectMake(0, 0, 60, 40);
//    button2.titleLabel.font = [UIFont systemFontOfSize:15];
//    [button2 setTitle:@"手动上帝   " forState:UIControlStateNormal];
//    [button2 setTitleColor:[UIColor blackColor] forState:0];
//    [button2 addTarget:self action:@selector(manualGod) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
//    self.navigationItem.leftBarButtonItem = item2;
}

- (void)configureUI{
    
    [self.pingminLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.centerY.equalTo(self.view).offset(-50);
    }];
    
    [self.peopleNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pingminLab.mas_top).offset(-30);
        make.centerX.equalTo(self.pingminLab);
    }];
    
    [self.shaziLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.pingminLab);
        make.top.equalTo(self.pingminLab.mas_bottom).offset(30);
    }];
    
    [self.pingminTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pingminLab.mas_right).offset(20);
        make.centerY.equalTo(self.pingminLab);
        make.width.mas_equalTo(150);
    }];
    
    [self.shaziTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shaziLab.mas_right).offset(20);
        make.centerY.equalTo(self.shaziLab);
        make.width.mas_equalTo(150);
    }];
    
    [self.exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pingminTxt.mas_right).offset(10);
        make.top.equalTo(self.pingminTxt);
        make.bottom.equalTo(self.shaziTxt);
        make.width.mas_equalTo(25);
    }];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.peopleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.peopleNumLab.mas_right).offset(20);
        make.centerY.equalTo(self.peopleNumLab);
        make.width.mas_equalTo(88);
    }];
    
    [self.randomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.peopleNumLab.mas_top).offset(-20);
        make.centerX.equalTo(self.view);
    }];

    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shaziLab.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.mas_equalTo(50);
    }];
    
    [self.bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.switchMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.exchangeButton.mas_right).offset(0);
        make.centerY.equalTo(self.peopleButton.mas_centerY).offset(0);
    }];
}

-(void)addActivityView{
    demoHitEventView * demoHit = [[demoHitEventView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:demoHit];
    [demoHit show];
}

/**
 手动上帝
 */
-(void)manualGod{
    self.gameType = mGameType;
    
    self.pingminLab.hidden = NO;
    self.shaziLab.hidden = NO;
    self.pingminTxt.hidden = NO;
    self.shaziTxt.hidden = NO;
    self.exchangeButton.hidden = NO;
    
    if (self.allWord && self.allWord.count > 0) {
        self.randomButton.hidden = NO;
        [_randomButton setTitle:[NSString stringWithFormat:@"🎲🎲\n  随机选词   \n%ld个",(long)self.allWord.count] forState:UIControlStateNormal];
    }
    else {
        self.randomButton.hidden = YES;
    }
}

/**
 自动上帝
 */
-(void)autoGod{
    self.gameType = autoGameType;
    
    self.pingminLab.hidden = YES;
    self.shaziLab.hidden = YES;
    self.pingminTxt.hidden = YES;
    self.shaziTxt.hidden = YES;
    self.exchangeButton.hidden = YES;

    self.randomButton.hidden = NO;
    [_randomButton setTitle:[NSString stringWithFormat:@"🎲🎲\n  随机选词   \n%ld个",(long)_wordPlistArray.count] forState:UIControlStateNormal];
    [self randomButton:nil];
}
#pragma mark - UIPickerViewDelegate -
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.titleArray.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.peopleNum = self.titleArray[row];
    [self.peopleButton setTitle:self.peopleNum forState:UIControlStateNormal];
    self.pickerView.hidden = YES;
}

#pragma mark - UIPickerViewDataSource -
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.titleArray[row];
}

#pragma mark - action -
- (void)selectNum:(id)sender
{
    self.pickerView.hidden = NO;
}

- (void)starGame:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你怕不是个傻的吧" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"兑兑！奖得兑！" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    if ([self.pingminTxt.text isEqualToString:@""]) {
        alert.message = @"农民词也需要填啊💢劳动人民最光荣✨";
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    else if ([self.shaziTxt.text isEqualToString:@""]) {
        alert.message = @"不要歧视傻瓜好吧🔪砍你不犯法🙂";
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    else if ([self.peopleNum isEqualToString:@""]) {
        alert.message = @"不告诉我你们一共几个人怎么玩❓❓";
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    else {
        /// 存词
        NSArray *array = @[self.pingminTxt.text,self.shaziTxt.text];
        [self saveWordWithNewWord:array];
        
        EndViewController *endVC = [[EndViewController alloc] init];
        endVC.sortedArray = [self configureArrayWithAllInfo];
        endVC.farmer = self.pingminTxt.text;
        endVC.stupid = self.shaziTxt.text;
        [self.navigationController pushViewController:endVC animated:YES];
    }
}

- (NSMutableArray *)configureArrayWithAllInfo
{
    NSMutableArray *niubilityArray = [NSMutableArray array];
    NSInteger peopleAllNum = [self.peopleNum integerValue];
    NSInteger nongMinNum = peopleAllNum/2+peopleAllNum%2;
    NSInteger sillyBNum = 0;
    NSInteger ghostNum = 0;
    
    if (self.whichMoreType == GhostMore) {
        //鬼多
        ghostNum = (peopleAllNum - nongMinNum)/2+(peopleAllNum - nongMinNum)%2;
        sillyBNum = peopleAllNum - nongMinNum - ghostNum;
    } else {
        //傻瓜多
        sillyBNum = (peopleAllNum - nongMinNum)/2+(peopleAllNum - nongMinNum)%2;
        ghostNum = peopleAllNum - nongMinNum - sillyBNum;
    }
    
    for (int i=0; i<nongMinNum; i++) {
        [niubilityArray addObject:self.pingminTxt.text];
    }
    for (int j=0; j<sillyBNum; j++) {
        [niubilityArray addObject:self.shaziTxt.text];
    }
    for (int k=0; k<ghostNum; k++) {
        [niubilityArray addObject:@"👻"];
    }
    return niubilityArray;
}

- (NSMutableArray *)autoConfigureArrayWithAllInfoWithPeopleNum:(NSInteger)num
{
    NSMutableArray *niubilityArray = [NSMutableArray array];
    NSInteger peopleAllNum = num;
    NSInteger nongMinNum = peopleAllNum/2+peopleAllNum%2;
    NSInteger sillyBNum = (peopleAllNum - nongMinNum)/2+(peopleAllNum - nongMinNum)%2;
    NSInteger ghostNum = peopleAllNum - nongMinNum - sillyBNum;
    
    for (int i=0; i<nongMinNum; i++) {
        [niubilityArray addObject:self.pingminTxt.text];
    }
    for (int j=0; j<sillyBNum; j++) {
        [niubilityArray addObject:self.shaziTxt.text];
    }
    for (int k=0; k<ghostNum; k++) {
        [niubilityArray addObject:@"👻"];
    }
    return niubilityArray;
}

- (void)randomButton:(id)sender {
    NSArray * selectWordArray;
    if (self.gameType == mGameType) {
        selectWordArray = self.allWord;
    } else {
        selectWordArray = _wordPlistArray;
    }
    if (selectWordArray.count == 1) {
        NSArray *randomWord = [selectWordArray objectAtIndex:0];
        int index = roundl(arc4random()%(2));
        self.pingminTxt.text = [randomWord objectAtIndex:index];
        int index2 = 0;
        if (index == 0) {
            index2 = 1;
        }
        self.shaziTxt.text = [randomWord objectAtIndex:index2];
    }
    else if (selectWordArray.count > 1) {
        int j = roundl(arc4random()%(selectWordArray.count));
        NSArray *randomWord = [selectWordArray objectAtIndex:j];
        int index = roundl(arc4random()%(2));
        self.pingminTxt.text = [randomWord objectAtIndex:index];
        int index2 = 0;
        if (index == 0) {
            index2 = 1;
        }
        self.shaziTxt.text = [randomWord objectAtIndex:index2];
        NSLog(@"%d---%d",index,index2);
    }
}

- (void)exchangeButton:(id)sender {
    NSString *farmer = self.pingminTxt.text;
    self.pingminTxt.text = self.shaziTxt.text;
    self.shaziTxt.text = farmer;
}

- (void)saveWordWithNewWord:(NSArray *)newWord
{
    NSArray *allWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"allWordArr"];
    NSMutableArray *allWordArr = [NSMutableArray arrayWithArray:allWord];
    
    // 确保不是已经添加过的，或者 添加过的颠倒过来
    for (NSArray *subArr in allWordArr) {
        if (([[subArr objectAtIndex:0] isEqualToString:[newWord objectAtIndex:0]] && [[subArr objectAtIndex:1] isEqualToString:[newWord objectAtIndex:1]]) || ([[subArr objectAtIndex:0] isEqualToString:[newWord objectAtIndex:1]] && [[subArr objectAtIndex:1] isEqualToString:[newWord objectAtIndex:0]])) {
            return;
        }
    }
    
    if (allWordArr && allWordArr.count > 0) {
        [allWordArr addObject:newWord];
    }
    else {
        allWordArr = @[newWord].mutableCopy;
    }
    [[NSUserDefaults standardUserDefaults] setObject:allWordArr forKey:@"allWordArr"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 获取plist文件中的词组
 */
-(void)autoFromPlist{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"word" ofType:@"plist"];
    //读取
    NSArray *plistArr = [NSArray arrayWithContentsOfFile:plistPath];
    _wordPlistArray = plistArr;
}

/**
 选取鬼多还是傻瓜多的开关
 */
-(void)switchAction{
    if ([self.switchMore isOn] == NO) {
        //鬼多
        self.whichMoreType = GhostMore;
        self.navigationItem.title = @"捉👻（多鬼模式）";
    } else {
        //傻瓜多
        self.whichMoreType = SillyBmore;
        self.navigationItem.title = @"捉👻（多傻瓜模式）";
    }
}
#pragma mark - system -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    self.pickerView.hidden = YES;
}

#pragma mark - set & get -
- (UIButton *)peopleButton
{
    if (!_peopleButton) {
        _peopleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _peopleButton.layer.masksToBounds = YES;
        _peopleButton.layer.cornerRadius = 3;
        _peopleButton.layer.borderColor = [UIColor grayColor].CGColor;
        _peopleButton.layer.borderWidth = 1;
        [_peopleButton setBackgroundColor:[UIColor grayColor]];
        [_peopleButton setTitleColor:[UIColor blackColor] forState:0];
        [_peopleButton setTitle:@"选择" forState:UIControlStateNormal];
        [_peopleButton addTarget:self action:@selector(selectNum:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _peopleButton;
}

- (UILabel *)peopleNumLab
{
    if (!_peopleNumLab) {
        _peopleNumLab  = [UILabel new];
        _peopleNumLab.text = @"人数🌲:";
        _peopleNumLab.textColor = [UIColor blackColor];
        _peopleNumLab.font = [UIFont systemFontOfSize:18];
    }
    return _peopleNumLab;
}

- (UILabel *)shaziLab
{
    if (!_shaziLab) {
        _shaziLab = [UILabel new];
        _shaziLab.text = @"傻瓜🍉:";
        _shaziLab.textColor = [UIColor blackColor];
        _shaziLab.font = [UIFont systemFontOfSize:18];
        
    }
    return _shaziLab;
}

- (UILabel *)pingminLab
{
    if (!_pingminLab) {
        _pingminLab = [UILabel new];
        _pingminLab.text = @"农民👨‍🌾:";
        _pingminLab.textColor = [UIColor blackColor];
        _pingminLab.font = [UIFont systemFontOfSize:18];
        
    }
    return _pingminLab;
}

- (UITextField *)pingminTxt
{
    if (!_pingminTxt) {
        _pingminTxt = [UITextField new];
        _pingminTxt.backgroundColor = [UIColor grayColor];
        _pingminTxt.keyboardType = UIKeyboardTypeDefault;
        _pingminTxt.textColor = [UIColor whiteColor];
    }
    return _pingminTxt;
}

- (UITextField *)shaziTxt
{
    if (!_shaziTxt) {
        _shaziTxt = [UITextField new];
        _shaziTxt.backgroundColor = [UIColor grayColor];
        _shaziTxt.keyboardType = UIKeyboardTypeDefault;
        _shaziTxt.textColor = [UIColor whiteColor];
    }
    return _shaziTxt;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.hidden = YES;
    }
    return _pickerView;
}

- (UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.layer.masksToBounds = YES;
        _submitButton.layer.cornerRadius = 4;
        [_submitButton setBackgroundColor:[UIColor redColor]];
        [_submitButton setTitle:@"开始👏👏👏" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(starGame:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (UIButton *)randomButton {
    if (!_randomButton) {
        _randomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _randomButton.backgroundColor = [UIColor greenColor];
        _randomButton.hidden = YES;
        [_randomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _randomButton.layer.masksToBounds = YES;
        _randomButton.layer.cornerRadius = 10;
        _randomButton.titleLabel.numberOfLines = 0;
        _randomButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_randomButton addTarget:self action:@selector(randomButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _randomButton;
}

- (UIButton *)exchangeButton {
    if (!_exchangeButton) {
        _exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _exchangeButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _exchangeButton.backgroundColor = [UIColor brownColor];
        [_exchangeButton setTitle:@"交换" forState:UIControlStateNormal];
        [_exchangeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_exchangeButton addTarget:self action:@selector(exchangeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exchangeButton;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15"];
    }
    return _titleArray;
}

- (UIImageView *)bgview
{
    if (!_bgview) {
        _bgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"corekit_rootViewBg"]];
    }
    return _bgview;
}

-(UISwitch *)switchMore{
    if (!_switchMore) {
        _switchMore = [[UISwitch alloc] init];
        _switchMore.on = NO;
        [_switchMore addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
    }
    return _switchMore;
}
@end
