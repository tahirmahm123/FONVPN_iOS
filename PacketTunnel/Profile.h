// Generated by json_to_model

#import <Foundation/Foundation.h>

static const NSString *serverString = @"host"; //@"server";
static const NSString *serverPortString = @"port"; //@"server_port";
static const NSString *remarksString = @"remarks";
static const NSString *passwordString = @"password";
static const NSString *methodString = @"authscheme"; // @"method";
static const NSString *protocolString = @"protocol";
static const NSString *protocolParamString = @"protocol_param";
static const NSString *obfsString = @"obfs";
static const NSString *obfsParamString = @"obfs_param";
static const NSString *listenPortString = @"listen_port";
static const NSString *ot_enableString = @"ot_enable";
static const NSString *ot_domainString = @"ot_domain";
static const NSString *ot_pathString = @"ot_path";

@interface Profile : NSObject

- (id)initWithJSONData:(NSData *)data;
- (id)initWithJSONDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)JSONDictionary;
- (NSData *)JSONData;
- (NSMutableDictionary*) OverTlsJsonDictionary;
+ (NSData*) JsonDataFromDictionary:(NSDictionary*)dictionary;

@property (nonatomic, copy) NSString *server;
@property (nonatomic, assign) NSInteger serverPort;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *method;

@property(nonatomic, copy) NSString *protocol;
@property(nonatomic, copy) NSString *protocolParam;
@property(nonatomic, copy) NSString *obfs;
@property(nonatomic, copy) NSString *obfsParam;

@property (nonatomic, assign) NSInteger listenPort;

@property (nonatomic, assign) BOOL ot_enable;
@property(nonatomic, copy) NSString *ot_domain;
@property(nonatomic, copy) NSString *ot_path;

@property(nonatomic, assign, readonly) BOOL isOverTLS;

@end
