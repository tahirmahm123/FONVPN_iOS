//
//  PotatsoManager.m
//
//  Created by LEI on 4/4/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

#import "AppProfile.h"

@implementation AppProfile

+ (NSString *) sharedGroupIdentifier {
    // Try to avoid hardcoding Group IDs into the source code.
    // This is a fragile implementation that can be easily broken.
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *url = bundle.bundleURL;
    if ([url.pathExtension isEqualToString:@"appex"]) {
        // Peel off two directory levels - MY_APP.app/PlugIns/MY_APP_EXTENSION.appex
        url = [[url URLByDeletingLastPathComponent] URLByDeletingLastPathComponent];
        bundle = [NSBundle bundleWithURL:url];
    }
    return [@"group." stringByAppendingString:[bundle bundleIdentifier]];
}

+ (NSURL *)sharedUrl {
    NSString *groupID = [self sharedGroupIdentifier];
    return [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:groupID];
}

+ (NSURL *)sharedDatabaseUrl {
    return [[self sharedUrl] URLByAppendingPathComponent:@"potatso.realm"];
}

+ (NSUserDefaults *)sharedUserDefaults {
//    NSString *groupID = [self sharedGroupIdentifier];
    return [[NSUserDefaults alloc] init];//WithSuiteName:groupID];
}

+ (NSURL * _Nonnull)sharedGeneralConfUrl {
    return [[self sharedUrl] URLByAppendingPathComponent:@"general.xxx"];
}

+ (NSURL *)sharedSocksConfUrl {
    return [[self sharedUrl] URLByAppendingPathComponent:@"socks.xxx"];
}

+ (NSURL *)sharedProxyConfUrl {
    return [[self sharedUrl] URLByAppendingPathComponent:@"proxy.xxx"];
}

+ (NSURL *)sharedHttpProxyConfUrl {
    return [[self sharedUrl] URLByAppendingPathComponent:@"http.xxx"];
}

+ (NSURL * _Nonnull)sharedLogUrl {
    return [[self sharedUrl] URLByAppendingPathComponent:@"tunnel.log"];
}

@end
