//
//  TZMPhotoLibraryManager.m
//  SmartHome
//
//  Created by gemdale on 2018/8/6.
//  Copyright © 2018年 gemdale. All rights reserved.
//

#import "TZMPhotoLibraryManager.h"

@implementation TZMPhotoLibraryManager

//获取当前应用相册
+(void)currentAssetCollectionWithBlock:(void(^)(PHAssetCollection *assetCollection,NSError *error))block{
    NSString *title = [[NSBundle mainBundle].infoDictionary objectForKey:((NSString*)kCFBundleNameKey)];
    // 获得所有的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            if (block) {
                block(collection,nil);
            }
            return;
        }
    }
    
    // 代码执行到这里，说明还没有自定义相册
    __block NSString *createdCollectionId = nil;
    // 创建一个新的相册
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    if (createdCollectionId == nil){
        if (block) {
            block(nil,error);
        }
    }else{
        if (block) {
            block([PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionId] options:nil].firstObject,nil);
        }
    }
}

//图片生成资源
+(void)createdAssetsImage:(UIImage*)image block:(void(^)(PHFetchResult<PHAsset *> *asset,NSError *error))block{
    __block NSString *createdAssetId = nil;
    // 添加图片到【相机胶卷】
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    
    if (createdAssetId == nil){
        if (block) {
            block(nil,error);
        }
    }else{
        if (block) {
            block([PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil],nil);
        }
    }
}

//视频路径生成资源
+(void)createdAssetsVideoPath:(NSURL*)videoPath block:(void(^)(PHFetchResult<PHAsset *> *asset,NSError *error))block{
    __block NSString *createdAssetId = nil;
    // 添加图片到【相机胶卷】
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoPath].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    
    if (createdAssetId == nil){
        if (block) {
            block(nil,error);
        }
    }else{
        if (block) {
            block([PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil],nil);
        }
    }
}

+(BOOL)authorizationStatus{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        return YES;
    }else{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
        }];
        return NO;
    }
}

//保存相片
+(void)saveImageIntoAlbumWithImage:(UIImage*)image block:(void(^)(NSError *error))block{
    if (![TZMPhotoLibraryManager authorizationStatus]) {
        if (block) {
            block([NSError errorWithDomain:@"authorizationStatus" code:1 userInfo:@{NSLocalizedDescriptionKey:@"没有用户相册权限，请到设置打开"}]);
        }
        return;
    }
    [TZMPhotoLibraryManager createdAssetsImage:image block:^(PHFetchResult<PHAsset *> *asset, NSError *error) {
        if (asset) {
            [TZMPhotoLibraryManager currentAssetCollectionWithBlock:^(PHAssetCollection *assetCollection, NSError *error) {
                if (assetCollection) {
                    NSError *error = nil;
                    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                        [request insertAssets:asset atIndexes:[NSIndexSet indexSetWithIndex:0]];
                    } error:&error];
                    if (error) {
                        if (block) {
                            block(error);
                        }
                    }else{
                        if (block) {
                            block(nil);
                        }
                    }
                }else{
                    if (block) {
                        block(error);
                    }
                }
            }];
        }else{
            if (block) {
                block(error);
            }
        }
    }];
}

+(void)saveVideoIntoAlbumWitVideoPath:(NSURL*)videoPath block:(void(^)(NSError *error))block{
    if (![TZMPhotoLibraryManager authorizationStatus]) {
        if (block) {
            block([NSError errorWithDomain:@"authorizationStatus" code:1 userInfo:@{NSLocalizedDescriptionKey:@"没有用户相册权限，请到设置打开"}]);
        }
        return;
    }
    [TZMPhotoLibraryManager createdAssetsVideoPath:videoPath block:^(PHFetchResult<PHAsset *> *asset, NSError *error) {
        if (asset) {
            [TZMPhotoLibraryManager currentAssetCollectionWithBlock:^(PHAssetCollection *assetCollection, NSError *error) {
                if (assetCollection) {
                    NSError *error = nil;
                    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                        [request insertAssets:asset atIndexes:[NSIndexSet indexSetWithIndex:0]];
                    } error:&error];
                    if (error) {
                        if (block) {
                            block(error);
                        }
                    }else{
                        if (block) {
                            block(nil);
                        }
                    }
                }else{
                    if (block) {
                        block(error);
                    }
                }
            }];
        }else{
            if (block) {
                block(error);
            }
        }
    }];
}


@end
