---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: sound_loop
Namespace: Sound
Source URL: https://wiki.siminnovations.com/index.php?title=Sound_loop
Revision: 73
---

# Sound loop

## Signature

```
sound_loop(sound_id)
```

## Description

sound_loop is used to play a previously loaded sound. The sound will be played forever.

## Return value

This function won't return a value.

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `sound_id` | Number | Sound id received from the sound_add function. |

## Examples

### Example

```lua
-- Load sounds
mysound1 = sound_add("mysound1.wav")

-- Play the sound (this will be played forever...)
sound_loop(mysound1)

-- Except if you call the sound_stop function
sound_stop(mysound1)
```
