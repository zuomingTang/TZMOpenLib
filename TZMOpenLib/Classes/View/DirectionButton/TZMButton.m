//
// Created by mayer on 16/1/3.
// Copyright (c) 2016 mayer. All rights reserved.
//

#import "TZMButton.h"

@implementation TZMButton

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)prepareForInterfaceBuilder {
    
}

- (NSUInteger)imageDirection {
    return _imageDirection % 4;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    CGSize imageSize = [self.imageView intrinsicContentSize];
    CGSize titleLabelSize = [self.titleLabel intrinsicContentSize];
    
    UIEdgeInsets contentEdgeInsets = self.contentEdgeInsets;
    UIEdgeInsets imageEdgeInsets = self.imageEdgeInsets;
    UIEdgeInsets titleEdgeInsets = self.titleEdgeInsets;
    
    CGFloat interval = 0.0;
    TZMButtonImageDirection imageDirection = (TZMButtonImageDirection) self.imageDirection;
    switch (imageDirection) {
        case TZMButtonImageDirectionLeft: {
            self.imageView.frame = CGRectMake(
                                              roundf((size.width - imageSize.width - titleLabelSize.width + contentEdgeInsets.left + imageEdgeInsets.left - contentEdgeInsets.right - imageEdgeInsets.right) / 2 - interval),
                                              roundf((size.height - imageSize.height + contentEdgeInsets.top + imageEdgeInsets.top - contentEdgeInsets.bottom - imageEdgeInsets.bottom) / 2),
                                              imageSize.width,
                                              imageSize.height
                                              );
            self.titleLabel.frame = CGRectMake(
                                               (size.width + imageSize.width - titleLabelSize.width + contentEdgeInsets.left + titleEdgeInsets.left - contentEdgeInsets.right - titleEdgeInsets.right) / 2 + interval,
                                               (size.height - titleLabelSize.height + contentEdgeInsets.top + titleEdgeInsets.top - contentEdgeInsets.bottom - titleEdgeInsets.bottom) / 2,
                                               titleLabelSize.width,
                                               titleLabelSize.height
                                               );
            break;
        }
        case TZMButtonImageDirectionRight:{
            self.imageView.frame = CGRectMake(
                                              roundf((size.width - imageSize.width + titleLabelSize.width + contentEdgeInsets.left + imageEdgeInsets.left - contentEdgeInsets.right - imageEdgeInsets.right) / 2 + interval),
                                              roundf((size.height - imageSize.height + contentEdgeInsets.top + imageEdgeInsets.top - contentEdgeInsets.bottom - imageEdgeInsets.bottom) / 2),
                                              imageSize.width,
                                              imageSize.height
                                              );
            self.titleLabel.frame = CGRectMake(
                                               (size.width - imageSize.width - titleLabelSize.width + contentEdgeInsets.left + titleEdgeInsets.left - contentEdgeInsets.right - titleEdgeInsets.right) / 2 - interval,
                                               (size.height - titleLabelSize.height + contentEdgeInsets.top + titleEdgeInsets.top - contentEdgeInsets.bottom - titleEdgeInsets.bottom) / 2,
                                               titleLabelSize.width,
                                               titleLabelSize.height
                                               );
            break;
        }
        case TZMButtonImageDirectionTop:{
            self.imageView.frame = CGRectMake(
                                              roundf((size.width - imageSize.width + contentEdgeInsets.left + imageEdgeInsets.left - contentEdgeInsets.right - imageEdgeInsets.right) / 2),
                                              roundf((size.height - imageSize.height - titleLabelSize.height + contentEdgeInsets.top + imageEdgeInsets.top - contentEdgeInsets.bottom - imageEdgeInsets.bottom) / 2 - interval),
                                              imageSize.width,
                                              imageSize.height
                                              );
            self.titleLabel.frame = CGRectMake(
                                               (size.width - titleLabelSize.width + contentEdgeInsets.left + titleEdgeInsets.left - contentEdgeInsets.right - titleEdgeInsets.right) / 2,
                                               (size.height + imageSize.height - titleLabelSize.height + contentEdgeInsets.top + titleEdgeInsets.top - contentEdgeInsets.bottom - titleEdgeInsets.bottom) / 2 + interval,
                                               titleLabelSize.width,
                                               titleLabelSize.height
                                               );
            break;
        }
        case TZMButtonImageDirectionBottom:{
            self.imageView.frame = CGRectMake(
                                              roundf((size.width - imageSize.width + contentEdgeInsets.left + imageEdgeInsets.left - contentEdgeInsets.right - imageEdgeInsets.right) / 2),
                                              roundf((size.height - imageSize.height + titleLabelSize.height + contentEdgeInsets.top + titleEdgeInsets.top - contentEdgeInsets.bottom - titleEdgeInsets.bottom) / 2 + interval),
                                              imageSize.width,
                                              imageSize.height
                                              );
            self.titleLabel.frame = CGRectMake(
                                               (size.width - titleLabelSize.width + contentEdgeInsets.left + titleEdgeInsets.left - contentEdgeInsets.right - titleEdgeInsets.right) / 2,
                                               (size.height - imageSize.height - titleLabelSize.height + contentEdgeInsets.top + titleEdgeInsets.top - contentEdgeInsets.bottom - titleEdgeInsets.bottom) / 2 - interval,
                                               titleLabelSize.width,
                                               titleLabelSize.height
                                               );
            break;
        }
    }
}

- (CGSize)intrinsicContentSize {
    CGSize size;
    
    CGSize imageSize = self.imageView.image.size;
    CGSize titleLabelSize;
    if (self.currentAttributedTitle) {
        titleLabelSize = [self.currentAttributedTitle boundingRectWithSize:CGSizeMake(1000, 1000)  options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    }else{
        titleLabelSize = [self.currentTitle boundingRectWithSize:CGSizeMake(1000, 1000)  options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName: self.titleLabel.font} context:nil].size;
    }
    
    TZMButtonImageDirection imageDirection = (TZMButtonImageDirection) self.imageDirection;
    switch (imageDirection) {
        case TZMButtonImageDirectionLeft:
        case TZMButtonImageDirectionRight: {
            size.width = imageSize.width + titleLabelSize.width;
            size.height = MAX(imageSize.height, titleLabelSize.height);
            break;
        }
        case TZMButtonImageDirectionTop:
        case TZMButtonImageDirectionBottom: {
            size.width = MAX(imageSize.width, titleLabelSize.width);
            size.height = imageSize.height + titleLabelSize.height;
            break;
        }
    }
    
    UIEdgeInsets contentEdgeInsets = self.contentEdgeInsets;
    size.width += (contentEdgeInsets.left + contentEdgeInsets.right);
    size.height += (contentEdgeInsets.top + contentEdgeInsets.bottom);
    return size;
}


@end
