package sokol_gp

import "core:c"
import sg "../gfx"

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
            when DEBUG { foreign import sokol_gp_clib { "sokol_gp_windows_x64_gl_debug.lib" } }
            else       { foreign import sokol_gp_clib { "sokol_gp_windows_x64_gl_release.lib" } }
        } else {
            when DEBUG { foreign import sokol_gp_clib { "sokol_gp_windows_x64_d3d11_debug.lib" } }
            else       { foreign import sokol_gp_clib { "sokol_gp_windows_x64_d3d11_release.lib" } }
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
                when DEBUG { foreign import sokol_gp_clib { "sokol_gp_macos_arm64_gl_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
                else       { foreign import sokol_gp_clib { "sokol_gp_macos_arm64_gl_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
            } else {
                when DEBUG { foreign import sokol_gp_clib { "sokol_gp_macos_x64_gl_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
                else       { foreign import sokol_gp_clib { "sokol_gp_macos_x64_gl_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:OpenGL.framework" } }
            }
        } else {
            when ODIN_ARCH == .arm64 {
                when DEBUG { foreign import sokol_gp_clib { "sokol_gp_macos_arm64_metal_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
                else       { foreign import sokol_gp_clib { "sokol_gp_macos_arm64_metal_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
            } else {
                when DEBUG { foreign import sokol_gp_clib { "sokol_gp_macos_x64_metal_debug.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
                else       { foreign import sokol_gp_clib { "sokol_gp_macos_x64_metal_release.a", "system:Cocoa.framework","system:QuartzCore.framework","system:Metal.framework","system:MetalKit.framework" } }
            }
        }
    }
} else when ODIN_OS == .Linux {
    when DEBUG { foreign import sokol_gp_clib { "sokol_gp_linux_x64_gl_debug.a", "system:GL", "system:dl", "system:pthread" } }
    else       { foreign import sokol_gp_clib { "sokol_gp_linux_x64_gl_release.a", "system:GL", "system:dl", "system:pthread" } }
} else {
    #panic("This OS is currently not supported")
}

@(default_calling_convention="c", link_prefix="sgp_")
foreign sokol_gp_clib
{
    setup    :: proc( #by_ptr desc : Desc ) ---
    shutdown :: proc() ---
    is_valid :: proc() -> c.bool ---

    get_last_error    :: proc() -> Error ---
    get_error_message :: proc( error : Error ) -> cstring ---

    make_pipeline :: proc(#by_ptr desc : Pipeline_Desc ) ---

    begin :: proc( width, height : c.int ) ---
    flush :: proc() ---
    end   :: proc() ---

    project       :: proc(left, right, top, bottom : c.float) ---
    reset_project :: proc() ---

    push_transform  :: proc() ---
    pop_transform   :: proc() ---
    reset_transform :: proc() ---
    translate       :: proc(x, y : c.float) ---
    rotate          :: proc(theta : c.float) ---
    rotate_at       :: proc(theta, x, y : c.float) ---
    scale           :: proc(sx, sy : c.float) ---
    scale_at        :: proc(sx, sy, x, y : c.float) ---

    set_pipeline   :: proc(pipeline : sg.Pipeline) ---
    reset_pipeline :: proc() ---
    set_uniform    :: proc(data : [^]byte, size : c.uint32_t) ---
    reset_uniform  :: proc() ---

    set_blend_mode   :: proc( blend_mode : Blend_Mode ) ---
    reset_blend_mode :: proc() ---
    set_color        :: proc( r, g, b, a : c.float ) ---
    reset_color      :: proc() ---
    set_image        :: proc(channel : c.int, image : sg.Image) ---
    unset_image      :: proc(channel : c.int) ---
    reset_image      :: proc(channel : c.int) ---
    set_sampler      :: proc(channel : c.int, sampler : sg.Sampler) ---
    reset_sampler    :: proc(channel : c.int) ---

    viewport       :: proc(x, y, w, h : c.int) ---
    reset_viewport :: proc() ---
    scissor        :: proc(x, y, w, h : c.int) ---
    reset_scissor  :: proc() ---
    reset_state    :: proc() ---

    clear                       :: proc() ---
    draw                        :: proc(primitive_type : sg.Primitive_Type, vertices : Vertex, count : c.uint32_t) ---
    draw_points                 :: proc(points : [^]Point, count : c.uint32_t) ---
    draw_point                  :: proc(x, y : c.float) ---
    draw_lines                  :: proc(lines : [^]Line, count : c.uint32_t) ---
    draw_line                   :: proc(ax, ay, bx, by : c.float) ---
    draw_lines_strip            :: proc(points : [^]Point, count : c.uint32_t) ---
    draw_filled_triangles       :: proc(triangles : [^]Triangle, count : c.uint32_t) ---
    draw_filled_triangle        :: proc(ax, ay, bx, by, cx, cy : c.float) ---
    draw_filled_triangles_strip :: proc(points : [^]Point, count : c.uint32_t) ---
    draw_filled_rects           :: proc(rects : [^]Rect, count : c.uint32_t) ---
    draw_filled_rect            :: proc(x, y, w, h : c.float) ---
    draw_textured_rects         :: proc(channel : c.int, rects : [^]Textured_Rect, count : c.uint32_t) ---
    draw_textured_rect          :: proc(channel : c.int, dest_rect, src_rect : Rect) ---

    query_state :: proc() -> State ---
    query_desc  :: proc() -> Desc ---
}

BATCH_OPTIMIZER_DEPTH :: 8
UNIFORM_CONTENT_SLOTS :: 4
TEXTURE_SLOTS         :: 4

Blend_Mode :: enum i32 {
	NONE = 0, /* No blending.
				dstRGBA = srcRGBA */
	BLEND,    /* Alpha blending.
				dstRGB = (srcRGB * srcA) + (dstRGB * (1-srcA))
				dstA = srcA + (dstA * (1-srcA)) */
	ADD,      /* Color add.
				dstRGB = (srcRGB * srcA) + dstRGB
				dstA = dstA */
	MOD,      /* Color modulate.
				dstRGB = srcRGB * dstRGB
				dstA = dstA */
	MUL,      /* Color multiply.
				dstRGB = (srcRGB * dstRGB) + (dstRGB * (1-srcA))
				dstA = (srcA * dstA) + (dstA * (1-srcA)) */
	_NUM
}

Error :: enum i32 {
	NO_ERROR = 0,
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

VS_Attr_Location :: enum i32 {
	COORD = 0,
	COLOR = 1,
}

ISize :: struct { w, h : c.int }
IRect :: struct { x, y, w, h : c.int }
Rect  :: struct { x, y, w, h : c.float }

Textured_Rect :: struct { dst, src : Rect }

Vec2  :: [2]c.float
Point :: Vec2

Line     :: struct { a, b    : Point }
Triangle :: struct { a, b, c : Point }

Mat2x3 :: [2][3]c.float

Color     :: [4]c.float
Color_UB4 :: [4]c.uint8_t

Vertex :: struct {
    position : Vec2,
    texcoord : Vec2,
    color    : Color_UB4,
}

Uniform :: struct {
    size : c.uint32_t,
    content : [UNIFORM_CONTENT_SLOTS]c.float,
}

Textures_Uniform :: struct {
    count    : c.uint32_t,
    images   : [TEXTURE_SLOTS]sg.Image,
    samplers : [TEXTURE_SLOTS]sg.Sampler,
}

State :: struct {
    frame_size    : ISize,
    viewport      : IRect,
    scissor       : IRect,
    proj          : Mat2x3,
    transform     : Mat2x3,
    mvp           : Mat2x3,
    thickness     : c.float,
    color         : Color_UB4,
    textures      : Textures_Uniform,
    uniform       : Uniform,
    blend_mode    : Blend_Mode,
    pipeline      : sg.Pipeline,
    _base_vertex  : c.uint32_t,
    _base_uniform : c.uint32_t,
    _base_command : c.uint32_t,
}

Desc :: struct {
    max_vertices : c.uint32_t,
    max_commands : c.uint32_t,
    color_format : sg.Pixel_Format,
    depth_format : sg.Pixel_Format,
    sample_count : c.int,
}

Pipeline_Desc :: struct {
    shader         : sg.Shader,
    primitive_type : sg.Primitive_Type,
    blend_mode     : Blend_Mode,
    color_format   : sg.Pixel_Format,
    depth_format   : sg.Pixel_Format,
    sample_count   : c.int,
    has_vs_color : c.bool,
}
