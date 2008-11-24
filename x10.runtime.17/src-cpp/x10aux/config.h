#ifndef X10AUX_CONFIG_H
#define X10AUX_CONFIG_H

/*
 * The following performance macros are supported:
 *   NO_EXCEPTIONS     - remove all exception-related code
 *   NO_BOUNDS_CHECKS  - remove all bounds-checking code
 *   NO_IOSTREAM       - remove all iostream-related code
 *
 * The following debugging macros are supported:
 *   TRACE_ALLOC       - trace allocation operations
 *   TRACE_CONSTR      - trace object construction
 *   TRACE_INIT        - trace x10 class initialization
 *   TRACE_REF         - trace reference operations
 *   TRACE_RTT         - trace runtimetype instantiation
 *   TRACE_CAST        - trace casts
 *   TRACE_PGAS        - trace X10lib invocations
 *   TRACE_SER         - trace serialization operations
 *   DEBUG             - general debug trace printouts
 *
 *   REF_STRIP_TYPE    - experimental option: erase the exact content type in references
 *   REF_COUNTING      - experimental option: enable reference counting
 */

#ifndef USE_ANSI_COLORS
#define ANSI_RESET ""
#define ANSI_BOLD ""
#define ANSI_NOBOLD ""
#define ANSI_UNDERLINE ""
#define ANSI_NOUNDERLINE ""
#define ANSI_REVERSE ""
#define ANSI_NOREVERSE ""
#define ANSI_BLACK ""
#define ANSI_RED ""
#define ANSI_GREEN ""
#define ANSI_YELLOW ""
#define ANSI_BLUE ""
#define ANSI_MAGENTA ""
#define ANSI_CYAN ""
#define ANSI_WHITE ""
#else
#define ANSI_RESET "\x1b[0m"
#define ANSI_BOLD "\x1b[1m"
#define ANSI_NOBOLD "\x1b[22m"
#define ANSI_UNDERLINE "\x1b[4m"
#define ANSI_NOUNDERLINE "\x1b[24m"
#define ANSI_REVERSE "\x1b[6m"
#define ANSI_NOREVERSE "\x1b[27m"
#define ANSI_BLACK "\x1b[30m"
#define ANSI_RED "\x1b[31m"
#define ANSI_GREEN "\x1b[32m"
#define ANSI_YELLOW "\x1b[33m"
#define ANSI_BLUE "\x1b[34m"
#define ANSI_MAGENTA "\x1b[35m"
#define ANSI_CYAN "\x1b[36m"
#define ANSI_WHITE "\x1b[37m"
#endif



#ifndef NO_IOSTREAM
#  include <iostream>
#endif
#include <stdint.h>

#include <x10/x10.h> //pgas

#define _DEBUG_MSG(col,type,msg) \
    std::cerr << ANSI_BOLD << x10_here() << ": " col << type << ": " ANSI_RESET << msg << std::endl;

#if !defined(NO_IOSTREAM) && defined(TRACE_ALLOC)
#define _M_(x) _DEBUG_MSG(ANSI_WHITE,"MM",x)
#else
#define _M_(x)
#endif

#if !defined(NO_IOSTREAM) && defined(TRACE_CAST)
#define _CAST_(x) _DEBUG_MSG(ANSI_RED,"CAST",x)
#else
#define _CAST_(x)
#endif

#if !defined(NO_IOSTREAM) && defined(TRACE_CONSTR)
#define _T_(x) _DEBUG_MSG(ANSI_WHITE,"CC",x)
#else
#define _T_(x)
#endif

#if !defined(NO_IOSTREAM) && defined(TRACE_INIT)
#define _I_(x) _DEBUG_MSG(ANSI_MAGENTA,"INIT",x)
#else
#define _I_(x)
#endif

#if !defined(NO_IOSTREAM) && defined(TRACE_REF)
#define _R_(x) _DEBUG_MSG(ANSI_YELLOW,"RR",x)
#else
#define _R_(x)
#endif

#if !defined(NO_IOSTREAM) && defined(TRACE_RTT)
#define _RTT_(x) _DEBUG_MSG(ANSI_GREEN,"RTT",x)
#else
#define _RTT_(x)
#endif

#if !defined(NO_IOSTREAM) && defined(TRACE_SER)
#define _S_(x) _DEBUG_MSG(ANSI_CYAN,"SS",x)
#define _Sd_(x) x
#else
#define _S_(x)
#define _Sd_(x)
#endif

#if !defined(NO_IOSTREAM) && defined(TRACE_PGAS)
#define _X_(x) _DEBUG_MSG(ANSI_BLUE,"XX",x)
#else
#define _X_(x)
#endif

#if !defined(NO_IOSTREAM) && defined(DEBUG)
#define _D_(x) std::cerr << x10_here() << ": " << x << std::endl
#else
#define _D_(x)
#endif

#ifdef IGNORE_EXCEPTIONS
#define NO_EXCEPTIONS
#endif



typedef bool     x10_boolean;
typedef int8_t   x10_byte;
typedef uint16_t x10_char;
typedef int16_t  x10_short;
typedef int32_t  x10_int;
typedef int64_t  x10_long;
typedef float    x10_float;
typedef double   x10_double;

typedef void   x10_void;

// We must use the same mangling rules as the compiler backend uses.
// The c++ target has to mangle fields because c++ does not allow fields
// and methods to have the same name.
#define FMGL(x) x10__##x

//needed if you want to concat from another macro
#define CONCAT(x,y) x##y

//if you want to turn a token into a string
#define TOKEN_STRING(X) #X

//if you want to do the above but the token is hidden behind a macro
#define TOKEN_STRING_DEREF(X) TOKEN_TO_STRING(X)

//combine __FILE__ and __LINE__ without using sprintf or other junk
#define __FILELINE__ __FILE__ ":" TOKEN_STRING_DEREF(__LINE__) 

#endif
// vim:tabstop=4:shiftwidth=4:expandtab
