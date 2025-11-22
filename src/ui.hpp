#pragma once

#include <godot_cpp/classes/canvas_layer.hpp>
#include <godot_cpp/classes/packed_scene.hpp>
#include "syminfo.hpp"

using namespace godot;

class UILayer : public CanvasLayer {
    GDCLASS(UILayer, CanvasLayer);

private:
    void add_syminfo(Ref<PackedScene> &sym_info, Rect2 &area, SymIdx idx);

protected:
    static void _bind_methods(void);

public:
    void _ready(void) override;
};
