//
//  ANMultiSelectionViewController.h
//  CameraDemo
//
//  Created by shiga on 20/03/20.
//  Copyright © 2020 shiga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ANMultiSelectionViewControllerDelegate <NSObject>
-(void)passImagesBackToController:(NSArray *)array;
@end

@interface ANMultiSelectionViewController : UIViewController
@property (nonatomic,assign)id<ANMultiSelectionViewControllerDelegate> imageDelegate;
@property (nonatomic, assign)int currentImageAddedCount;
@end

NS_ASSUME_NONNULL_END
