#include <TargetConditionals.h>
#if TARGET_OS_IOS && TARGET_OS_SIMULATOR && TARGET_CPU_X86_64
#include <openssl/opensslconf_ios_x86_64.h>
#elif TARGET_OS_IOS && TARGET_OS_SIMULATOR && TARGET_CPU_X86
#include <openssl/opensslconf_ios_i386.h>
#elif TARGET_OS_IOS && TARGET_OS_EMBEDDED && TARGET_CPU_ARM64
#include <openssl/opensslconf_ios_arm64.h>
#elif TARGET_OS_IOS && TARGET_OS_EMBEDDED && TARGET_CPU_ARM64E
#include <openssl/opensslconf_ios_arm64e.h>
#elif TARGET_OS_IOS && TARGET_OS_EMBEDDED && TARGET_CPU_ARM && !defined(__ARM_ARCH_7S__)
#include <openssl/opensslconf_ios_armv7.h>
#elif TARGET_OS_IOS && TARGET_OS_EMBEDDED && TARGET_CPU_ARM && defined(__ARM_ARCH_7S__)
#include <openssl/opensslconf_ios_armv7s.h>
#else
  #error target not included in OpenSSL build
#endif
