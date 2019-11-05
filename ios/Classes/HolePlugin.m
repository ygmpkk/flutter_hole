#import "HolePlugin.h"
#import <XHPKit/XHPKit.h>

@interface HolePlugin ()
@property(readwrite, copy, nonatomic) FlutterResult callback;
// @property(nonatomic, retain) FlutterBasicMessageChannel *messageChannel;

@end

@implementation HolePlugin
FlutterEventSink eventSink;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    // Method channel
    FlutterMethodChannel *channel =
    [FlutterMethodChannel methodChannelWithName:@"com.ygmpkk/hole"
                                binaryMessenger:[registrar messenger]];
    // Event channel
    // *messageChannel = [FlutterBasicMessageChannel messageChannelWithName:@"com.ygmpkk/hole_message" binaryMessenger:[registrar messenger]];

    // [messageChannel sendMessage:@"Hello"];
    
    HolePlugin *instance = [[HolePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    [registrar addApplicationDelegate:instance];
}


- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
    
    if ([@"aOrder" isEqualToString:call.method]) {
        [self aOrder:call result:result];
    } else if ([@"isAlipInstalled" isEqualToString:call.method]) {
        [self _isAliPayInstalled:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)aOrder:(FlutterMethodCall *)call result:(FlutterResult)result {
    
    NSString *urlScheme = [self fetchUrlScheme];
    
    if (!urlScheme) {
        result([FlutterError errorWithCode:@"UrlScheme Not Found"
                                   message:@"Config First"
                                   details:nil]);
        return;
    }
    
    [[XHPKit defaultManager]
     alipOrder:call.arguments[@"order"]
     fromScheme:urlScheme
     completed:^(NSDictionary *resultDict) {
        result(resultDict);
    }];
}


- (void)_isAliPayInstalled:(FlutterMethodCall *)call
                    result:(FlutterResult)result {
    BOOL installed = [XHPKit isAliAppInstalled];
    
    result(@(installed));
}

- (NSString *)fetchUrlScheme {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSArray *types = infoDic[@"CFBundleURLTypes"];
    
    for (NSDictionary *dic in types) {
        if ([@"alipay" isEqualToString:dic[@"CFBundleURLName"]]) {
            return dic[@"CFBundleURLSchemes"][0];
        }
    }
    
    return nil;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
/** iOS9及以后 */
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:
(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [self handleOpenURL:url];
}
#endif

/** iOS9以下 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [self handleOpenURL:url];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    // holeExample://safepay/?%7B%22memo%22:%7B%22result%22:%22%22,%22ResultStatus%22:%226001%22,%22memo%22:%22%E7%94%A8%E6%88%B7%E4%B8%AD%E9%80%94%E5%8F%96%E6%B6%88%22%7D,%22requestType%22:%22safepay%22%7D
    BOOL ret = [[XHPKit defaultManager] handleOpenURL:url];
    // TODO via controller notifycation flutter
    // NSString *query = [url query];
    // [_messageChannel sendMessage:query];
    
    return ret;
}

@end
