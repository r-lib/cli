
#include "cli.h"
#include "errors.h"
#include "cleancall.h"

#ifdef WIN32
extern Rboolean EmitEmbeddedUTF8;
#endif

SEXP clic_get_embedded_utf8() {
#ifdef WIN32
  return ScalarLogical(EmitEmbeddedUTF8);
#else
  error("get_embedded_utf8() only works on Windows");
  return R_NilValue;
#endif
}

SEXP clic_set_embedded_utf8(SEXP value) {
#ifdef WIN32
  Rboolean prev = EmitEmbeddedUTF8;
  EmitEmbeddedUTF8 = LOGICAL(value)[0];
  return ScalarLogical(prev);
#else
  error("set_embedded_utf8() only works on Windows");
  return R_NilValue;
#endif
}
