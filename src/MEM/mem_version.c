#include "mem_version.h"
#include "../include/DOS/dos_version.h"

//DOS_VERSION

unsigned int mem_version() {
    return MEM_VERSION;
}

const char* mem_version_string() {
    return MEM_VERSION_STRING;
}
