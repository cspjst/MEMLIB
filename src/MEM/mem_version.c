#include "mem_version.h"
#include "../include/DOS/dos_version.h"

#if DOS_VERSION < MEM_MIN_DOS_VERSION
#error vendored DOSLIB headers incorrect version
#pragma message("found DOSLIB " DOS_VERSION_STRING)
#endif

unsigned int mem_version() {
    return MEM_VERSION;
}

const char* mem_version_string() {
    return MEM_VERSION_STRING;
}
