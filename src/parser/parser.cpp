#include "extconf.h"
#include "ruby.h"
#include "stdio.h"

extern "C" {

VALUE parse(int argc, VALUE *argv, VALUE self) {
    if (argc < 1 || argc > 2) {
        VALUE SyntaxError = rb_const_get(rb_cObject, rb_intern("SyntaxError"));
        rb_raise(SyntaxError, "wrong number of arguments (given %d, expected 1..2)", argc);
    }
    VALUE ary = rb_ary_new();
    return ary;
}

void Init_parser() {
    VALUE Parser = rb_define_class("Parser", rb_cObject);
    rb_define_singleton_method(Parser, "parse", parse, -1);
}
}
