//
//  WACustomCell.h
//  BGFetchDemo
//
//  Created by Jayaprada Behera on 09/04/14.
//  Copyright (c) 2014 Webileapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WACustomCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel *fileName;
@property(nonatomic,weak)IBOutlet UILabel *progressLbl;

@property(nonatomic,weak)IBOutlet UIProgressView *progressBar;
@property(nonatomic,weak)IBOutlet UILabel *readyLbl;
@property(nonatomic,weak)IBOutlet UIButton *stopButton;
@property(nonatomic,weak)IBOutlet UIButton *playPauseButton;

@property(readwrite,copy)void (^playPauseButtonCallBack)(NSIndexPath *cellIndex);
@property(readwrite,copy)void (^stopButtonCallBack)(NSIndexPath *cellIndex);

- (IBAction)startOrPauseDownloadingSingleFile:(id)sender;

- (IBAction)stopDownloading:(id)sender;


@end
