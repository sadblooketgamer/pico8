//
//  ZEPTO-8 — Fantasy console emulator
//
//  Copyright © 2016—2020 Sam Hocevar <sam@hocevar.net>
//
//  This program is free software. It comes without any warranty, to
//  the extent permitted by applicable law. You can redistribute it
//  and/or modify it under the terms of the Do What the Fuck You Want
//  to Public License, Version 2, as published by the WTFPL Task Force.
//  See http://www.wtfpl.net/ for more details.
//

#if HAVE_CONFIG_H
#   include "config.h"
#endif

#include <lol/engine.h>

#include "pico8/pico8.h"

namespace z8::pico8
{

// This is the list from Lua’s luaX_tokens
std::set<std::string> api::keywords =
{
    "and", "break", "do", "else", "elseif",
    "end", "false", "for", "function", "goto", "if",
    "in", "local", "nil", "not", "or", "repeat",
    "return", "then", "true", "until", "while",
};

std::set<std::string> api::functions =
{
    // Implemented in Lua (mostly baselib)
    "assert", "getmetatable", "next", "pairs", "rawequal",
    "rawlen", "rawget", "rawset", "setmetatable", "type",
    // Present in Lua but actually implemented by ZEPTO-8
    "load", "print",
    // Implemented in pico8lib (from z8lua)
    "max", "min", "mid", "ceil", "flr", "cos", "sin", "atan2", "sqrt",
    "abs", "sgn", "band", "bor", "bxor", "bnot", "shl", "shr", "lshr",
    "rotl", "rotr", "tostr", "tonum", "srand", "rnd", "ord", "chr",
    // Implemented in the ZEPTO-8 VM
    "run", "menuitem", "reload", "peek", "peek2", "peek4", "poke",
    "poke2", "poke4", "memcpy", "memset", "stat", "printh", "extcmd",
    "_update_buttons", "btn", "btnp", "cursor", "camera", "circ",
    "circfill", "clip", "cls", "color", "fillp", "fget", "fset", "line",
    "map", "mget", "mset", "pal", "palt", "pget", "pset", "rect",
    "rectfill", "sget", "sset", "spr", "sspr", "music", "sfx", "time",
    // Implemented in the ZEPTO-8 BIOS
    "cocreate", "coresume", "costatus", "yield", "trace", "stop",
    "count", "add", "sub", "foreach", "all", "del", "t", "dget",
    "dset", "cartdata", "load", "save", "info", "abort", "folder",
    "resume", "reboot", "dir", "ls", "flip", "mapdraw",
    // Not implemented but we should!
    "assert", "getmetatable", "setmetatable",
};

} // namespace z8::pico8

