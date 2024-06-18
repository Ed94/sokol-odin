package sokol_gp

import "core:c"

SOKOL_DEBUG :: #config(SOKOL_DEBUG, ODIN_DEBUG)

DEBUG :: #config(SOKOL_GFX_DEBUG, SOKOL_DEBUG)
USE_GL :: #config(SOKOL_USE_GL, false)
USE_DLL :: #config(SOKOL_DLL, true)

when ODIN_OS == .Windows {
    when USE_DLL {
        when USE_GL {
            when DEBUG { foreign import sokol_gp_clib { "../sokol_dll_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_gp_clib { "../sokol_dll_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_gp_clib { "../sokol_dll_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_gp_clib { "../sokol_dll_windows_x64_d3d11_release.lib" } }
        }
    } else {
        when USE_GL {
            when DEBUG { foreign import sokol_gp_clib { "sokol_gfx_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_gp_clib { "sokol_gfx_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_gp_clib { "sokol_gfx_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_gp_clib { "sokol_gfx_windows_x64_d3d11_release.lib" } }
        }
    }
} else when ODIN_OS == .Darwin {
    when USE_DLL {
             when  USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_gp_clib { "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_gp_clib { "../dylib/sokol_dylib_macos_arm64_gl_release.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_gp_clib { "../dylib/sokol_dylib_macos_x64_gl_debug.dylib" } }
        else when  USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_gp_clib { "../dylib/sokol_dylib_macos_x64_gl_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 &&  DEBUG { foreign import sokol_gp_clib { "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .arm64 && !DEBUG { foreign import sokol_gp_clib { "../dylib/sokol_dylib_macos_arm64_metal_release.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 &&  DEBUG { foreign import sokol_gp_clib { "../dylib/sokol_dylib_macos_x64_metal_debug.dylib" } }
        else when !USE_GL && ODIN_ARCH == .amd64 && !DEBUG { foreign import sokol_gp_clib { "../dylib/sokol_dylib_macos_x64_metal_release.dylib" } }
    } else {
        when USE_GL {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_gp_clib { "sokol_gfx_macos_arm64_gl_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
                else       { foreign import sokol_gp_clib { "sokol_gfx_macos_arm64_gl_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
            } else {
                when DEBUG { foreign import sokol_gp_clib { "sokol_gfx_macos_x64_gl_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
                else       { foreign import sokol_gp_clib { "sokol_gfx_macos_x64_gl_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
            }
        } else {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_gp_clib { "sokol_gfx_macos_arm64_metal_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
                else       { foreign import sokol_gp_clib { "sokol_gfx_macos_arm64_metal_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
            } else {
                when DEBUG { foreign import sokol_gp_clib { "sokol_gfx_macos_x64_metal_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
                else       { foreign import sokol_gp_clib { "sokol_gfx_macos_x64_metal_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
            }
        }
    }
} else when ODIN_OS == .Linux {
    when DEBUG { foreign import sokol_gp_clib { "sokol_gfx_linux_x64_gl_debug.a", "system:GL", "system:dl", "system:pthread" } }
    else       { foreign import sokol_gp_clib { "sokol_gfx_linux_x64_gl_release.a", "system:GL", "system:dl", "system:pthread" } }
} else {
    #panic("This OS is currently not supported")
}

@(default_calling_convention="c", link_prefix="sgp_")
foreign sokol_gp_clib {

}

Blend_Mode :: enum i32 {
	BLENDMODE_NONE = 0, /*	No blending.
							dstRGBA = srcRGBA */
	BLENDMODE_BLEND,    /* Alpha blending.
							dstRGB = (srcRGB * srcA) + (dstRGB * (1-srcA))
							dstA = srcA + (dstA * (1-srcA)) */
	BLENDMODE_ADD,      /* Color add.
							dstRGB = (srcRGB * srcA) + dstRGB
							dstA = dstA */
	BLENDMODE_MOD,      /* Color modulate.
							dstRGB = srcRGB * dstRGB
							dstA = dstA */
	BLENDMODE_MUL,      /* Color multiply.
							dstRGB = (srcRGB * dstRGB) + (dstRGB * (1-srcA))
							dstA = (srcA * dstA) + (dstA * (1-srcA)) */
	_BLENDMODE_NUM
}

Error :: enum i32 {
	NO_ERROR,
	SOKOL_INVALID,
    VERTICES_FULL,
    UNIFORMS_FULL,
    COMMANDS_FULL,
    VERTICES_OVERFLOW,
    TRANSFORM_STACK_OVERFLOW,
    TRANSFORM_STACK_UNDERFLOW,
    STATE_STACK_OVERFLOW,
    STATE_STACK_UNDERFLOW,
    ALLOC_FAILED,
    MAKE_VERTEX_BUFFER_FAILED,
    MAKE_WHITE_IMAGE_FAILED,
    MAKE_NEAREST_SAMPLER_FAILED,
    MAKE_COMMON_SHADER_FAILED,
    MAKE_COMMON_PIPELINE_FAILED,
}


