//
//  LELoadingView.h
//  LKAppBoxSDK
//
//  Created by leoan on 2020/4/1.
//  Copyright © 2020 MrDML. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LELoadingView : UIView
+ (instancetype)instance;
- (void)showLoging:(UIView *)superView;
- (void)hiddenLoging;
@end

NS_ASSUME_NONNULL_END
