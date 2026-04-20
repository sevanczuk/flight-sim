---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: sound_add
Namespace: Sound
Source URL: https://wiki.siminnovations.com/index.php?title=Sound_add
Revision: 5152
---

# Sound add

## Signature

```
sound_id = sound_add(filename, volume)
```

## Description

sound_add is used to load a sound file. Only .wav files are accepted. The sound is also stored in memory for further references.

## Return value

sound_id

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `filename` | String | This is the filename of the sound you wich to load. Only .wav and .mp3 files are supported. |
| 2 | `volume` | Number | (Optional) Volume of the sound. Ranges from 0.0 (off) to 1.0 (loudest) |

## Examples

### Example

```lua
-- Load sounds
mysound1 = sound_add("mysound1.wav")

-- Play the sound
sound_play(mysound1)
```
