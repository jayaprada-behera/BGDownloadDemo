//
//  WACustomCell.m
//  BGFetchDemo
//
//  Created by Jayaprada Behera on 09/04/14.
//  Copyright (c) 2014 Webileapps. All rights reserved.
//

#import "WACustomCell.h"

@implementation WACustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)startOrPauseDownloadingSingleFile:(id)sender{
  
    if (self.playPauseButtonCallBack) {
        self.playPauseButtonCallBack(nil);
    }
    
}

- (IBAction)stopDownloading:(id)sender{
   
    if (self.stopButtonCallBack) {
        self.stopButtonCallBack(nil);
    }
    
}
@end
