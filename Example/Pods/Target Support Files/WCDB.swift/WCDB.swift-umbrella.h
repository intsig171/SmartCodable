#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SQLite-Bridging.h"
#import "WCDB-Bridging.h"

FOUNDATION_EXPORT double WCDBSwiftVersionNumber;
FOUNDATION_EXPORT const unsigned char WCDBSwiftVersionString[];

