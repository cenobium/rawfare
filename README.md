# UI Reborn Enhancement

A Roblox Luau interface rebuild using the supplied Rivals UE UI library as
the visual and component reference.

The target is the original compact horizontal rectangle, original typography,
themes, tabs, controls, and touch interactions. This repository is rebuilding
the UI layer only.

## Current implementation

- `src/Bootstrap.lua` creates the base library object, fills verified service
  captures, extends the library, creates its ScreenGui, and publishes the
  shared Library/Options/Toggles tables.
- `docs/capture-wiring.md` records verified capture mappings and unresolved
  slots. Unknown captures are required inputs; they are not guessed.

## Not finished yet

The bootstrap intentionally stops until the remaining VM capture values are
provided. Window/tab glue, control factories, configuration/theme wiring, and
the actual menu content still need to be implemented and verified in Delta.

## Source package

The extracted source package supplied for this rebuild contains:
- `Rivals_UE_UI_Library.lua`
- `Rivals_UE_UI_Library_inline.lua`
- `Rivals_UE_themes.json`
- `Rivals_UE_vm_strings.txt`
- `assets/`

Keep the clean and inline library variants synchronized when modifying the
extracted library. Do not modify the original obfuscated source or re-encode
readable strings.

## Design constraints

- Portrait phone usage, with the UI remaining a horizontal rectangle.
- Compact default height; resizing remains available.
- Toggle UI hides the entire interface and restores it when toggled again.
- Preserve the supplied UE fonts, theme values, and component styling.
- No invented capture mappings or unverified Delta compatibility claims.
