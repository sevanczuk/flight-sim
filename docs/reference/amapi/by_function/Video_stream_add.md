---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: video_stream_add
Namespace: Video
Source URL: https://wiki.siminnovations.com/index.php?title=Video_stream_add
Revision: 5915
---

# Video stream add

## Signature

```
video_stream_id = video_stream_add(key, x, y, width, height) video_stream_id = video_stream_add(key, x, y, width, height, tex_x, tex_y, tex_width, tex_height)
```

## Description

video_stream_add is used to add a video stream to an instrument.

## Return value

video_stream_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `key` | String | Video stream key, this key is used to determine which video stream you wish to show. See list below for available video stream keys. |
| 2 | `x` | Number | Left point of the canvas where your video stream should be shown. |
| 3 | `y` | Number | Top point of the canvas where your video stream should be shown. |
| 4 | `width` | Number | The video stream width on the canvas. |
| 5 | `height` | Number | The video stream height on the canvas. |
| 6 | `tex_x` | Number | (Optional) Left point of texture viewport. |
| 7 | `tex_y` | Number | (Optional) Top point of texture viewport. |
| 8 | `tex_width` | Number | (Optional) Width of texture viewport. |
| 9 | `tex_height` | Number | (Optional) Height of texture viewport. |

## Examples

### Example (complete texture)

```lua
-- Create a new video stream for the X-plane PFD
my_video_stream = video_stream_add("xpl/G1000_PFD_1", 0, 0, 1024, 768)
```

### Example (part of texture)

```lua
-- Create a new video stream for a small part of the gauges texture
my_video_stream = video_stream_add("xpl/gauges[0]", 0, 0, 1024, 768, 200, 200, 400, 400)
```
