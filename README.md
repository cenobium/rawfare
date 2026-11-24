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
- `src/Tab.lua` and `src/Tabbox.lua` attach the original UE tab factories
  after validating every required capture slot.
- `docs/capture-wiring.md` and `docs/factory-captures.md` record verified
  service mappings, factory capture roles, and unresolved VM call-site values.

## Not finished yet

The bootstrap intentionally stops until the remaining VM capture values are
provided. The original tab and tabbox initializers now have strict adapters;
the VM's window-construction call site, control factories, configuration/theme
wiring, and actual menu content still need implementation and Delta testing.

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
