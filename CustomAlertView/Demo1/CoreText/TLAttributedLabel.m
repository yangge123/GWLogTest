//
//  TLAttributedLabel.m
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/8.
//  Copyright (c) 2015年 周安德. All rights reserved.
//

#import "TLAttributedLabel.h"
#import "NSMutableAttributedString+CTFrameRef.h"
#import "NSMutableAttributedString+Picture.h"
#import "NSMutableAttributedString+Config.h"
#import "NSMutableAttributedString+Link.h"
#import "TLAttributedLabelUtils.h"

static NSString* const kEllipsesCharacter = @"\u2026";

@interface TLAttributedLabel ()

@property (nonatomic, strong) NSMutableAttributedString *attributedString;
@property (nonatomic, strong) TLAttributedLink *touchedLink; //选中的链接数据源
@property (nonatomic, assign) CTFrameRef frameRef;
@property (nonatomic, strong) NSMutableArray *images, *links;

@end

@implementation TLAttributedLabel

#pragma mark -
#pragma mark lifecycle
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configSettings];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configSettings];
    }
    return self;
}

- (void)setFrameRef:(CTFrameRef)frameRef {
    if (_frameRef != frameRef) {
        if (_frameRef != nil) {
            CFRelease(_frameRef);
        }
        CFRetain(frameRef);
        _frameRef = frameRef;
    }
}

- (void)dealloc {
    if (_frameRef != nil) {
        CFRelease(_frameRef);
        _frameRef = nil;
    }
}

- (void)removeAll {
    [_links removeAllObjects];
    [_images removeAllObjects];
}

- (void)configSettings {
    _lineSpacing       = 4.f;
    _paragraphSpacing  = 3.f;
    _showUrl           = NO;
    _imageSize         = CGSizeZero;
    _imageMargin       = UIEdgeInsetsMake(0, 1, 0, 1);
    _font              = [UIFont systemFontOfSize:16.f];
    _textColor         = [UIColor blackColor];
    _linkColor         = [UIColor blueColor];
    _highlightColor    = [UIColor lightGrayColor];
    _textAlignment     = kCTTextAlignmentLeft;
    _lineBreakMode     = kCTLineBreakByWordWrapping | kCTLineBreakByCharWrapping;
    _imageAlignment    = TLImageAlignmentCenter;
    
    _links = [NSMutableArray array];
    _images = [NSMutableArray array];
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark -
#pragma mark set and get
- (void)setFont:(UIFont *)font {
    if (font != _font) {
        _font = font;
        [_attributedString setFont:font];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (textColor != _textColor) {
        _textColor = textColor;
        [_attributedString setTextColor:textColor];
    }
}

- (void)setFrame:(CGRect)frame {
    if (!CGRectEqualToRect(self.frame, frame)) {
        if (_frameRef) {
            CFRelease(_frameRef);
            _frameRef = nil;
        }
        if ([NSThread isMainThread]) {
            [self setNeedsDisplay];
        }
    }
    
    [super setFrame:frame];
}

#pragma mark - 设置文本
- (void)setText:(NSString *)text {
    [self removeAll];
    NSAttributedString *attributedText = [self attributedString:text];
    [self setAttributedText:attributedText];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    // 处理图片
    self.images = [_attributedString setImageAlignment:_imageAlignment imageMargin:_imageMargin imageSize:_imageSize font:_font];
    
    // 处理链接
    self.links = [_attributedString setAttributedStringWithFont:_font showUrl:_showUrl linkColor:_linkColor images:_images];

    // 设置文字排版方式
    [_attributedString setAttributedsWithLineSpacing:_lineSpacing
                                    paragraphSpacing:_paragraphSpacing
                                       textAlignment:_textAlignment
                                       lineBreakMode:_lineBreakMode];
       
    [self setNeedsDisplay];
}

- (NSMutableAttributedString *)attributedString:(NSString *)text {
    return [self attributedString:text font:_font textColor:_textColor];
}

- (NSMutableAttributedString *)attributedString:(NSString *)text
                                           font:(UIFont *)font
                                      textColor:(UIColor *)textColor {
    if (!text && !text.length) {
        return nil;
    }
    
    // 初始化NSMutableAttributedString
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString setFont:font];
    [attributedString setTextColor:textColor];
    
    return attributedString;
}


//添加自定义链接
- (void)addCustomLink:(NSString *)link {
    [self addCustomLink:link font:_font linkColor:_linkColor];
}

- (void)addCustomLink:(NSString *)link
                 font:(UIFont *)font
            linkColor:(UIColor *)color {
    for (TLAttributedLink *linkData in _links) {
        // 如果自定义的链接根系统检查出来的链接重复，则不添加自定义链接
        if ([linkData.title rangeOfString:link].location != NSNotFound) {
            return;
        }
    }
    
    NSArray *links = [_attributedString setCustomLink:link font:font linkColor:color];
    [_links addObjectsFromArray:links];
    
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark 获取label的size
- (CGSize)sizeThatFits:(CGSize)size {
    if (!_attributedString) {
        return CGSizeZero;
    }
    // _numberOfLines行情况下文字的高度
    CGFloat height = [_attributedString boundingHeightForWidth:size.width
                                                 numberOfLines:_numberOfLines];
    return CGSizeMake(size.width, height);;
}

// 获取当前需要展示的行数
- (NSUInteger)currentNumberOfLines {
    CFArrayRef lines = CTFrameGetLines(_frameRef);
    CFIndex lineCount = CFArrayGetCount(lines);
    
    return _numberOfLines > 0 ? MIN(_numberOfLines, lineCount) : lineCount;
}

#pragma mark -
#pragma mark 点击事件相应
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    
    // 检查是否选中链接
    TLAttributedLink *linkData = [TLAttributedLabelUtils touchLinkInView:self links:_links point:point frameRef:_frameRef];
    if (linkData) {
        self.touchedLink = linkData;
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    
    if (self.touchedLink) {
        
        TLAttributedLink *linkData = [TLAttributedLabelUtils touchLinkInView:self links:_links point:point frameRef:_frameRef];
        if (linkData != self.touchedLink) {
            self.touchedLink = nil;
            [self setNeedsDisplay];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    // 检查文字
    if (self.touchedLink) {
        if ([self.delegate respondsToSelector:@selector(attributedLabel:linkData:)]) {
            [self.delegate attributedLabel:self linkData:self.touchedLink];
            self.touchedLink = nil;
            [self setNeedsDisplay];
        }
    }
}

#pragma mark -
#pragma mark drawRect
- (void)drawRect:(CGRect)rect {
    if (!_attributedString) {
        return;
    }

    // 1.获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();

    // 2.将坐标系上下翻转
    CGAffineTransform transform =  CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
    CGContextConcatCTM(context, transform);

    // 3.获取CTFrameRef
    self.frameRef = [_attributedString prepareFrameRefWithRect:rect];
    
    // 4.绘制高亮背景
    [self drawHighlightWithRect:rect];
    
    // 5.绘制文字
    [self drawCloseContext:context];

    // 6.绘制图片
    [self drawImages];
}

- (void)drawHighlightWithRect:(CGRect)rect {
    if (self.touchedLink && self.highlightColor) {
        [self.highlightColor setFill];
        
        NSRange linkRange = self.touchedLink.range;
        
        // 偏移
        CGPathRef pathRef = CTFrameGetPath(_frameRef);
        CGRect colRect = CGPathGetBoundingBox(pathRef);
        
        CFArrayRef lines = CTFrameGetLines(_frameRef);
        CFIndex count = CFArrayGetCount(lines);
        CGPoint lineOrigins[count];
        CTFrameGetLineOrigins(_frameRef, CFRangeMake(0, 0), lineOrigins);
        
        for (CFIndex i = 0; i < count; i++) {
            CTLineRef line = CFArrayGetValueAtIndex(lines, i);
            
            if (CTLineContainsCharactersFromStringRange(line, linkRange)) continue;
            
            CGRect highlightRect = CTRunGetTypographicBoundsForLinkRect(line, linkRange, lineOrigins[i]);
            
            highlightRect = CGRectOffset(highlightRect, 0, -rect.origin.y);
            highlightRect = CGRectOffset(highlightRect, colRect.origin.x, colRect.origin.y);
            
            CGRect rect = CGRectMake(CGRectGetMinX(highlightRect) - 1, CGRectGetMinY(highlightRect) - 1, CGRectGetWidth(highlightRect) + 2, CGRectGetHeight(highlightRect) + 2);
            
            if (!CGRectIsEmpty(rect)) {
                //  绘制背景颜色
                [self drawBackgroundColorWithRect:rect];
            }
        }
    }
}

- (void)drawBackgroundColorWithRect:(CGRect)rect {
    CGFloat radius = 2.0f;
    CGFloat pointX = rect.origin.x;
    CGFloat pointY = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 移动到初始点
    CGContextMoveToPoint(context, pointX, pointY);
    
    // 绘制第1条线和第1个1/4圆弧，右上圆弧
    CGContextAddLineToPoint(context, pointX + width - radius, pointY);
    CGContextAddArc(context, pointX + width - radius, pointY + radius, radius, -0.5*M_PI, 0.0, 0);
    
    // 绘制第2条线和第2个1/4圆弧，右下圆弧
    CGContextAddLineToPoint(context, pointX + width, pointY + height - radius);
    CGContextAddArc(context, pointX + width - radius, pointY + height - radius, radius, 0.0, 0.5*M_PI, 0);
    
    // 绘制第3条线和第3个1/4圆弧，左下圆弧
    CGContextAddLineToPoint(context, pointX + radius, pointY + height);
    CGContextAddArc(context, pointX + radius, pointY + height - radius, radius, 0.5*M_PI, M_PI, 0);
    
    // 绘制第4条线和第4个1/4圆弧，左上圆弧
    CGContextAddLineToPoint(context, pointX, pointY + radius);
    CGContextAddArc(context, pointX + radius, pointY + radius, radius, M_PI, 1.5*M_PI, 0);
    
    // 闭合路径
    CGContextFillPath(context);
}

- (void)drawImages {
    if (!_frameRef && !_links.count) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CFArrayRef lines = CTFrameGetLines(_frameRef);
    CFIndex lineCount = CFArrayGetCount(lines);
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(_frameRef, CFRangeMake(0, 0), lineOrigins);
    NSInteger numberOfLines =  [self currentNumberOfLines];
    
    for (CFIndex index = 0; index < numberOfLines; index++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, index);
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        CFIndex runCount = CFArrayGetCount(runs);
        CGPoint lineOrigin = lineOrigins[index];

        for (CFIndex idx = 0; idx < runCount; idx++) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, idx);
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (nil == delegate) {
                continue;
            }
            TLAttributedImage *imageData = (TLAttributedImage *)CTRunDelegateGetRefCon(delegate);
            // 获取将要展示图片的frame
            CGRect rect = CTRunGetTypographicBoundsForImageRect(run, line, lineOrigin, imageData);
            
            if (index == numberOfLines - 1 && idx >= runCount - 2 && _lineBreakMode == kCTLineBreakByTruncatingTail) {
                //最后行最后的2个CTRun需要做额外判断
                CGFloat attachmentWidth = CGRectGetWidth(rect);
                const CGFloat kMinEllipsesWidth = attachmentWidth;
                if (CGRectGetWidth(self.bounds) - CGRectGetMinX(rect) - attachmentWidth <  kMinEllipsesWidth) {
                    continue;
                }
            }
            
            // 绘制图片
            if ([imageData.attributedImage isKindOfClass:[UIImage class]]) {
                UIImage *image = imageData.attributedImage;
                CGContextDrawImage(context, rect, image.CGImage);
            }
            else if ([imageData.attributedImage isKindOfClass:[UIImageView class]]) {
                CGRect frame = CGRectMake(rect.origin.x,
                                              self.bounds.size.height - rect.origin.y - rect.size.height,
                                              rect.size.width,
                                              rect.size.height);
                
                UIImageView *imageView = imageData.attributedImage;
                if (imageView.superview == nil) {
                    [self addSubview:imageView];
                }
                [imageView setFrame:frame];
            }
            else {
                NSLog(@"view类型的");
            }
        }
    }
}

- (void)drawCloseContext:(CGContextRef)context{
    CGPathRef path = CTFrameGetPath(_frameRef);
    CGRect rect = CGPathGetBoundingBox(path);
    CFArrayRef lines = CTFrameGetLines(_frameRef);

    NSInteger numberOfLines = [self currentNumberOfLines];
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(_frameRef, CFRangeMake(0, numberOfLines), lineOrigins);
    NSAttributedString *attributedString = [_attributedString mutableCopy];
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        CGPoint lineOrigin = lineOrigins[lineIndex];
        lineOrigin.y =  self.frame.size.height + (lineOrigin.y - rect.size.height);
        
        CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        BOOL shouldDrawLine = YES;

        if (lineIndex == numberOfLines - 1) {
            CFRange lastLineRange = CTLineGetStringRange(line);

            if (lastLineRange.location + lastLineRange.length < (CFIndex)attributedString.length) {
                CTLineTruncationType truncationType = kCTLineTruncationEnd;
                NSUInteger truncationAttributePosition = lastLineRange.location + lastLineRange.length - 1;
                
                NSDictionary *tokenAttributes = [attributedString attributesAtIndex:truncationAttributePosition
                                                                     effectiveRange:NULL];
                NSMutableAttributedString *tokenString = [[NSMutableAttributedString alloc] initWithString:kEllipsesCharacter
                                                                                  attributes:tokenAttributes];
                
                CTLineRef truncationToken = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)tokenString);
                
                NSMutableAttributedString *truncationString = [[attributedString attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)] mutableCopy];
                
                if (lastLineRange.length > 0) {
                    unichar lastCharacter = [[truncationString string] characterAtIndex:lastLineRange.length - 1];
                    if ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:lastCharacter]) {
                        [truncationString deleteCharactersInRange:NSMakeRange(lastLineRange.length - 1, 1)];
                    }
                }
                [truncationString appendAttributedString:tokenString];

                // 替换
                CTLineRef truncationLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)truncationString);
                CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, self.frame.size.width, truncationType, truncationToken);
                if (!truncatedLine) {
                    truncatedLine = CFRetain(truncationToken);
                }
                CFRelease(truncationLine);
                CFRelease(truncationToken);
                
                CTLineDraw(truncatedLine, context);
                NSUInteger truncatedCount =  CTLineGetGlyphCount(truncatedLine);
                
                // 获取当前显示的文字
                NSMutableAttributedString *showString = [[attributedString attributedSubstringFromRange:NSMakeRange(0, lastLineRange.location + truncatedCount - tokenString.length)] mutableCopy];
                [showString appendAttributedString:tokenString];
                
                // 获取绘制后的新属性
                self.frameRef = [showString prepareFrameRefWithRect:self.frame];

                CFRelease(truncatedLine);

                shouldDrawLine = NO;
            }
        }
        
        if (shouldDrawLine) {
            CTLineDraw(line, context);
        }
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
