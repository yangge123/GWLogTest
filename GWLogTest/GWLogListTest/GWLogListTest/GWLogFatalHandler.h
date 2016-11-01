//
//  GWLogListManager.h
//  Holoera
//
//  Created by yangye on 16/10/29.
//  Copyright © 2016年 gowild. All rights reserved.
//

#import <Foundation/Foundation.h>
#

@interface GWLogFatalHandler : NSObject
{
    BOOL dismissed;
}

@end

void HandleException(NSException *exception);
void SignalHandler(int signal);
void InstallUncaughtExceptionHandler(void);
