//
//  main.c
//  heibaiyu
//
//  Created by jiwei.wang on 1/20/17.
//  Copyright © 2017 yijian. All rights reserved.
//

#include <stdio.h>

#ifdef DEBUG
static char _inMainFilePath[] = __FILE__;
static const char *_inIPAddresses[] = {"10.12.1.67", "127.0.0.1", 0};

#define INJECTION_ENABLED
#import "/tmp/injectionforxcode/BundleInjection.h"
#endif
