
/* Much of this is adapted from the great utf8lite library:
 * https://github.com/patperry/utf8lite
 */

#include "charwidth.h"
#include "cli.h"
#include "errors.h"

void utf8lite_decode_utf8(const uint8_t **bufptr, int32_t *codeptr) {
  const uint8_t *ptr = *bufptr;
  int32_t code;
  uint_fast8_t ch;
  unsigned nc;

  ch = *ptr++;
  if (!(ch & 0x80)) {
    code = ch;
    nc = 0;
  } else if (!(ch & 0x20)) {
    code = ch & 0x1F;
    nc = 1;
  } else if (!(ch & 0x10)) {
    code = ch & 0x0F;
    nc = 2;
  } else {
    code = ch & 0x07;
    nc = 3;
  }

  while (nc-- > 0) {
    ch = *ptr++;
    if (ch == 0) R_THROW_ERROR("Incomplete UTF-8 character");
    code = (code << 6) + (ch & 0x3F);
  }

  *bufptr = ptr;
  *codeptr = code;
}

void utf8lite_encode_utf8(int32_t code, uint8_t **bufptr) {
  uint8_t *ptr = *bufptr;
  int32_t x = code;

  if (x <= 0x7F) {
    *ptr++ = (uint8_t)x;
  } else if (x <= 0x07FF) {
    *ptr++ = (uint8_t)(0xC0 | (x >> 6));
    *ptr++ = (uint8_t)(0x80 | (x & 0x3F));
  } else if (x <= 0xFFFF) {
    *ptr++ = (uint8_t)(0xE0 | (x >> 12));
    *ptr++ = (uint8_t)(0x80 | ((x >> 6) & 0x3F));
    *ptr++ = (uint8_t)(0x80 | (x & 0x3F));
  } else {
    *ptr++ = (uint8_t)(0xF0 | (x >> 18));
    *ptr++ = (uint8_t)(0x80 | ((x >> 12) & 0x3F));
    *ptr++ = (uint8_t)(0x80 | ((x >> 6) & 0x3F));
    *ptr++ = (uint8_t)(0x80 | (x & 0x3F));
  }

  *bufptr = ptr;
}

static int display_width_map[7] = {
  /* CHARWIDTH_NONE =      */ 0,
  /* CHARWIDTH_IGNORABLE = */ 0,
  /* CHARWIDTH_MARK =      */ 0,
  /* CHARWIDTH_NARROW =    */ 1,
  /* CHARWIDTH_AMBIGUOUS = */ 1,
  /* CHARWIDTH_WIDE =      */ 2,
  /* CHARWIDTH_EMOJI =     */ 2
};

/* Display width of a single code point */

int clic__utf8_display_width_char(const uint8_t **x) {
  int32_t code;
  utf8lite_decode_utf8(x, &code);
  if (!UTF8LITE_IS_UNICODE(code)) {
    R_THROW_ERROR("Invalid UTF-8 string");
  }
  return display_width_map[charwidth(code)];
}

SEXP clic_utf8_display_width(SEXP x) {
  R_xlen_t i, len = XLENGTH(x);
  SEXP res = PROTECT(allocVector(INTSXP, len));
  int *pres = INTEGER(res);

  for (i = 0; i < len; i++) {
    SEXP x1 = STRING_ELT(x, i);
    if (x1 == NA_STRING) {
      pres[i] = NA_INTEGER;
    } else {
      const uint8_t *chr = (const uint8_t*) CHAR(x1);
      int32_t code;
      int len = 0;
      while (*chr) {
        utf8lite_decode_utf8(&chr, &code);
        if (!UTF8LITE_IS_UNICODE(code)) {
          R_THROW_ERROR("Invalid UTF-8 string in element %ld,", i + 1);
        }
        len += display_width_map[charwidth(code)];
      }
      pres[i] = len;
    }
  }

  UNPROTECT(1);
  return res;
}
