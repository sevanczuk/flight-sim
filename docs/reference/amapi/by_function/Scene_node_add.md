---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: scene_node_add
Namespace: Scene
Source URL: https://wiki.siminnovations.com/index.php?title=Scene_node_add
Revision: 5281
---

# Scene node add

## Signature

```
scene_node_id = scene_node_add(scene_id) scene_node_id = scene_node_add(scene_id, attach_object)
```

## Description

scene_node_add is used to create a scene node. A node can be freely translated, scaled, rotated within the 3d scene.

## Return value

material_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `scene_id` | ID | Scene id. Can be created by calling scene_add |
| 2 | `object_id` | camera_id, light_id, mesh_id | (Optional) Attach existing camera, light or mesh object to the node. |

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
