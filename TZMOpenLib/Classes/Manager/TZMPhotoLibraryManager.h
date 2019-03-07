//
//  TZMPhotoLibraryManager.h
//  SmartHome
//
//  Created by gemdale on 2018/8/6.
//  Copyright © 2018年 gemdale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photos/Photos.h"

@interface TZMPhotoLibraryManager : NSObject
//保存相片
+(void)saveImageIntoAlbumWithImage:(UIImage*)image block:(void(^)(NSError *error))block;
//保存视屏
+(void)saveVideoIntoAlbumWitVideoPath:(NSURL*)videoPath block:(void(^)(NSError *error))block;
@end
