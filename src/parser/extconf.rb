require 'mkmf'
$CXXFLAGS += " -Wno-deprecated-declarations"
$INCFLAGS += " -I #{File.expand_path('../../include', __dir__)}"
create_header
create_makefile 'parser'
