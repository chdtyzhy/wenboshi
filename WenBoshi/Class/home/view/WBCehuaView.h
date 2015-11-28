//
//  WBCehuaView.h
//  WenBoshi
//
//  Created by 马浩然 on 15/1/27.
//  Copyright (c) 2015年 luoshuisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum :NSInteger{
    WBCehuaCase,
    WBCehuaSetting
}WBCehuaBtnTag;

@protocol WBCehuaDelegate <NSObject>
@optional
-(void)cehuaBtnClick:(int)tag;

@end

@interface WBCehuaView : UIView

@property (nonatomic ,assign) id <WBCehuaDelegate> delegate;

@end
