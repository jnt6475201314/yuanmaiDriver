//
//  PlaceholderTextView.m
//  SaleHelper
//
//  Created by gitBurning on 14/12/8.
//  Copyright (c) 2014年 Burning_git. All rights reserved.
//

#import "PlaceholderTextView.h"

@interface PlaceholderTextView()<UITextViewDelegate>
{
    UILabel *PlaceholderLabel;
}

@end
@implementation PlaceholderTextView

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self awakeFromNib];
    }
    return self;
}


- (void)awakeFromNib {
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidChange:) name:UITextViewTextDidChangeNotification object:self];

    float left=5,top=4,hegiht=35;
    
    self.placeholderColor = [UIColor lightGrayColor];
    self.delegate = self;
    PlaceholderLabel=[[UILabel alloc] initWithFrame:CGRectMake(left, top
                                                               , CGRectGetWidth(self.frame)-2*left, hegiht)];
    PlaceholderLabel.numberOfLines = 0;
    PlaceholderLabel.font=self.placeholderFont?self.placeholderFont:self.font;
    PlaceholderLabel.textColor=self.placeholderColor;
    [self addSubview:PlaceholderLabel];
    PlaceholderLabel.text=self.placeholder;

}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)setPlaceholder:(NSString *)placeholder{
    if (placeholder.length == 0 || [placeholder isEqualToString:@""]) {
        PlaceholderLabel.hidden=YES;
    }
    else
        PlaceholderLabel.text=placeholder;
    _placeholder=placeholder;
//    CGRect rect = [placeholder boundingRectWithSize:CGSizeMake(PlaceholderLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.placeholderFont?self.placeholderFont:self.font} context:nil];
//    PlaceholderLabel.frame = CGRectMake(CGRectGetMinX(PlaceholderLabel.frame), CGRectGetMinY(PlaceholderLabel.frame), CGRectGetWidth(PlaceholderLabel.frame), rect.size.height);
}

- (void)setText:(NSString *)text {
    [super setText:text];
    if (![text isEqualToString:@""]) {
        PlaceholderLabel.text = @"";
    }
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    if (_placeholderFont != placeholderFont) {
        _placeholderFont = placeholderFont;
    }
    PlaceholderLabel.font = _placeholderFont;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    PlaceholderLabel.hidden=YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.text.length > 0) {
        PlaceholderLabel.hidden=YES;
    }else {
        PlaceholderLabel.hidden=NO;
    }
}

-(void)DidChange:(NSNotification*)noti{
    
    if (self.placeholder.length == 0 || [self.placeholder isEqualToString:@""]) {
        PlaceholderLabel.hidden=YES;
    }
    
    if (self.text.length > 0) {
        PlaceholderLabel.hidden=YES;
    }
    else{
        PlaceholderLabel.hidden=NO;
    }
    
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [PlaceholderLabel removeFromSuperview];
}

@end
