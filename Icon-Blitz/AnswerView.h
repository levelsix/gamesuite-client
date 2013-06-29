//
//  AnswerView.h
//  Icon-Blitz
//
//  Created by Danny on 6/26/13.
//
//

#import <UIKit/UIKit.h>

@interface SelectionView : UIView

@property (nonatomic, assign) BOOL used;
@property (nonatomic, assign) int takenTag;
@property (nonatomic, strong) UIImageView *bottomBar;
@end

@interface AnswerView : UIImageView

@property (nonatomic, assign) BOOL taken;
@property (nonatomic, assign) int inArrayTag;

@end