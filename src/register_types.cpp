#include <gdextension_interface.h>
#include "syminfo.hpp"
#include "ui.hpp"

using namespace godot;

static void init_module(ModuleInitializationLevel p_level)
{
    if(p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }
    GDREGISTER_RUNTIME_CLASS(SymInfo);
    GDREGISTER_RUNTIME_CLASS(UILayer);
}

extern "C" {
GDExtensionBool GDE_EXPORT init(GDExtensionInterfaceGetProcAddress get_proc_addr, const GDExtensionClassLibraryPtr lib,
                                GDExtensionInitialization *ext_init)
{
    GDExtensionBinding::InitObject obj(get_proc_addr, lib, ext_init);
    obj.register_initializer(init_module);
    obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);
    return obj.init();
}
}
