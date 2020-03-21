//
//  ANMultiSelectionViewController.m
//  CameraDemo
//
//  Created by shiga on 20/03/20.
//  Copyright © 2020 shiga. All rights reserved.
//

#import "ANMultiSelectionViewController.h"
#import "CollectionViewCell.h"

@interface ANMultiSelectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource> {
 __block NSMutableArray *imageAssets;
NSMutableArray *selectedImageArray;
    

}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *lblImageCount;
@property (weak, nonatomic) IBOutlet UIImageView *imageDisplay;

@end

@implementation ANMultiSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  
    
    [self imageGallery];
}


-(void)imageGallery {
    imageAssets = [[NSMutableArray alloc] init];
    selectedImageArray = [[NSMutableArray alloc] init];

   // [self addSpinner];//As getting all images will take time. will   stop once all images added.
    [self getAllImagesFromGallary];
}

-(void)getAllImagesFromGallary {
    
if(PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusDenied || PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusRestricted ){
[self showMessage:@"Access Denied, This app required permision to Photo Library. Please allow access from setting"];
}else{
@autoreleasepool {


       [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if(PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusAuthorized){
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.sortDescriptors = @[[NSSortDescriptor     sortDescriptorWithKey:@"creationDate" ascending:true]];
        PHFetchResult *imgArr = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
        for(int i=0; i<imgArr.count;i++){
            [self->imageAssets addObject:imgArr[i]];
     }
      dispatch_async(dispatch_get_main_queue(), ^{
      [self.collectionView reloadData];
    //  [self removeSpinner];
    });
   }
}];
}
}
}
-(UIImage *)getAssetThumbnail:(PHAsset *)asset {
@autoreleasepool {
         PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
         [option setSynchronous:true];
          __block UIImage *temp;
    
    [PHImageManager.defaultManager requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        temp = result;
        
        self.imageDisplay.image = result;
        
    }];
    
    return temp;
 }
}
-(void)showMessage:(NSString *)alertMessage{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert!" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok =[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:true completion:nil];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  imageAssets.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.imageView.image = [self getAssetThumbnail:[imageAssets objectAtIndex:indexPath.row]];
    
          if ([selectedImageArray containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
         cell.chekUnCheckImageView.image = [UIImage systemImageNamed:@"checkmark.circle.fill"];
       }else{
         cell.chekUnCheckImageView.image = [UIImage systemImageNamed:@"checkmark.circle"];
    }

    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        if(self.currentImageAddedCount+selectedImageArray.count<50){
            
            NSString *selectedRow = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
            
        if ([selectedImageArray containsObject:selectedRow]) {
        [selectedImageArray removeObjectAtIndex:[selectedImageArray indexOfObject:selectedRow]];
}else{
        [selectedImageArray addObject:selectedRow];//If no, add it
}
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexPath.row inSection:0]]];
         self.lblImageCount.text = [NSString stringWithFormat:@"%lu IMAGE SELECTED",(unsigned long)selectedImageArray.count];
}else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Reached Max Limit : 50" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok =[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
      [self presentViewController:alert animated:true completion:nil];
  }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 3.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
    CGSize size = CGSizeMake(cellWidth, cellWidth);

    return size;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)didTapCanecl:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];

}
- (IBAction)didTapDone:(id)sender {
    if(selectedImageArray.count==0){
          UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"No Image Selected. Please Select Image To Add" preferredStyle:UIAlertControllerStyleAlert];
          UIAlertAction *ok =[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
          [alert addAction:ok];
          [self presentViewController:alert animated:true completion:nil];
        }else{
          NSMutableArray *images = [[NSMutableArray alloc] init];
          for(NSString *index in selectedImageArray){
               [images addObject:[self getAssetThumbnail:imageAssets[index.integerValue]]];
        }
       [self.imageDelegate passImagesBackToController:images];
       [self dismissViewControllerAnimated:true completion:nil];
    }
}

@end
