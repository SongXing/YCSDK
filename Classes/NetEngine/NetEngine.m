//
//

#import "NetEngine.h"
#import "HelloHeader.h"


static NSInteger totolTryTimeMax = 3;
static NSInteger cndMoreTime = 0;
static NSInteger installMoreTime = 0;
static NSInteger niceMoreTime = 0;
static NSInteger huhaMoreTime = 0;
static NSInteger csReqMoreTime = 0;

@implementation NetEngine

#pragma mark - Class Method

+ (void)registerAccountWithUserName:(NSString *)username
                           password:(NSString *)password
                              email:(NSString *)email
                         completion:(void(^)())completion
{
    [YCLoginFunction doRegisterAccountWithUserName:username
                                       andPassword:password
                                          andEmail:email
                                          andPhone:nil
                                       andLoadCode:nil
                                     andDomainName:@""
                                        completion:completion];
}

+ (void)loginUsingUsername:(NSString *)userName
                  password:(NSString *_Nullable)password
                       uid:(NSString *_Nullable)uid
                   session:(NSString *_Nullable)sessionId
                completion:(void(^)())completion
{
    [YCLoginFunction doLoginWithAccount:userName
                            andPassword:password
                                    uid:uid
                                session:sessionId
                          andDomainName:@""
                             completion:completion];
}

+ (void)resetPasswordWithUserName:(NSString *)userName oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword completion:(void(^)())completion
{
    [YCLoginFunction doChangePasswordWithUserName:userName
                                  andOldPassword:oldPassword
                                  andNewPassword:newPassword
                                   andDomainName:@""
                                      completion:completion];
}

+ (void)guestLoginAndCompletion:(void (^)())completion
{
    [YCFreeLogin loginWithoutRegisterAndcompletion:completion];
}

#pragma mark - 手机相关
// 获取验证码
+ (void)sendVertifyCodeToMobile:(NSString *)mobileNum
                      situation:(NSString *)situation
                     completion:(void (^)())completion
{
    NSDictionary *dict = nil;
    dict = @{
             kReqStrMobile            : mobileNum,
             kReqStrSendtype          : situation,//固定字段
             };
    
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 202, 219, 194, 132, 216, 206, 197, 207, 198, 196, 201, 194, 199, 206, 200, 196, 207, 206, 0})),kPlatformDomain];
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   if (!error && !jsonParseErr)
                   {
                       //获取code参数
                       NSString * codeStr= [NSString stringWithFormat:@"%@",resultJsonDic[kRespStrResult]];
                       
                       if ( 0 == codeStr.intValue )// 成功
                       {
                           completion ? completion(resultJsonDic) : nil;
                       }
                       else {
                           [HelloUtils ycu_sToastWithMsg:[resultJsonDic[kRespStrData] objectForKey:kRespStrMsg]];
                           completion ? completion(nil) : nil;
                       }
                   }
                   else // 请求出错
                   {
                       completion ? completion(error) : nil;
                   }
                   
               }];
}

// 手机+验证码 登录
+ (void)loginUsingMobileNum:(NSString *)mobile
                vertifyCode:(NSString *)code
                 completion:(void (^)())completion
{
    NSDictionary *dict = nil;
    dict = @{
             kReqStrAccount            : mobile,
             kReqStrCode               : code,
             kReqStrAid               : [YCUser shareUser].aid ?:@"",
             kReqStrUdid              : [YCOpenUDID ycu_getYcUdidValue],
             kReqStrMac               : [SPFunction getMacaddress]?:@"",
             kReqStrAdid              : [SPFunction getIdfa],
             };
    
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 202, 219, 194, 132, 219, 195, 196, 197, 206, 231, 196, 204, 194, 197, 0})),kPlatformDomain];
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   if (!error && !jsonParseErr)
                   {
                       //获取code参数
                       NSString * codeStr= [NSString stringWithFormat:@"%@",resultJsonDic[kRespStrResult]];
                       
                       if ( 0 == codeStr.intValue )// 成功
                       {
                           completion ? completion(resultJsonDic) : nil;
                       }
                       else {
                           [NSClassFromString(@"HelloUtils") ycu_sToastWithMsg:[resultJsonDic[kRespStrData] objectForKey:kRespStrMsg]];
                           completion ? completion(nil) : nil;
                       }
                   }
                   else // 请求出错
                   {
                       completion ? completion(error) : nil;
                   }
                   
               }];
}

+ (void)resetPasswordWithAccount:(NSString *)name
                          mobile:(NSString *)mobile
                           code:(NSString *)code
                         newPwd:(NSString *)newPwd
                     completion:(void (^)())completion
{
    NSDictionary *dict = nil;
    dict = @{
             kReqStrAccount           : name,
             kReqStrMobile            : mobile,
             kReqStrCode              : code,
             kReqStrPassword          : newPwd,
             kReqStrUdid              : [YCOpenUDID ycu_getYcUdidValue],
             };
    
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 202, 219, 194, 132, 197, 206, 220, 217, 206, 216, 206, 223, 219, 202, 216, 216, 220, 207, 0})),kPlatformDomain];
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   if (!error && !jsonParseErr)
                   {
                       //获取code参数
                       NSString * codeStr= [NSString stringWithFormat:@"%@",resultJsonDic[kRespStrResult]];
                       
                       if ( 0 == codeStr.intValue )// 成功
                       {
                           completion ? completion(resultJsonDic) : nil;
                       }
                       else {
                           [NSClassFromString(@"HelloUtils") ycu_sToastWithMsg:[resultJsonDic[kRespStrData] objectForKey:kRespStrMsg]];
                           completion ? completion(nil) : nil;
                       }
                   }
                   else // 请求出错
                   {
                       completion ? completion(error) : nil;
                   }
                   
               }];
}

// 手机注册
+ (void)registerWithMobileNum:(NSString *)mobileNum
                  vertifyCode:(NSString *)vertifyCode
                     password:(NSString *)pwd
                   completion:(void (^)())completion
{    
    NSDictionary *dict = nil;
    dict = @{
             kReqStrMobile            : mobileNum,
             kReqStrPassword          : pwd,
             kReqStrCode              : vertifyCode,
             kReqStrSid               : @"",
             kReqStrAid               : [YCUser shareUser].aid ?:@"",
             kReqStrUdid              : [YCOpenUDID ycu_getYcUdidValue],
             kReqStrMac               : [SPFunction getMacaddress]?:@"",
             kReqStrAdid              : [SPFunction getIdfa],
             };
    
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 202, 219, 194, 132, 198, 196, 201, 194, 199, 206, 199, 196, 204, 194, 197, 0})),kPlatformDomain];
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   if (!error && !jsonParseErr)
                   {
                       //获取code参数
                       NSString * codeStr= [NSString stringWithFormat:@"%@",resultJsonDic[kRespStrResult]];
                       
                       if ( 0 == codeStr.intValue )// 成功
                       {
                           completion ? completion(resultJsonDic) : nil;
                       }
                       else {
                           [NSClassFromString(@"HelloUtils") ycu_sToastWithMsg:[resultJsonDic[kRespStrData] objectForKey:kRespStrMsg]];
                           completion ? completion(nil) : nil;
                       }
                   }
                   else // 请求出错
                   {
                       completion ? completion(error) : nil;
                   }
                   
               }];
}


//检查手机绑定状态
+ (void)checkMobileBindStatusWithNun:(NSString *_Nonnull)mobileNum
                          completion:(void(^)())completion
{
    NSDictionary *dict = nil;
    dict = @{
             kReqStrAccount            : mobileNum,
             };
    
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 202, 219, 194, 132, 204, 206, 223, 230, 196, 201, 194, 199, 206, 251, 195, 196, 197, 206, 0})),kPlatformDomain];
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   if (!error && !jsonParseErr)
                   {
                       //获取code参数
                       NSString * codeStr= [NSString stringWithFormat:@"%@",resultJsonDic[kRespStrResult]];
                       
                       if ( 0 == codeStr.intValue )// 成功
                       {
//                           NSLog(@"---result = %@", resultJsonDic);
                           [HelloUtils ycu_sToastWithMsg:[resultJsonDic[kRespStrData] objectForKey:kRespStrMsg]];
                           completion(resultJsonDic);
                           
                       }
                       else {
                           [HelloUtils ycu_sToastWithMsg:[resultJsonDic[kRespStrData] objectForKey:kRespStrMsg]];
                           completion(nil);
                       }
                   }
                   else // 请求出错
                   {
                       completion(error);
                   }
                   
               }];
}

//绑定手机
+ (void)allAccountBindMobilePhone:(NSString *)mobileNum
                         password:(NSString *)pwd
                          account:(NSString *)account
                      vertifyCode:(NSString *)vertifyCode
                       completion:(void (^)())completion

{
    NSDictionary *dict = nil;
    dict = @{
             kReqStrAccount           : account,
             kReqStrPassword          : pwd,
             kReqStrMobile            : mobileNum,
             kReqStrCode              : vertifyCode,
             };
    
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 202, 219, 194, 132, 197, 206, 220, 201, 194, 197, 207, 198, 196, 201, 194, 199, 206, 0})),kPlatformDomain];
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   if (!error && !jsonParseErr)
                   {
                       //获取code参数
                       NSString * codeStr= [NSString stringWithFormat:@"%@",resultJsonDic[kRespStrResult]];
                       
                       if ( 0 == codeStr.intValue )// 成功
                       {
                           completion(resultJsonDic);
                       }
                       else {
                           [HelloUtils ycu_sToastWithMsg:[resultJsonDic[kRespStrData] objectForKey:kRespStrMsg]];
                           completion(nil);
                       }
                   }
                   else // 请求出错
                   {
                       completion(error);
                   }
                   
               }];
}

#pragma mark-

+ (void)bindingGuestAccountWithUserName:(NSString *)username
                               password:(NSString *)password
                                  email:(NSString *)email
                             completion:(void(^)())completion
{
    [YCFreeLogin bindingFreeAccountWithUserName:username
                                    andPassword:password
                                       andEmail:email
                                     andLoginId:nil
                                  andThirdPlate:kReqStrMac
                                     completion:completion];
}


#pragma mark - 获取支付方式

+ (void)yce_mysuperJuniaCompletion:(void (^)())completion
{
    NSDictionary * dict = @{
                            kReqStrAid      :   [YCUser shareUser].aid?:@"",                // option
                            kReqStrUid      :   [YCUser shareUser].uid?:@"",                
                            };
    
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 202, 219, 194, 132, 204, 206, 223, 251, 202, 210, 255, 210, 219, 206, 0})),kPayDomain];
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   niceMoreTime++;
                   
                   //成功格式：{"result":0,"data":{"status":false,"uid":"27041656"}}
                   //失败格式：{"result":1,"data":{"errorcode":1100,"msg":"\u53c2\u6570\u9519\u8bef"}}
                   if (!error && !jsonParseErr) {
                       NSString *result = [NSString stringWithFormat:@"%@",resultJsonDic[kRespStrResult]];
                       if (0 == [result intValue]) {
//                           NSLog(@"---调起支付成功--- \n %@",resultJsonDic);
                           [YCDataUtils ycd_handlePPP:resultJsonDic[kRespStrData]];
                           completion ? completion(resultJsonDic[kRespStrData]):nil;
                       } else {
//                           NSLog(@"---调起支付失败--- \n resultDic = %@",resultJsonDic);
                           [HelloUtils ycu_sToastWithMsg:resultJsonDic[kRespStrData][kRespStrMsg]];
                       }
                       niceMoreTime = 0;
                   } else {
                       if (niceMoreTime <= totolTryTimeMax) {
                           // 再次请求
                           [NetEngine yce_mysuperJuniaCompletion:nil];
                       } else {
                           niceMoreTime = 0;
                           [HelloUtils ycu_sToastWithMsg:@"请求超时"];
                       }
                   }
                   
               }];
}


#pragma mark - 激活上报

+ (void)yce_reportInstalledCompletion:(void(^)())completion
{
    NSDictionary * dict = nil;
    @try {
        dict = @{

                 kReqStrMac             : [SPFunction getMacaddress] ? : @"",
                 kReqStrDevice          : [SPFunction getIdfa],
                 kReqStrModelType       : kReqValiOS,
                 kReqStrGameVersion     : [SPFunction getBundleVersion],
                 kReqStrDeviceModel     : [SPFunction getDeviceType],
                 kReqStrDeviceResolution    :   @"",
                 kReqStrDeviceVersion   :   [SPFunction getSystemVersion],
                 kReqStrDeviceNet       : @"",
                 
                 
                 kReqStrAdid     :   [SPFunction getIdfa],
                 kReqStrAid      :   [YCUser shareUser].aid ? : @"",
                 kReqStrIndex    :   [YCOpenUDID ycu_getYcUdidValue],
                 
                 };
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", [NSString stringWithFormat:@"!!!ERROR Dic At reportInstalled:\n %@ \n %@", dict, exception.description]);
    }
    
    
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 216, 207, 192, 199, 196, 204, 132, 202, 200, 223, 194, 221, 202, 223, 206, 244, 199, 196, 204, 0})),kDataDomain];
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   installMoreTime++;

                   if (!error && !jsonParseErr) {
                       NSString *result = [NSString stringWithFormat:@"%@",resultJsonDic[kRespStrResult]];
                       if (0 == [result intValue]) {
//                           NSLog(@"【activate_log】: %@",resultJsonDic);
                           // 标记
                           completion(resultJsonDic);
                       } else {
                           completion(nil);
                       }
                       
                       installMoreTime = 0;
                   } else {
                       if (installMoreTime <= totolTryTimeMax) {
                           // 再次请求
//                           NSLog(@"request more %ld",(long)installMoreTime);
                           [NetEngine yce_reportInstalledCompletion:completion];
                       } else {
                           installMoreTime = 0;
                           [HelloUtils ycu_sToastWithMsg:@"请求超时"];
                           completion(nil);
                       }
                   }
                   
               }];
}

#pragma mark - 登录日志上报

+ (void)yce_reportLogined
{
    NSDictionary * dict = nil;
    @try {
        dict = @{
                 kReqStrUid      : [YCUser shareUser].uid ?:@"",
                 kReqStrUserName : [YCUser shareUser].account ?:@"",
                 kReqStrSid      : [YCUser shareUser].serverId ?:@"",
                 kReqStrRoleId   : [YCUser shareUser].roleID ?:@"",
                 kReqStrRoleName : [YCUser shareUser].roleName ?:@"",
                 kReqStrLevel    : [YCUser shareUser].roleLevel ?:@"",
                 kReqStrGold     : @"",
                 kReqStrMac      : [SPFunction getMacaddress] ? : @"",
                 kReqStrDevice   : [SPFunction getIdfa],
                 kReqStrModelType       : kReqValiOS,
                 kReqStrGameVersion     : [SPFunction getBundleVersion],
                 kReqStrDeviceModel    : [SPFunction getDeviceType],
                 kReqStrDeviceResolution    :   @"",
                 kReqStrDeviceVersion  :   [SPFunction getSystemVersion],
                 kReqStrDeviceNet      : @"",
                 kReqStrOnlinetime  : @"",
                 
                 kReqStrAdid     :   [SPFunction getIdfa],
                 kReqStrAid      :   [YCUser shareUser].aid ? : @"",
                 kReqStrIndex    :   [YCOpenUDID ycu_getYcUdidValue],
                 
                 };
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", [NSString stringWithFormat:@"!!!ERROR Dic At yce_reportLogined:\n %@ \n %@", dict, exception.description]);
    }
    
    
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 216, 207, 192, 199, 196, 204, 132, 199, 196, 204, 194, 197, 244, 199, 196, 204, 0})),kDataDomain];
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   if (!error && !jsonParseErr) {
                       NSString *result = [NSString stringWithFormat:@"%@",resultJsonDic[kRespStrResult]];
                       if (0 == [result intValue]) {
//                           NSLog(@"---登录上报成功---");
                       } else {
//                           NSLog(@"---登录上报失败--- \n resultDic = %@",resultJsonDic);
                       }
                   }
                   
               }];
}

#pragma mark - 获取账号列表

+ (void)yce_getAccountList
{
    NSDictionary * dict = @{
                            kReqStrAdid     :   [SPFunction getIdfa],             // must
                            };    
    
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 202, 219, 194, 132, 204, 206, 223, 234, 199, 199, 254, 216, 206, 217, 0})),kPlatformDomain];
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   if (!error && !jsonParseErr) {
                       NSString *result = [NSString stringWithFormat:@"%@",resultJsonDic[kRespStrResult]];
                       if (0 == [result intValue]) {
//                           NSLog(@"---获取用户列表成功---\n %@",resultJsonDic);
                           
                           [YCDataUtils ycd_handleReqUserList:resultJsonDic];

                       } else {
//                           NSLog(@"---获取用户列表失败--- \n resultDic = %@",resultJsonDic);
                       }
                   }
                   
               }];
}

#pragma mark - 获取帮助信息

+ (void)yce_getCsData
{
    NSDictionary * dict = @{
                            kReqStrAdid     :   [SPFunction getIdfa],             // must
                            kReqStrAid      :   [YCUser shareUser].aid ? : @"",
                            };
    
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 202, 219, 194, 132, 204, 206, 223, 195, 206, 199, 219, 194, 197, 205, 196, 0})),kPlatformDomain];
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   csReqMoreTime++;
                   
                   if (!error && !jsonParseErr) {
                       NSString *result = [NSString stringWithFormat:@"%@",resultJsonDic[kRespStrResult]];
                       if (0 == [result intValue]) {
//                           NSLog(@"---获取帮助信息成功---\n %@",resultJsonDic);
                           [YCDataUtils ycd_handleCsData:resultJsonDic];                           
                       } else {
                           
                       }
                       csReqMoreTime = 0;
                   } else {
                       if (csReqMoreTime <= totolTryTimeMax) {
                           // 再次请求
                           NSLog(@"request more %ld",(long)csReqMoreTime);
                           [NetEngine yce_getCsData];
                       } else {
                           csReqMoreTime = 0;
                       }
                   }
                   
               }];
}


#pragma mark - 获取公告信息

+ (void)yce_getGoodNews
{
    NSDictionary * dict = @{
                            kReqStrAid      :   [YCUser shareUser].aid ? : @"",                // option
                            };
    
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 202, 219, 194, 132, 197, 196, 223, 194, 200, 206, 0})),kPlatformDomain];
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   huhaMoreTime++;
                   
                   if (!error && !jsonParseErr) {
                       NSString *result = [NSString stringWithFormat:@"%@",resultJsonDic[kRespStrResult]];
                       if (0 == [result intValue]) {
//                           NSLog(@"---获取游戏公告成功---\n %@",resultJsonDic);
                           
                           [YCDataUtils ycd_handleGoodNews:resultJsonDic[kRespStrData]];
                           
                       } else {
//                           NSLog(@"---获取游戏公告失败--- \n resultDic = %@",resultJsonDic);
                       }
                       huhaMoreTime = 0;
                   } else {
                       if (huhaMoreTime <= totolTryTimeMax) {
                           // 再次请求
                           NSLog(@"request more %ld",(long)huhaMoreTime);
                           [NetEngine yce_getGoodNews];
                       } else {
                           huhaMoreTime = 0;
                           [HelloUtils ycu_sToastWithMsg:@"请求超时"];
                       }
                   }
                   
               }];
}

#pragma mark - 获取第三方支付链接

+ (void)yce_getPPPOrderIdWithParams:(NSDictionary *)dict completion:(void (^)())completion
{
    NSDictionary * aDict = @{
                            kReqStrUid          :   [YCUser shareUser].uid,             // must
                            kReqStrSite         :   [YCUser shareUser].site,
                            kReqStrSdkVersion      :   [YCUser shareUser].sdkVersion,
                            kReqStrCporderId  :   [HelloUtils ycu_paraseObjToStr:dict[YC_PRM_PAY_CP_ORDER_ID]] ? : @"",
                            kReqStrAid          :   [YCUser shareUser].aid ?:@"",
                            kReqStrRoleId       :   [YCUser shareUser].roleID ? :@"",
                            kReqStrRoleName     :   [YCUser shareUser].roleName ? :@"",
                            kReqStrServerId     :   [YCUser shareUser].serverId ? :@"",
                            kReqStrMoney        :   [HelloUtils ycu_paraseObjToStr:dict[YC_PRM_PAY_PRODUCT_PRICE]] ? :@"",
                            kReqStrAdid         :   [SPFunction getIdfa],
                            kReqStrMac          :   [SPFunction getMacaddress],
                            kReqStrDeviceType  :   [SPFunction getDeviceType],
                            kReqStrProductId    :   [HelloUtils ycu_paraseObjToStr:dict[YC_PRM_PAY_PRODUCT_ID]],
                            kReqStrExt          :   [HelloUtils ycu_paraseObjToStr:dict[YC_PRM_PAY_EXTRA]] ? : @"",
                            };
    
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 202, 219, 194, 132, 204, 206, 223, 251, 202, 210, 228, 217, 207, 206, 217, 0})),kPayDomain];
    
    [SPRequestor requestByParams:aDict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   if (!error && !jsonParseErr) {
                       NSString *result = [NSString stringWithFormat:@"%@",resultJsonDic[kRespStrResult]];
                       if (0 == [result intValue]) {
//                           NSLog(@"---获取订单成功---\n %@",resultJsonDic);
                           completion(resultJsonDic);
                       } else {
//                           NSLog(@"---获取订单失败--- \n resultDic = %@",resultJsonDic);
                           [HelloUtils ycu_sToastWithMsg:[resultJsonDic[kRespStrData] objectForKey:kRespStrMsg]];
                           completion(nil);
                       }
                   } else {
                       completion(error);
                   }
                   
               }];
}

+ (void)yce_getPPPLinkWithParams:(NSDictionary *)dict
                     completion:(void(^)())completion
{
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 202, 219, 194, 132, 204, 206, 223, 251, 202, 210, 254, 217, 199, 0})),kPayDomain];
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   if (!error && !jsonParseErr) {
                       NSString *result = [NSString stringWithFormat:@"%@",resultJsonDic[kRespStrResult]];
                       if (0 == [result intValue]) {
//                           NSLog(@"---获取第三方支付链接成功---\n %@",resultJsonDic);
                           completion(resultJsonDic);
                       } else {
//                           NSLog(@"---获取第三方支付链接失败--- \n resultDic = %@",resultJsonDic);
                           [HelloUtils ycu_sToastWithMsg:[resultJsonDic[kRespStrData] objectForKey:kRespStrMsg]];
                           completion(nil);
                       }
                   } else {
                       completion(error);
                   }
                   
               }];
}


#pragma mark - IAP

+ (void)yce_gotoHell:(NSDictionary *)dict
{
    [YCIapFunction directToInAppPurchaseWithParams:dict];
}

#pragma mark - CDN

+ (void)yce_cdnFileGoodCompletion:(void (^)())completion
{
    NSString *mainDomain = strCdnInitUrl;
    
    [SPRequestor requestByParams:@{}
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:NO
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   cndMoreTime++;
                   
                   if (!error && resultJsonDic.count > 0) {
                       
                       if ([resultJsonDic[kRespStrUrladdress] count] > 0) {
                           [YCDataUtils ycd_handleCDNGoods:resultJsonDic[kRespStrUrladdress]];
                           completion ? completion(@"YES"):nil;

                       } else {
                           completion ? completion(@"NO"):nil;

                       };
                       cndMoreTime = 0;
                       
                   } else {
                       
                       if (cndMoreTime <= totolTryTimeMax) {
                           // 再次请求
                           NSLog(@"request more %ld",(long)cndMoreTime);
                           [NetEngine yce_cdnFileGoodCompletion:nil];
                       } else {
                           cndMoreTime = 0;
//                           [HelloUtils ycu_sToastWithMsg:@"请求超时"];
                           completion ? completion(@"NO"):nil;
                       }
                   }
                   
               }];
}

#pragma mark - 发货

+ (void)yce_postDataToValiteWithOrderID:(NSString * _Nonnull)orderID
                          currencyCode:(NSString * _Nonnull)currencyCode
                            localPrice:(NSString * _Nonnull)localPrice
                         transactionId:(NSString * _Nonnull)transactionId
                           receiptData:(NSData * _Nonnull)receiptData
                                userId:(NSString * _Nonnull)userId
                            serverCode:(NSString * _Nonnull)serverCode
                  andComplitionHandler:(IapAppstoreCallBack _Nullable)handler
{
    NSString *base64Str = [SPFunction encode:(uint8_t *)receiptData.bytes length:receiptData.length];
    
    NSDictionary *dic;
    @try
    {
        dic = @{
                kReqStrUid              : userId,
                kReqStrOrderId         : orderID,
                kReqStrTransactionId   : transactionId,
                kReqStrReceipt    : base64Str,
                };
    }
    @catch (NSException *exception)
    {
        SP_FUNCTION_LOG(exception.description);
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [HelloUtils ycu_sToastWithMsg:[NSString stringWithFormat:@"!!!ERROR Dic At postDataToValiteWithOrderID:\n %@ \n %@", dic, exception.description]];
                       });
    }
    
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 202, 219, 194, 132, 221, 206, 217, 194, 205, 210, 249, 206, 200, 206, 194, 219, 223, 0})),kPayDomain];
    NSArray * expectResponseDicKeysArray = nil;
    
    [SPRequestor requestByParams:dic
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:expectResponseDicKeysArray
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
//                   data =     {
//                       msg = "验证成功";
//                   };
//                   result = 0;
//                   NSLog(@"直接提交验证,接口返回 : %@ msg=%@" , resultJsonDic,resultJsonDic[kRespStrData][kRespStrMsg]);
                   
                   NSString *tmpResultCode = nil;
                   NSString *tmpOrderID = nil;
                   
                   if (!error && !jsonParseErr)
                   {
                       //获取code参数
                       NSString * codeStr= [NSString stringWithFormat:@"%@",resultJsonDic[kRespStrResult]];
                       
                       if ( 0 == codeStr.intValue )// 成功
                       {
//                           NSLog(@"-----验证成功，发货服务端处理-------");
                       } else {
//                           NSLog(@"-----验证失败，服务端处理-------");
                       }

//                       NSLog(@"---直接提交验证完了，发货成功或不成功服务器去处理就完了----");
//                       NSLog(@"验证结果：%@",resultJsonDic[kRespStrData][kRespStrMsg]);
                   }
                   
                   if (error) {
//                       NSLog(@"%@",error.description);
                   }
                   
                   if (handler) {
                       handler(response, tmpResultCode, tmpOrderID, resultJsonDic, error);
                       // test
//                       handler(response, tmpResultCode, tmpOrderID, nil, error);
                   }
               }];
}

+ (void)yce_postLostDataToValiteWithOrderID:(NSString * _Nonnull)orderID
                           currencyCode:(NSString * _Nonnull)currencyCode
                             localPrice:(NSString * _Nonnull)localPrice
                          transactionId:(NSString * _Nonnull)transactionId
                            receiptDataBase64Str:(NSString * _Nonnull)receiptDataBase64Str
                                 userId:(NSString * _Nonnull)userId
                             serverCode:(NSString * _Nonnull)serverCode
                   andComplitionHandler:(IapAppstoreCallBack _Nullable)handler
{
    
    NSDictionary *dic;
    @try
    {
        dic = @{
                kReqStrUid              : userId,
                kReqStrOrderId         : orderID,
                kReqStrTransactionId   : transactionId,
                kReqStrReceipt    : receiptDataBase64Str,
                };
    }
    @catch (NSException *exception)
    {
        SP_FUNCTION_LOG(exception.description);
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [HelloUtils ycu_sToastWithMsg:[NSString stringWithFormat:@"!!!ERROR Dic At postDataToValiteWithOrderID:\n %@ \n %@", dic, exception.description]];
                       });
    }
    
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 202, 219, 194, 132, 221, 206, 217, 194, 205, 210, 249, 206, 200, 206, 194, 219, 223, 0})),kPayDomain];
    NSArray * expectResponseDicKeysArray = nil;
    
    [SPRequestor requestByParams:dic
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:expectResponseDicKeysArray
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   //                   data =     {
                   //                       msg = "验证成功";
                   //                   };
                   //                   result = 0;
//                   NSLog(@"直接提交验证,接口返回 : %@ msg=%@" , resultJsonDic,resultJsonDic[kRespStrData][kRespStrMsg]);
                   
                   NSString *tmpResultCode = nil;
                   NSString *tmpOrderID = nil;
                   
                   if (!error && !jsonParseErr)
                   {
                       //获取code参数
                       NSString * codeStr= [NSString stringWithFormat:@"%@",resultJsonDic[kRespStrResult]];
                       
                       if ( 0 == codeStr.intValue )// 成功
                       {
//                           NSLog(@"-----验证成功，发货服务端处理-------");
                       } else {
//                           NSLog(@"-----验证失败，服务端处理-------");
                       }
                   }
                   
                   if (error) {
                       //                       NSLog(@"%@",error.description);
                   }
                   
                   if (handler) {
                       handler(response, tmpResultCode, tmpOrderID, resultJsonDic, error);
                   }
               }];
}

+ (void)yce_pppIsFeelBetterWithOrderId:(NSString *)orderId
                           completion:(void (^)())completion
{
    
    NSDictionary *dic = @{
                          kReqStrOrderId         : orderId,
                          kReqStrJson             : @"1", //通过该字段去获取最终的json对象，否则就是一个网页信息
                          };
    
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 202, 219, 194, 132, 218, 222, 206, 217, 210, 251, 202, 210, 249, 206, 216, 222, 199, 223, 0})),kPayDomain];
    
    
    [SPRequestor requestByParams:dic
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   if (!error && resultJsonDic.count > 0) {
                       completion ? completion(resultJsonDic) : nil;
                       
                   } else {                       
                       [HelloUtils ycu_sToastWithMsg:@"请求超时"];
                       completion ? completion(nil):nil;                       
                   }
               }];
}

@end

