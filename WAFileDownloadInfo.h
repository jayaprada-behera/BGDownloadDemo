//
//  WAFileDownloadInfo.h
//  BGFetchDemo
//
//  Created by Jayaprada Behera on 09/04/14.
//  Copyright (c) 2014 Webileapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WAFileDownloadInfo : NSObject

@property (nonatomic, strong) NSString *fileTitle;

@property (nonatomic, strong) NSString *downloadSource;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, strong) NSData *taskResumeData;

@property (nonatomic) double downloadProgress;

@property (nonatomic) BOOL isDownloading;

@property (nonatomic) BOOL downloadComplete;

@property (nonatomic) unsigned long taskIdentifier;

-(id)initWithFileTitle:(NSString *)title andDownloadSource:(NSString *)source;

@end
