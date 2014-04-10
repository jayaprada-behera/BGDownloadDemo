//
//  WABGFetchViewController.m
//  BGFetchDemo
//
//  Created by Jayaprada Behera on 09/04/14.
//  Copyright (c) 2014 Webileapps. All rights reserved.
//

#import "WABGFetchViewController.h"
#import "WACustomCell.h"
#import "WAFileDownloadInfo.h"
#import "WAAppDelegate.h"

@interface WABGFetchViewController ()<UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSMutableArray *arrFileDownloadData;

@property (nonatomic, strong) NSURL *docDirectoryURL;


@property (weak, nonatomic) IBOutlet UITableView *tblFiles;

-(int)getFileDownloadInfoIndexWithTaskIdentifier:(unsigned long)taskIdentifier;

-(void)initializeFileDownloadDataArray;

- (IBAction)stopAllDownloads:(id)sender;

- (IBAction)initializeAll:(id)sender;

@end

@implementation WABGFetchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"https://itunes.apple.com/search?term=apple&media=software"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@", json);
    }];
    [self initializeFileDownloadDataArray];
    
    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    self.docDirectoryURL = [URLs objectAtIndex:0];
    [self.tblFiles reloadData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.BGFetchDemo"];
    
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 5;
    
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:self
                                            delegateQueue:nil];
    
    UIBarButtonItem *refreshAllDownload = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAllDownload:)];
    self.navigationItem.rightBarButtonItem = refreshAllDownload;
    
}
#pragma mark - UIButtonActions

-(IBAction)refreshAllDownload:(id)sender{
   
    // Access all FileDownloadInfo objects using a loop and give all properties their initial values.
    for (int i=0; i<[self.arrFileDownloadData count]; i++) {
        WAFileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:i];
        
        if (fdi.isDownloading) {
            [fdi.downloadTask cancel];
        }
        
        fdi.isDownloading = NO;
        fdi.downloadComplete = NO;
        fdi.taskIdentifier = -1;
        fdi.downloadProgress = 0.0;
        fdi.downloadTask = nil;
    }
    
    // Reload the table view.
    [self.tblFiles reloadData];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Get all files in documents directory.
    NSArray *allFiles = [fileManager contentsOfDirectoryAtURL:self.docDirectoryURL
                                   includingPropertiesForKeys:nil
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];
    for (int i=0; i<[allFiles count]; i++) {
        [fileManager removeItemAtURL:[allFiles objectAtIndex:i] error:nil];
    }
  
}
- (IBAction)stopAllDownloads:(id)sender{
    // Access all FileDownloadInfo objects using a loop.
    for (int i=0; i<[self.arrFileDownloadData count]; i++) {
        WAFileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:i];
        
        // Check if a file is being currently downloading.
        if (fdi.isDownloading) {
            // Cancel the task.
            [fdi.downloadTask cancel];
            
            // Change all related properties.
            fdi.isDownloading = NO;
            fdi.taskIdentifier = -1;
            fdi.downloadProgress = 0.0;
            fdi.downloadTask = nil;
        }
    }
    
    // Reload the table view.
    [self.tblFiles reloadData];
  
}

- (IBAction)initializeAll:(id)sender{
    // Access all FileDownloadInfo objects using a loop.
    for (int i=0; i<[self.arrFileDownloadData count]; i++) {
        WAFileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:i];
        
        // Check if a file is already being downloaded or not.
        if (!fdi.isDownloading) {
            // Check if should create a new download task using a URL, or using resume data.
            if (fdi.taskIdentifier == -1) {
                fdi.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:fdi.downloadSource]];
            }
            else{
                fdi.downloadTask = [self.session downloadTaskWithResumeData:fdi.taskResumeData];
            }
            
            // Keep the new taskIdentifier.
            fdi.taskIdentifier = fdi.downloadTask.taskIdentifier;
            
            // Start the download.
            [fdi.downloadTask resume];
            
            // Indicate for each file that is being downloaded.
            fdi.isDownloading = YES;
        }
    }
    
    // Reload the table view.
    [self.tblFiles reloadData];
  
}
-(void)playPauseButtonTappedFromCellWithIndex:(NSIndexPath *)cellIndexPath{

    WAFileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:cellIndexPath.row];
    
    if (!fdi.isDownloading) {
        //start download
        
        if (fdi.taskIdentifier == -1) {
            fdi.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:fdi.downloadSource]];
            fdi.taskIdentifier = fdi.downloadTask.taskIdentifier;
            [fdi.downloadTask resume];
        }else{
            
        }
    }else{
        //pause download
        
    }
    // Change the isDownloading property value.
    fdi.isDownloading = !fdi.isDownloading;
    
    // Reload the table view.
    [self.tblFiles reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}
-(void)stopButtonTappedFromCellWithIndex:(NSIndexPath *)cellIndex{
    
}

-(void)initializeFileDownloadDataArray{
    
    self.arrFileDownloadData = [[NSMutableArray alloc] init];
    
    [self.arrFileDownloadData addObject:[[WAFileDownloadInfo alloc] initWithFileTitle:@"iOS Programming Guide" andDownloadSource:@"https://developer.apple.com/library/ios/documentation/iphone/conceptual/iphoneosprogrammingguide/iphoneappprogrammingguide.pdf"]];
    
    [self.arrFileDownloadData addObject:[[WAFileDownloadInfo alloc] initWithFileTitle:@"Human Interface Guidelines" andDownloadSource:@"https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/MobileHIG.pdf"]];
    
    [self.arrFileDownloadData addObject:[[WAFileDownloadInfo alloc] initWithFileTitle:@"Networking Overview" andDownloadSource:@"https://developer.apple.com/library/ios/documentation/NetworkingInternetWeb/Conceptual/NetworkingOverview/NetworkingOverview.pdf"]];
    
    [self.arrFileDownloadData addObject:[[WAFileDownloadInfo alloc] initWithFileTitle:@"AV Foundation" andDownloadSource:@"https://developer.apple.com/library/ios/documentation/AudioVideo/Conceptual/AVFoundationPG/AVFoundationPG.pdf"]];
    
    [self.arrFileDownloadData addObject:[[WAFileDownloadInfo alloc] initWithFileTitle:@"iPhone User Guide" andDownloadSource:@"http://manuals.info.apple.com/MANUALS/1000/MA1565/en_US/iphone_user_guide.pdf"]];
    
    
}
-(int)getFileDownloadInfoIndexWithTaskIdentifier:(unsigned long)taskIdentifier{
    int index = 0;
    for (int i=0; i<[self.arrFileDownloadData count]; i++) {
        WAFileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:i];
        if (fdi.taskIdentifier == taskIdentifier) {
            index = i;
            break;
        }
    }
    
    return index;
}
#pragma mark - UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrFileDownloadData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WACustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"WACustomCell" owner:self options:nil];
        cell = [arr objectAtIndex:0];
    }
    
    cell.playPauseButtonCallBack = ^(NSIndexPath *cellIndex){
        [self playPauseButtonTappedFromCellWithIndex:indexPath];
    };
    
    cell.stopButtonCallBack  = ^(NSIndexPath *cellIndex){
        [self stopButtonTappedFromCellWithIndex:indexPath];
    };
    
    // Get the respective FileDownloadInfo object from the arrFileDownloadData array.
    WAFileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:indexPath.row];
    
    
    cell.fileName.text = fdi.fileTitle;
    
    NSString *startPauseButtonImageName;
    
    
    // Depending on whether the current file is being downloaded or not, specify the status
    // of the progress bar and the couple of buttons on the cell.
    if (!fdi.isDownloading) {
        // Hide the progress view and disable the stop button.
        cell.progressBar.hidden = YES;
        cell.stopButton.enabled = NO;
        
        // Set a flag value depending on the downloadComplete property of the fdi object.
        // Using it will be shown either the start and stop buttons, or the Ready label.
        BOOL hideControls = (fdi.downloadComplete) ? YES : NO;
        cell.playPauseButton.hidden = hideControls;
        cell.stopButton.hidden = hideControls;
        cell.readyLbl.hidden = !hideControls;
        
        startPauseButtonImageName = @"play-25";
    }
    else{
        // Show the progress view and update its progress, change the image of the start button so it shows
        // a pause icon, and enable the stop button.
        cell.progressBar.hidden = NO;
        cell.progressBar.progress = fdi.downloadProgress;
        
        cell.stopButton.enabled = YES;
        
        startPauseButtonImageName = @"pause-25";
    }
    
    // Set the appropriate image to the start button.
    [cell.playPauseButton setImage:[UIImage imageNamed:startPauseButtonImageName] forState:UIControlStateNormal];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

#pragma mark - NSURLSESSIONDELEGATE METHODS

/* Sent periodically to notify the delegate of download progress. */

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    
    if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown) {
        
        NSLog(@"size of download file is unnown");
        
    }else{
        
        int index = [self getFileDownloadInfoIndexWithTaskIdentifier:downloadTask.taskIdentifier];
        
        WAFileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:index];
        NSIndexPath *indexPath= [NSIndexPath indexPathForRow:index inSection:0];
       
        if (indexPath != nil) {
            
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                fdi.downloadProgress = (double)totalBytesWritten/(double)totalBytesExpectedToWrite;
                WACustomCell *cell = (WACustomCell *)[self.tblFiles cellForRowAtIndexPath:indexPath];
                cell.progressBar.progress = fdi.downloadProgress;
                cell.progressLbl.text = [NSString stringWithFormat:@"%f",fdi.downloadProgress];
            }];
        }
    }
    
}

/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    NSString *fileName = downloadTask.originalRequest.URL.lastPathComponent;
    NSURL *destinationURL = [NSURL URLWithString:fileName];
    NSError *error;
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:[destinationURL path]]) {
        [fileMgr removeItemAtPath:[destinationURL path] error:&error];
    }
    
    BOOL success = [fileMgr copyItemAtURL:location toURL:destinationURL error:&error];
//    BOOL success = [fileMgr setUbiquitous:YES itemAtURL:location destinationURL:destinationURL error:&error];

    if (success) {
        // Change the flag values of the respective FileDownloadInfo object.
        
        int index = [self getFileDownloadInfoIndexWithTaskIdentifier:downloadTask.taskIdentifier];
        
        WAFileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:index];
        
        fdi.downloadComplete = YES;
        fdi.isDownloading = NO;
        
        fdi.taskIdentifier = -1;
        
        // In case there is any resume data stored in the fdi object, just make it nil.
        fdi.taskResumeData = nil;

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // Reload the respective table view row using the main thread.
            [self.tblFiles reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                                 withRowAnimation:UITableViewRowAnimationNone];
            
        }];

    }else {
        NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
  
    }
}
/* Sent as the last message related to a specific task.  Error may be
 * nil, which implies that no error occurred and this task is complete.
 */

//it is called even when a download task is cancelled
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error != nil) {
        NSLog(@"Download completed with error: %@", [error localizedDescription]);
    }
    else{
        NSLog(@"Download finished successfully.");
    }
}

/* If an application has received an
 * -application:handleEventsForBackgroundURLSession:completionHandler:
 * message, the session delegate will receive this message to indicate
 * that all messages previously enqueued for this session have been
 * delivered.  At this time it is safe to invoke the previously stored
 * completion handler, or to begin any internal updates that will
 * result in invoking the completion handler.
 */

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
   
    WAAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;

    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
       
        if ([downloadTasks count] == 0) {
        
            if (appDelegate.backgroundTransferCompletionHandler != nil) {
            
                // Copy locally the completion handler.
                void(^completionHandler)() = appDelegate.backgroundTransferCompletionHandler;
                
                // Make nil the backgroundTransferCompletionHandler.
                appDelegate.backgroundTransferCompletionHandler = nil;
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Call the completion handler to tell the system that there are no other background transfers.
                    completionHandler();
                    
                    // Show a local notification when all downloads are over.
                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                    localNotification.alertBody = @"All files have been downloaded!";
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                }];
            }
        }

    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

