BGDownloadDemo
==============

Download file from Background using NSURLSession

NSURLSession is the new concept introduced in iOS 7 for downloading files in Background.

for this we have to do some set up in xcode and we need some delegate methods of NSURLSession

targets->capabilities->turn ON BackGround Modes

Thats it 

As all the task is happening in Bagckground ,we should notify user when all download is completed.

For that we have to add one  method in appdelegate

-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler

and by that completion handle we can throw an UILocalNOtification to the user .



