//
// 12/25/2004
// This is the basic X10 grammar specification without support for generic types.
// Intended for the Feb 2005 X10 release.
////
// This is the grammar specification from the Final Draft of the generic spec.
// It has been modified by Philippe Charles and Vijay Saraswat for use with 
// X10. 
// (1) Removed TypeParameters from class/interface/method declarations
// (2) Removed TypeParameters from types.
// (3) Removed Annotations -- cause conflicts with @ used in places.
// (4) Removed EnumDeclarations.
// 12/28/2004
package x10.parser;

public interface X10Parsersym {
    public final static int
      TK_IntegerLiteral = 32,
      TK_LongLiteral = 33,
      TK_FloatingPointLiteral = 34,
      TK_DoubleLiteral = 35,
      TK_CharacterLiteral = 36,
      TK_StringLiteral = 37,
      TK_MINUS_MINUS = 27,
      TK_OR = 95,
      TK_MINUS = 51,
      TK_MINUS_EQUAL = 96,
      TK_NOT = 58,
      TK_NOT_EQUAL = 97,
      TK_REMAINDER = 89,
      TK_REMAINDER_EQUAL = 98,
      TK_AND = 99,
      TK_AND_AND = 100,
      TK_AND_EQUAL = 101,
      TK_LPAREN = 1,
      TK_RPAREN = 6,
      TK_MULTIPLY = 88,
      TK_MULTIPLY_EQUAL = 102,
      TK_COMMA = 53,
      TK_DOT = 49,
      TK_DIVIDE = 90,
      TK_DIVIDE_EQUAL = 103,
      TK_COLON = 54,
      TK_SEMICOLON = 24,
      TK_QUESTION = 112,
      TK_AT = 64,
      TK_LBRACKET = 4,
      TK_RBRACKET = 56,
      TK_XOR = 104,
      TK_XOR_EQUAL = 105,
      TK_LBRACE = 50,
      TK_OR_OR = 113,
      TK_OR_EQUAL = 106,
      TK_RBRACE = 63,
      TK_TWIDDLE = 59,
      TK_PLUS = 52,
      TK_PLUS_PLUS = 28,
      TK_PLUS_EQUAL = 107,
      TK_LESS = 82,
      TK_LEFT_SHIFT = 87,
      TK_LEFT_SHIFT_EQUAL = 108,
      TK_LESS_EQUAL = 91,
      TK_EQUAL = 81,
      TK_EQUAL_EQUAL = 109,
      TK_GREATER = 60,
      TK_ELLIPSIS = 114,
      TK_ARROW = 25,
      TK_abstract = 46,
      TK_assert = 66,
      TK_boolean = 7,
      TK_break = 67,
      TK_byte = 8,
      TK_case = 92,
      TK_catch = 118,
      TK_char = 9,
      TK_class = 55,
      TK_const = 83,
      TK_continue = 68,
      TK_default = 93,
      TK_do = 69,
      TK_double = 10,
      TK_enum = 128,
      TK_else = 110,
      TK_extends = 119,
      TK_false = 38,
      TK_final = 47,
      TK_finally = 120,
      TK_float = 11,
      TK_for = 70,
      TK_goto = 129,
      TK_if = 71,
      TK_implements = 123,
      TK_import = 121,
      TK_instanceof = 94,
      TK_int = 12,
      TK_interface = 57,
      TK_long = 13,
      TK_native = 115,
      TK_new = 29,
      TK_null = 39,
      TK_package = 124,
      TK_private = 43,
      TK_protected = 44,
      TK_public = 42,
      TK_return = 72,
      TK_short = 14,
      TK_static = 45,
      TK_strictfp = 48,
      TK_super = 30,
      TK_switch = 73,
      TK_synchronized = 61,
      TK_this = 31,
      TK_throw = 74,
      TK_throws = 122,
      TK_transient = 84,
      TK_true = 40,
      TK_try = 75,
      TK_void = 26,
      TK_volatile = 85,
      TK_while = 65,
      TK_activitylocal = 125,
      TK_async = 76,
      TK_ateach = 77,
      TK_atomic = 62,
      TK_await = 78,
      TK_boxed = 130,
      TK_clocked = 126,
      TK_current = 20,
      TK_extern = 116,
      TK_finish = 79,
      TK_foreach = 80,
      TK_fun = 131,
      TK_future = 23,
      TK_here = 41,
      TK_local = 21,
      TK_method = 22,
      TK_mutable = 86,
      TK_next = 15,
      TK_now = 16,
      TK_nullable = 17,
      TK_or = 5,
      TK_placelocal = 127,
      TK_reference = 3,
      TK_unsafe = 111,
      TK_value = 2,
      TK_when = 18,
      TK_EOF_TOKEN = 117,
      TK_IDENTIFIER = 19,
      TK_SlComment = 132,
      TK_MlComment = 133,
      TK_DocComment = 134,
      TK_GREATER_EQUAL = 135,
      TK_RIGHT_SHIFT = 136,
      TK_UNSIGNED_RIGHT_SHIFT = 137,
      TK_RIGHT_SHIFT_EQUAL = 138,
      TK_UNSIGNED_RIGHT_SHIFT_EQUAL = 139,
      TK_ERROR_TOKEN = 140;

      public final static String orderedTerminalSymbols[] = {
                 "",
                 "LPAREN",
                 "value",
                 "reference",
                 "LBRACKET",
                 "or",
                 "RPAREN",
                 "boolean",
                 "byte",
                 "char",
                 "double",
                 "float",
                 "int",
                 "long",
                 "short",
                 "next",
                 "now",
                 "nullable",
                 "when",
                 "IDENTIFIER",
                 "current",
                 "local",
                 "method",
                 "future",
                 "SEMICOLON",
                 "ARROW",
                 "void",
                 "MINUS_MINUS",
                 "PLUS_PLUS",
                 "new",
                 "super",
                 "this",
                 "IntegerLiteral",
                 "LongLiteral",
                 "FloatingPointLiteral",
                 "DoubleLiteral",
                 "CharacterLiteral",
                 "StringLiteral",
                 "false",
                 "null",
                 "true",
                 "here",
                 "public",
                 "private",
                 "protected",
                 "static",
                 "abstract",
                 "final",
                 "strictfp",
                 "DOT",
                 "LBRACE",
                 "MINUS",
                 "PLUS",
                 "COMMA",
                 "COLON",
                 "class",
                 "RBRACKET",
                 "interface",
                 "NOT",
                 "TWIDDLE",
                 "GREATER",
                 "synchronized",
                 "atomic",
                 "RBRACE",
                 "AT",
                 "while",
                 "assert",
                 "break",
                 "continue",
                 "do",
                 "for",
                 "if",
                 "return",
                 "switch",
                 "throw",
                 "try",
                 "async",
                 "ateach",
                 "await",
                 "finish",
                 "foreach",
                 "EQUAL",
                 "LESS",
                 "const",
                 "transient",
                 "volatile",
                 "mutable",
                 "LEFT_SHIFT",
                 "MULTIPLY",
                 "REMAINDER",
                 "DIVIDE",
                 "LESS_EQUAL",
                 "case",
                 "default",
                 "instanceof",
                 "OR",
                 "MINUS_EQUAL",
                 "NOT_EQUAL",
                 "REMAINDER_EQUAL",
                 "AND",
                 "AND_AND",
                 "AND_EQUAL",
                 "MULTIPLY_EQUAL",
                 "DIVIDE_EQUAL",
                 "XOR",
                 "XOR_EQUAL",
                 "OR_EQUAL",
                 "PLUS_EQUAL",
                 "LEFT_SHIFT_EQUAL",
                 "EQUAL_EQUAL",
                 "else",
                 "unsafe",
                 "QUESTION",
                 "OR_OR",
                 "ELLIPSIS",
                 "native",
                 "extern",
                 "EOF_TOKEN",
                 "catch",
                 "extends",
                 "finally",
                 "import",
                 "throws",
                 "implements",
                 "package",
                 "activitylocal",
                 "clocked",
                 "placelocal",
                 "enum",
                 "goto",
                 "boxed",
                 "fun",
                 "SlComment",
                 "MlComment",
                 "DocComment",
                 "GREATER_EQUAL",
                 "RIGHT_SHIFT",
                 "UNSIGNED_RIGHT_SHIFT",
                 "RIGHT_SHIFT_EQUAL",
                 "UNSIGNED_RIGHT_SHIFT_EQUAL",
                 "ERROR_TOKEN"
             };

    public final static boolean isValidForParser = true;
}
