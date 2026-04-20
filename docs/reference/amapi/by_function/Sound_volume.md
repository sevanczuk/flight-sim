---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: sound_volume
Namespace: Sound
Source URL: https://wiki.siminnovations.com/index.php?title=Sound_volume
Revision: 4356
---

# Sound volume

## Signature

```
sound_volume(sound_id, volume)
```

## Description

sound_volume is used to change the volume a previously loaded sound.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `sound_id` | ID | Sound id received from the sound_add function. |
| 2 | `volume` | Number | New volume, ranges from 0.0 (off) to 1.0 (loudest) |

## Examples

### Example

```lua
-- Load sounds
mysound1 = sound_add("mysound1.wav")

-- Play the sound
sound_play(mysound1)

-- Set volume to 50%
sound_volume(mysound1, 0.5)
```
