//
//  RCTInputView.m
//  imuiDemo
//
//  Created by oshumini on 2017/5/27.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "RCTInputView.h"
#import "RCTAuroraIMUIModule.h"


@implementation RCTInputView

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    return self;
}

- (void)setFrame:(CGRect)frame {
    // override setFrame and do not thing to disable this function, react-native use setBounds to layout.
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.keyBoardHeight = 0.0;

    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(hidenFeatureView)
                                                     name:kHidenFeatureView object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(layoutInputView)
                                                     name:kLayoutInputView object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        
        [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"bounds"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //      [self.imuiIntputView.featureView.featureCollectionView layoutSubviews];
            //      [self.imuiIntputView.featureView.featureCollectionView reloadData];
        });
    }
}

//输入框文本高度
- (CGFloat)inputTextHeight {
    
    if (self.imuiIntputView == nil) {
        return 52;
    }

    if(self.imuiIntputView.inputTextView.text == nil || [self.imuiIntputView.inputTextView.text isEqualToString:@""]) {

        return 52;
    }

    CGSize size = CGSizeMake(self.imuiIntputView.inputTextView.frame.size.width, CGFLOAT_MAX);

    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagraphStyle.lineBreakMode = NSLineBreakByCharWrapping;


    NSMutableDictionary *mutableDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:mutableParagraphStyle}.mutableCopy;

    CGFloat height = [self.imuiIntputView.inputTextView.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:mutableDictionary context:nil].size.height;


    if(height <= 32) {
        return 52;
    }

    if(height >= 4*[UIFont systemFontOfSize:14].lineHeight+mutableParagraphStyle.lineSpacing*3){
        return 4*[UIFont systemFontOfSize:14].lineHeight+mutableParagraphStyle.lineSpacing*3 + 20 + self.imuiIntputView.inputTextView.textContainerInset.bottom;
    }

    return 20 + height+self.imuiIntputView.inputTextView.textContainerInset.bottom;
}

//隐藏功能的通知 比如触摸
- (void)hidenFeatureView {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.keyBoardHeight = 0.0;
        //隐藏功能
        
        if(self.onSizeChange) {
            self.onSizeChange(@{@"height":@(self.inputTextHeight),
                                @"width":@(self.frame.size.width)});
        }
        
        [self.imuiIntputView hideFeatureView];
    });
}

- (void)layoutInputView {

}

- (void)keyboardDidHide:(NSNotification *) notif{
    
    if(self.onSizeChange) {
        
        self.keyBoardHeight = 0.0;
        
        BOOL isOpenEmoji = [self.imuiIntputView isOpenEmoji]; //不显示表情的情况下
        BOOL isOpenOther = [self.imuiIntputView isOpenOther]; //不显示其他功能的情况下
        
        if(isOpenEmoji == false && isOpenOther == false){
            //隐藏键盘

            self.onSizeChange(@{@"height":@(self.inputTextHeight),
                                @"width":@(self.frame.size.width)});
        }
        
    }
}

- (void)keyboardDidShow:(NSNotification *) notif{
    
    NSDictionary *dic = notif.userInfo;
    NSValue *keyboardValue = dic[UIKeyboardFrameEndUserInfoKey];
    CGFloat bottomDistance = [UIScreen mainScreen].bounds.size.height - keyboardValue.CGRectValue.origin.y;
    
    
    [self.imuiIntputView hideFeatureView];
    
  
    if(CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812))){
        self.keyBoardHeight = bottomDistance-34;
        
    } else {
        self.keyBoardHeight  = bottomDistance;
    }

    if(self.onSizeChange) {
        self.onSizeChange(@{@"height":@(self.inputTextHeight+self.keyBoardHeight),
                            @"width":@(self.frame.size.width)});

    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"bounds"];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}


@end
