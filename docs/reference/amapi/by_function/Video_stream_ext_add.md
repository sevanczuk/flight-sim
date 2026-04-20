---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: video_stream_ext_add
Namespace: Video
Source URL: https://wiki.siminnovations.com/index.php?title=Video_stream_ext_add
Revision: 5908
---

# Video stream ext add

## Signature

```
video_stream_id = video_stream_ext_add(tag, key, x, y, width, height) video_stream_id = video_stream_ext_add(tag, key, x, y, width, height, tex_x, tex_y, tex_width, tex_height)
```

## Description

video_stream_add is used to add a custom video stream. This is only possible in the professional versions of Air Manager or Air Player.

## Return value

video_stream_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `tag` | String | Video stream source tag. This is the value configured in the AM/AP settings. |
| 2 | `key` | String | Video stream key, this key is used to determine which video stream you wish to show. |
| 3 | `x` | Number | Left point of the canvas where your video stream should be shown. |
| 4 | `y` | Number | Top point of the canvas where your video stream should be shown. |
| 5 | `width` | Number | The video stream width on the canvas. |
| 6 | `height` | Number | The video stream height on the canvas. |
| 7 | `tex_x` | Number | (Optional) Left point of texture viewport. |
| 8 | `tex_y` | Number | (Optional) Top point of texture viewport. |
| 9 | `tex_width` | Number | (Optional) Width of texture viewport. |
| 10 | `tex_height` | Number | (Optional) Height of texture viewport. |

## Examples

### Example (complete texture)

```lua
-- Create a new video stream
my_video_stream = video_stream_ext_add("MY_VIDEO_STREAM_SOURCE", "MY_TEXTURE", 0, 0, 1024, 768)
```

### Example (part of texture)

```lua
-- Create a new video stream for a small part of the texture
my_video_stream = video_stream_ext_add("MY_VIDEO_STREAM_SOURCE", "MY_TEXTURE", 0, 0, 1024, 768, 200, 200, 400, 400)
```
