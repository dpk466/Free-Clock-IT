//
//  AppOsVersion.m
//  Investtech
//
//  Created by Creo MacMini on 09/05/13.
//
//

#import "AppOsVersion.h"
#import "sys/sysctl.h"

@implementation AppOsVersion

///
///This method is being by DataInitialisationFromUrl
///
//-(NSString *)getTheAppAndOsVersion{
//    //get the os version
//    NSString *osVersion = [UIDevice currentDevice]. systemVersion;
//    //NSLog(@"os version = %@",osVersion);
//    
//    //get the App version
//   /* NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
//    NSLog(@"app version = %@",appVersionString);*/
//    
//    //get the current location city and country
//    NSLocale *locale = [NSLocale currentLocale];
//    
//    //NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
//    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
//    NSString *country = [locale displayNameForKey: NSLocaleCountryCode value: countryCode];
//    
//    country = [country stringByReplacingOccurrencesOfString:@" " withString:@""];
//    country = [country stringByReplacingOccurrencesOfString:@" " withString:@""];
//    country = [country stringByReplacingOccurrencesOfString:@" " withString:@""];
//    country = [country stringByReplacingOccurrencesOfString:@" " withString:@""];
//    country = [country stringByReplacingOccurrencesOfString:@" " withString:@""];
//    country = [country stringByReplacingOccurrencesOfString:@" " withString:@""];
//    country = [country stringByReplacingOccurrencesOfString:@" " withString:@""];
//   // NSLog(@"country = %@",country);
//    
//    NSString *deviceType = @" ";
//        size_t size;
//        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
//        char *machine = malloc(size);
//        sysctlbyname("hw.machine", machine, &size, NULL, 0);
//        NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
//        free(machine);
//    
//        deviceType = platform;
//      
//   // NSLog(@"devive type *** / %@",deviceType);
//    NSString *appOsDevice = [@"os=" stringByAppendingString:osVersion];
//    appOsDevice = [appOsDevice stringByAppendingString:@"&deviceCountry="];
//    appOsDevice = [appOsDevice stringByAppendingString:country];
//    appOsDevice = [appOsDevice stringByAppendingString:@"&deviceType="];
//    appOsDevice = [appOsDevice stringByAppendingString:deviceType];
//    
//    //NSLog(@"url string ***= %@",appOsDevice);
//    return appOsDevice;
//
//}

////This method is being used by support page
-(NSMutableArray *)supportDetailArray{
    
    //the os version
    NSString *osVersion = [UIDevice currentDevice]. systemVersion;
    
    //the app version
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    //getting the country name
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    NSString *country = [locale displayNameForKey: NSLocaleCountryCode value: countryCode];
    
    //getting the device type
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    
    supportDetail = [NSMutableArray arrayWithObjects:osVersion,appVersion,country,platform, nil];
    
    return supportDetail;
    

}

@end
