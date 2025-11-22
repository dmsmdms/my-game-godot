#pragma once

#include <godot_cpp/classes/control.hpp>
#include <godot_cpp/classes/texture_rect.hpp>
#include <godot_cpp/classes/label.hpp>

using namespace godot;

enum class SymIdx {
    BTC,
    ETH,
    MAX,
};

class SymInfo : public Control {
    GDCLASS(SymInfo, Control)

private:
    TextureRect *icon = nullptr;
    Label *name = nullptr;
    SymIdx sym_idx = SymIdx::MAX;

    void kline_req_done(int result, int response_code, PackedStringArray headers, PackedByteArray body);

protected:
    static void _bind_methods(void);

public:
    void set_sym_idx(int idx);
    void _ready(void) override;
};
