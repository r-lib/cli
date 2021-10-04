
#include <string.h>

#define MD5_STATIC static
#include "md5.h"

#include "errors.h"

#include <Rinternals.h>

static void bin2str(char *to, const unsigned char *p, size_t len) {
  static const char *hex = "0123456789abcdef";
  for (; len--; p++) {
    *to++ = hex[p[0] >> 4];
    *to++ = hex[p[0] & 0x0f];
  }
  *to = '\0';
}

SEXP clic_md5(SEXP strs) {
  if (!Rf_isString(strs)) {
    R_THROW_ERROR("`strs` must be a character vector");
  }

  md5_byte_t hash[16];
  char hexhash[32];
  md5_state_t ctx;
  R_xlen_t i, len = XLENGTH(strs);
  SEXP result = PROTECT(Rf_allocVector(STRSXP, len));

  for (i = 0; i < len; i++) {
    const char *s = CHAR(STRING_ELT(strs, i));
    md5_init(&ctx);
    md5_append(&ctx, (const md5_byte_t*) s, strlen(s));
    md5_finish(&ctx, hash);
    bin2str(hexhash, hash, sizeof(hash));
    SET_STRING_ELT(
      result,
      i,
      Rf_mkCharLenCE((const char*) hexhash, sizeof(hexhash), CE_UTF8)
    );
  }

  UNPROTECT(1);
  return result;
}
