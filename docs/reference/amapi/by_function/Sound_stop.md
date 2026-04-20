---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: sound_stop
Namespace: Sound
Source URL: https://wiki.siminnovations.com/index.php?title=Sound_stop
Revision: 74
---

# Sound stop

## Signature

```
sound_stop(sound_id)
```

## Description

sound_stop is used to stop a previously loaded sound. The sound will be stopped immediately.

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

-- Play the sound
sound_play(mysound1)

-- And stop it right away
sound_stop(mysound1)
```
