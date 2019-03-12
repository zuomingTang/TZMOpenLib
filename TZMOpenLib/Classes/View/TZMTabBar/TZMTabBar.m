//
//  TZMTabBar.m

#import "TZMTabBar.h"

@interface TZMTabBar()
@end

@implementation TZMTabBar{
    NSMutableArray *_butArray;
    NSMutableArray *_superscriptArray;
    NSArray *_myItems;
}

//centreBut是tabbar中央自定义按钮,若传空则没有按钮
-(instancetype)init{
    self = [super init];
    if (self) {
        _butArray = [NSMutableArray array];
        _superscriptArray = [NSMutableArray array];
    }
    return self;
}

-(void)setCentreBut:(UIButton *)centreBut{
    _centreBut = centreBut;
    [self setItems:_myItems animated:NO];
}

- (void)setItems:(NSArray *)items animated:(BOOL)animated {
    _myItems = items;
    
    [_butArray enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        [btn removeFromSuperview];
    }];
    [self.centreBut removeFromSuperview];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat heightOvertop = height / 49 * 12;
    NSInteger count = _myItems.count;
    BOOL haveCentreBut = NO;
    
    if (self.centreBut && self.centreBut.bounds.size.width < width) {
        width = width - self.centreBut.bounds.size.width;
        haveCentreBut = YES;
    }
    
    for (int i = 0; i < count; i++) {
        UIButton *but = [[UIButton alloc]init];
        if (haveCentreBut) {
            if (i < count / 2) {
                but.frame = CGRectMake(i * (width / count + 1), -heightOvertop , width / count + 1, height + heightOvertop);
            }else{
                but.frame = CGRectMake(i * (width / count + 1) + self.centreBut.bounds.size.width, -heightOvertop , width / count + 1, height + heightOvertop);
            }
        }else{
            but.frame = CGRectMake(i * (width / count + 1), -heightOvertop , width / count + 1, height + heightOvertop);
        }
        but.tag = 100 + i;
        UITabBarItem *item = _myItems[i];
        [but setImage:item.image forState:UIControlStateNormal];
        [but setImage:item.selectedImage forState:UIControlStateSelected];
        [but setImage:item.selectedImage forState:(UIControlStateSelected | UIControlStateHighlighted)];
        [but addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchDown];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(35, 10, 14, 14)];
        label.backgroundColor = [UIColor redColor];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 7;
        label.font = [UIFont systemFontOfSize:10];
        
        NSString *str = @"";
        label.text = str;
        CGSize size = [str sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:10] forKey:NSFontAttributeName]];
        label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, (size.width + 6 > 14)?(size.width + 6):14, 14);
        
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.hidden = YES;
        [_superscriptArray addObject:label];
        [but addSubview:label];
        
        [self addSubview:but];
        
        [_butArray addObject:but];
    }
    if (count > 0) {
        self.centreBut.frame = CGRectMake((width / count + 1) * (count / 2), height - self.centreBut.frame.size.height, self.centreBut.frame.size.width, self.centreBut.frame.size.height);
    }
    [self addSubview:self.centreBut];
    self.selectedIndex = self.tabBarController.selectedIndex;
}

- (void)onButton:(UIButton*)but{
    NSInteger selectedIndex = but.tag - 100;
    self.tabBarController.selectedIndex = selectedIndex;
    [self setSelectedIndex:selectedIndex];
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    UIButton *buttonSele;
    for (int i = 0; i < _butArray.count; i++) {
        buttonSele = _butArray[i];
        if (i == selectedIndex) {
            buttonSele.selected = YES;
        }else{
            buttonSele.selected = NO;
        }
    }
}

@end
