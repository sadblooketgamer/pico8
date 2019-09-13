//
//  ZEPTO-8 — Fantasy console emulator
//
//  Copyright © 2016—2019 Sam Hocevar <sam@hocevar.net>
//
//  This program is free software. It comes without any warranty, to
//  the extent permitted by applicable law. You can redistribute it
//  and/or modify it under the terms of the Do What the Fuck You Want
//  to Public License, Version 2, as published by the WTFPL Task Force.
//  See http://www.wtfpl.net/ for more details.
//

#pragma once

#include <lol/engine.h>

#include <optional>

#include "zepto8.h"
#include "player.h"
#include "raccoon/memory.h"

namespace z8::raccoon
{

class vm : z8::vm_base
{
    friend class z8::player;

public:
    vm();
    virtual ~vm();

    virtual void load(char const *name);
    virtual void run();
    virtual bool step(float seconds);

    virtual void render(lol::u8vec4 *screen) const;

    virtual std::function<void(void *, int)> get_streamer(int channel);

    virtual void button(int index, int state);
    virtual void mouse(lol::ivec2 coords, int buttons);
    virtual void keyboard(char ch);

    virtual std::tuple<uint8_t *, size_t> ram();
    virtual std::tuple<uint8_t *, size_t> rom();

private:
    void js_wrap();

private:
    int api_read(int p);
    void api_write(int p, int x);
    void api_palset(int n, int r, int g, int b);
    int api_fget(int n, std::optional<int> f);
    void api_fset(int n, int f, std::optional<int> v);
    int api_mget(int x, int y);
    void api_mset(int x, int y, int n);
    int api_pget(int x, int y);
    void api_pset(int x, int y, int c);

    void api_palm(int c0, int c1);
    void api_palt(int c, int v);
    bool api_btn(int i, std::optional<int> p);
    bool api_btnp(int i, std::optional<int> p);
    void api_cls(std::optional<int> c);
    void api_cam(int x, int y);
    void api_map(int celx, int cely, int sx, int sy, int celw, int celh);
    void api_rect(int x, int y, int w, int h, int c);
    void api_rectfill(int x, int y, int w, int h, int c);
    void api_spr(int n, int x, int y,
                 std::optional<double> w, std::optional<double> h,
                 std::optional<int> fx, std::optional<int> fy);
    void api_print(int x, int y, std::string str, int c);
    double api_rnd(std::optional<double> x);
    double api_mid(double x, double y, double z);
    void api_mus(int n);
    void api_sfx(int a, int b, int c, int d);

private:
    struct JSRuntime *m_rt;
    struct JSContext *m_ctx;

    std::string m_code;
    std::string m_name, m_link, m_host;
    int m_version = -1;

    memory m_rom;
    memory m_ram;
};

}
