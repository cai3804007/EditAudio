//
//  ParsingAudioHander.h
//  EditAudio
//
//  Created by yoyochecknow on 2021/5/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ParsingAudioHander : NSObject
- (NSArray<NSNumber *> *)getRecorderDataFromURL:(NSURL *)url;
- (void)synthetiAudioWithOutPath:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
