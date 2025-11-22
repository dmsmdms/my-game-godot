#include <godot_cpp/classes/resource_loader.hpp>
#include <godot_cpp/classes/viewport.hpp>
#include <godot_cpp/core/print_string.hpp>
#include "ui.hpp"

using namespace godot;

void UILayer::add_syminfo(Ref<PackedScene> &sym_info, Rect2 &area, SymIdx idx)
{
    Node *node = sym_info->instantiate();
    SymInfo *info = Object::cast_to<SymInfo>(node);
    info->set_sym_idx(static_cast<int>(idx));
    info->set_position(area.position);
    info->set_size(area.size);
    add_child(node);
}

void UILayer::_bind_methods(void)
{
}

void UILayer::_ready(void)
{
    ResourceLoader *rl = ResourceLoader::get_singleton();
    Ref<PackedScene> sym_info = rl->load("res://syminfo.tscn");
    Rect2 rect_root = get_viewport()->get_visible_rect();
    Rect2 rect;
    rect.size = Vector2(0.9 * rect_root.size.width, 0.5 * rect_root.size.height);
    rect.position = Vector2(0.5 * (rect_root.size.width - rect.size.width), 0);
    add_syminfo(sym_info, rect, SymIdx::BTC);
    rect.position.y += rect.size.height;
    add_syminfo(sym_info, rect, SymIdx::ETH);
}
