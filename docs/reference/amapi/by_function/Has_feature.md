---
Created: 2026-04-20T00:00:00-04:00
Source: scripts/amapi_parser.py (parser-generated)
Canonical name: has_feature
Namespace: Has
Source URL: https://wiki.siminnovations.com/index.php?title=Has_feature
Revision: 5940
---

# Has feature

## Signature

```
feature_available = has_feature(name)
```

## Description

has_feature can be used to check if the current version of Air Manager or Air Player supports the asked feature.

## Return value

feature_available

## Arguments

| # | Argument | Type | Description |
|---|----------|------|-------------|
| 1 | `name` | String | The feature name. |

## Examples

### Example

```lua
if has_feature("TIMER") then
  timer_start(0, 100, function()
    print("timer callback")
  end)
end
```
