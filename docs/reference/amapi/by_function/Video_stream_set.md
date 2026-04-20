---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: video_stream_set
Namespace: Video
Source URL: https://wiki.siminnovations.com/index.php?title=Video_stream_set
Revision: 4947
---

# Video stream set

## Signature

```
video_stream_id = video_stream_set(video_stream_id, key) video_stream_id = video_stream_set(video_stream_id, key, tex_x, tex_y, tex_width, tex_height)
```

## Description

video_stream_set is used to change the texture or texture size of a video stream.

## Return value

This function won't return any value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `key` | String | Reference to the video stream. This can be created using video_stream_add function. |
| 2 | `tex_x` | Number | (Optional) Left point of texture viewport. |
| 3 | `tex_y` | Number | (Optional) Top point of texture viewport. |
| 4 | `tex_width` | Number | (Optional) Width of texture viewport. |
| 5 | `tex_height` | Number | (Optional) Height of texture viewport. |

## Examples

### Example

```lua
-- Create a new video stream for the X-plane PFD
my_video_stream = video_stream_add("xpl/G1000_PFD_1", 0, 0, 1024, 768)

-- Lets change to the MFD instead
video_stream_set(my_video_stream, "xpl/G1000_MFD")
```
