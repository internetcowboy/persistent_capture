//
//  UIComponentsClass.m
//  BLE
//
//  Description: This class was created to clean up some UI form code for easier creation and readability.
//
//  Created by HUGE | Codin Pangell on 12/5/13.
//  Copyright (c) 2013 InternetCowboy | Codin Pangell. All rights reserved.
//

#import "UIComponentsClass.h"


CGFloat const kTextFieldFontSize = 12.0f;
CGFloat const kLabelFontSize = 12.0f;
CGFloat const kButtonFontSize = 12.0f;

@interface UIComponentsClass () {
	UITextField *newField;
    UIButton *newButton;
    UILabel *newLabel;
    UILabel *newCustomFontLabel;
    UISwitch *newSwitch;
}
@end

@implementation UIComponentsClass



/*
 CHECK THESE OUT:
 
 https://developer.apple.com/library/ios/documentation/userexperience/conceptual/UIKitUICatalog/UISwitch.html#//apple_ref/doc/uid/TP40012857-UISwitch
 
 */

- (UISwitch *)newSwitch:(NSInteger)y
                       x:(NSInteger)x
                       w:(NSInteger)w
                       h:(NSInteger)h {
    newSwitch = [UISwitch new];
    newSwitch.frame = CGRectMake(y, x, w, h);
    newSwitch.enabled = YES;
    [newSwitch setOn:YES animated:YES];
    return newSwitch;
}

- (UITextField *)newField: (NSString *)placeholder
                        y:(NSInteger)y
                        x:(NSInteger)x
                        w:(NSInteger)w
                        h:(NSInteger)h {
    
    newField = [UITextField new];
    newField.textColor = [UIColor lightGrayColor];
    newField.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(kTextFieldFontSize)];
    newField.frame = CGRectMake(x, y, w, h);
    
    newField.borderStyle = UITextBorderStyleRoundedRect;
    newField.placeholder = placeholder;
    newField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    return newField;
}

- (UILabel *)newCustomFontLabel: (NSString *)text
                              y:(NSInteger)y
                              x:(NSInteger)x
                              w:(NSInteger)w
                              h:(NSInteger)h
                              fontName:(NSString *)fontName
                              fontSize:(NSInteger)fontSize
{
    /*FYI, this took me a while, Click the font file, and select in the menu on the right your project at the section "Target Membership" if not already selected*/
    
    newCustomFontLabel = [UILabel new];
    newCustomFontLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    newCustomFontLabel.textColor = [UIColor blackColor];
    newCustomFontLabel.textAlignment = NSTextAlignmentLeft;
    newCustomFontLabel.font = [UIFont fontWithName:fontName size:(fontSize)];
    newCustomFontLabel.frame = CGRectMake(y, x, w, h);
    newCustomFontLabel.text = text;
    [newCustomFontLabel sizeToFit];
    
    return newCustomFontLabel;
    
}
- (UILabel *)newLabel: (NSString *)text
                    y:(NSInteger)y
                    x:(NSInteger)x
                    w:(NSInteger)w
                    h:(NSInteger)h {
    
    newLabel = [UILabel new];
    newLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    newLabel.textColor = [UIColor blackColor];
    newLabel.textAlignment = NSTextAlignmentLeft;
    newLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(kLabelFontSize)];
    newLabel.frame = CGRectMake(x, y, w, h);
    newLabel.text = text;
    [newLabel sizeToFit];
    
    return newLabel;
}

- (UIButton *)newButton: (NSString *)text
                    y:(NSInteger)y
                    x:(NSInteger)x
                    w:(NSInteger)w
                    h:(NSInteger)h
                color:(UIColor *)color {
    
        newButton = [UIButton new];
        newButton.frame = CGRectMake(y, x, w, h);
        [newButton.titleLabel setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:(kButtonFontSize)]];
        [newButton setTitle:text forState:UIControlStateNormal];
        [newButton setBackgroundColor:color];
    
    
    return newButton;
}


- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (UIImage *)imageRotatedByDegrees:(UIImage*)oldImage deg:(CGFloat)degrees{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,oldImage.size.width, oldImage.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, (degrees * M_PI / 180));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-oldImage.size.width / 2, -oldImage.size.height / 2, oldImage.size.width, oldImage.size.height), [oldImage CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
