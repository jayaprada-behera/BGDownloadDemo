//
//  WAFileDownloadInfo.m
//  BGFetchDemo
//
//  Created by Jayaprada Behera on 09/04/14.
//  Copyright (c) 2014 Webileapps. All rights reserved.
//

#import "WAFileDownloadInfo.h"

@implementation WAFileDownloadInfo

-(id)initWithFileTitle:(NSString *)title andDownloadSource:(NSString *)source{
    if (self == [super init]) {
        self.fileTitle = title;
        self.downloadSource = source;
        self.downloadProgress = 0.0;
        self.isDownloading = NO;
        self.downloadComplete = NO;
        self.taskIdentifier = -1;
    }
    
    return self;
}

@end
