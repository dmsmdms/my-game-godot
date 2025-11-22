#include "syminfo.hpp"

using namespace godot;

void SymInfo::_bind_methods(void)
{
    ClassDB::bind_method(D_METHOD("set_sym_idx", "idx"), &SymInfo::set_sym_idx);
}

void SymInfo::set_sym_idx(int idx)
{
    sym_idx = static_cast<SymIdx>(idx);
}

void SymInfo::_ready(void)
{
    if(sym_idx >= SymIdx::MAX) {
        return;
    }

    icon = get_node<TextureRect>("icon");
    name = get_node<Label>("name");
}
