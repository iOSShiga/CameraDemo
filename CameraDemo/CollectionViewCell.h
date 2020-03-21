//
//  CollectionViewCell.h
//  CameraDemo
//
//  Created by shiga on 20/03/20.
//  Copyright © 2020 shiga. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet  UIImageView *imageView;
@property (weak, nonatomic) IBOutlet  UIImageView *chekUnCheckImageView;



@end

NS_ASSUME_NONNULL_END
