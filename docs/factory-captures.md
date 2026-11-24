# UE factory capture roles

These are observed roles from the extracted `Native.tab` and `Native.tabBox`
factory bodies. They are not guesses about the original VM's construction
expressions. The VM call-site still needs to provide the exact objects.

## Native.tab(captures)

| Slot | Observed role |
|---:|---|
| 0, 1 | Library object |
| 2 | Tab object receiving methods |
| 3 | Left scrolling content container |
| 4 | Wrapped warning-box visibility object |
| 5 | Right scrolling content container |
| 6 | Tab button instance |
| 7 | Parent/content holder for the tab's controls |
| 8, 12 | Registry object(s) exposing the shared `Tabs` table |
| 9 | Wrapped warning body text label |
| 10 | Key used in the shared tab registry |
| 11 | Wrapped warning title text label |
| 13 | Tab underline/selection indicator |
| 14 | Wrapped warning-box content container |
| 15 | Wrapped border color value |

The factory also uses the library object for `IsMobile`, `CanDrag`,
`GetTextBounds`, `Font`, `RegistryMap`, `MainColor`, `BackgroundColor`,
`FontColor`, `GetDarkerColor`, `IsDragging`, `TotalTabs`, and `ApplyLayout`.

## Native.tabBox(captures)

| Slot | Observed role |
|---:|---|
| 0 | Library object |
| 1 | Wrapped Instance factory |
| 2 | Tab button strip/container |
| 3 | Tabbox object receiving `Remove` and `AddTab` |
| 4 | Tabbox frame instance |
| 5 | Metatable applied to created tab panels |
| 6 | Tabbox name/key source |
| 7 | Parent for tab panel content |
| 8 | Library registry exposing `Tabboxes` |
| 9 | Wrapped border color value |

## Runtime adapters

- `src/Tab.lua` validates all 16 slots and runs the original `Native.tab`
  initializer without replacing its visuals or behavior.
- `src/Tabbox.lua` validates all 10 slots and runs the original
  `Native.tabBox` initializer.
- These adapters do not fabricate capture values. The original VM's exact
  capture construction remains the source of truth.
