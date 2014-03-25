//
//  AppOsVersion.h
//  Investtech
//
//  Created by Creo MacMini on 09/05/13.
//
//

#import <Foundation/Foundation.h>


@interface AppOsVersion : NSObject{
    NSMutableArray *supportDetail;
}

//-(NSString *)getTheAppAndOsVersion;

-(NSMutableArray *)supportDetailArray;
@end
