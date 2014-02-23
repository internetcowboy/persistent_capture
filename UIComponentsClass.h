//
//  UIComponentsClass.h
//  BLE
//
//  Description: This class was created to clean up some UI form code for easier creation and readability.
//
//
//  Created by InternetCowboy | Codin Pangell on 12/5/13.
//  Copyright (c) 2013 InternetCowboy | Codin Pangell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIComponentsClass : NSObject


- (UITextField *)newField: (NSString *)placeholder
                        y:(NSInteger)y
                        x:(NSInteger)x
                        w:(NSInteger)w
                        h:(NSInteger)h;

- (UILabel *)newLabel: (NSString *)text
                    y:(NSInteger)y
                    x:(NSInteger)x
                    w:(NSInteger)w
                    h:(NSInteger)h;

- (UIButton *)newButton: (NSString *)text
                      y:(NSInteger)y
                      x:(NSInteger)x
                      w:(NSInteger)w
                      h:(NSInteger)h
                  color:(UIColor *)color;

- (UILabel *)newCustomFontLabel: (NSString *)text
                              y:(NSInteger)y
                              x:(NSInteger)x
                              w:(NSInteger)w
                              h:(NSInteger)h
                       fontName:(NSString *)fontName
                       fontSize:(NSInteger)fontSize;

- (UISwitch *)newSwitch:(NSInteger)y
                      x:(NSInteger)x
                      w:(NSInteger)w
                      h:(NSInteger)h;


- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

- (UIImage *)imageRotatedByDegrees:(UIImage*)oldImage deg:(CGFloat)degrees;

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@end
