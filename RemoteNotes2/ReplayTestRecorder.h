//
//  ReplayTestRecorder.h
//

#import <Foundation/Foundation.h>
#import <ReplayKit/ReplayKit.h>

// screen recorder wrapper class
@interface ReplayTestRecorder : NSObject<RPScreenRecorderDelegate,
										RPPreviewViewControllerDelegate,
										RPBroadcastActivityViewControllerDelegate,
										RPBroadcastControllerDelegate>

- (void) initializeWithCameraEnabled:(BOOL)bCameraEnabled microphoneEnabled:(BOOL)bMicrophonEnabled;

// local recording
- (void)startRecording;
- (void)stopRecording;
- (void)displayVideoPreview:( UIViewController* _Nullable )uiViewController;

//
// livestreaming functionality
//`
- (void)startBroadcast:( UIViewController* _Nullable )uiViewController;
- (void)pauseBroadcast;
- (void)resumeBroadcast;
- (void)stopBroadcast;

//
// delegates
//

// screen recorder delegate
- (void)screenRecorder:(RPScreenRecorder *_Nullable)screenRecorder didStopRecordingWithError:(NSError *_Nullable)error previewViewController:(nullable RPPreviewViewController *)previewViewController;
- (void)screenRecorderDidChangeAvailability:(RPScreenRecorder *_Nullable)screenRecorder;

// screen recorder preview view controller delegate
- (void)previewControllerDidFinish:(RPPreviewViewController *_Nullable)previewController;
- (void)previewController:(RPPreviewViewController *_Nullable)previewController didFinishWithActivityTypes:(NSSet <NSString *> *_Nullable)activityTypes __TVOS_PROHIBITED;

// broadcast activity view controller delegate
- (void)broadcastActivityViewController:(RPBroadcastActivityViewController *_Nullable)broadcastActivityViewController didFinishWithBroadcastController:(nullable RPBroadcastController *)broadcastController error:(nullable NSError *)error;

// broadcast controller delegate
- (void)broadcastController:(RPBroadcastController *_Nullable)broadcastController didFinishWithError:(NSError * __nullable)error;
- (void)broadcastController:(RPBroadcastController *_Nullable)broadcastController didUpdateServiceInfo:(NSDictionary <NSString *, NSObject <NSCoding> *> *_Nullable)serviceInfo;

@end
