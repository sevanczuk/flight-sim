---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: scene_add
Namespace: Scene
Source URL: https://wiki.siminnovations.com/index.php?title=Scene_add
Revision: 5289
---

# Scene add

## Signature

```
scene_id = scene_add(x, y, width, height)
```

## Description

scene_add is used to create a scene that allows to draw 3D shapes like spheres, cubes etc.

## Return value

scene_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `x` | Number | This is the most left point of the scene. |
| 2 | `y` | Number | This is the most top point of the scene. |
| 3 | `width` | Number | The scene width in pixels. |
| 4 | `height` | Number | The scene height in pixels. |

## Examples

### Example

```lua
-- Create scene
scene_id = scene_add(0, 0, 512, 512)

-- Create camera node
camera_id = scene_camera_add(scene_id)
camera_node = scene_node_add(scene_id, camera_id)
scene_node_move(camera_node, 0, 0.5)

-- Create light node
light_node = scene_node_add(scene_id, scene_light_add(scene_id))

-- Create a mesh (this is the 3d object shape)
mesh_id = scene_mesh_add(scene_id, "sphere.obj")

-- Create material (this is the texture which will be drawn on top of the mesh)
material_id = scene_material_add(scene_id, "my_texture.png")

-- Attach the material to the mesh
scene_mesh_set_material(mesh_id, material_id)

-- Create a node from the generated mesh above
node_id = scene_node_add(scene_id, mesh_id)

-- This node can be translated, rotated, scaled etc.
scene_node_move(node_id, nil, nil, -180)
scene_node_scale(node_id, 40, 40, 40)
scene_node_rotate(node_id, nil, 270, nil)

-- Create viewport
viewport_id = scene_viewport_add(scene_id, camera_id)

-- Rotate constantly
timer_start(0, 1, function(count)
    scene_node_rotate(node_id, 1 / 10, 1 / 10, 1 / 10)
end)
```
