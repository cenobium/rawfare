# UE factory capture roles

These roles are read from the extracted `Native.tab` and `Native.tabBox`
factory bodies. The window builder creates the UI instances and supplies
them to the original factories.

## Native.tab(captures)

| Slot | Observed role |
|---:|---|
| 0, 1 | Library object |
| 2 | Tab object receiving methods |
| 3 | Left scrolling content container |
| 4 | Wrapper for warning-box frame and visibility |
| 5 | Right scrolling content container |
| 6 | Tab button instance |
| 7 | Tab button text object |
| 8 | Tab content page frame |
| 9 | Wrapper for warning body text label |
| 10 | Tab key/name |
| 11 | Wrapper for warning title text label |
| 12 | Library object exposing the shared `Tabs` table |
| 13 | Tab underline/selection indicator |
| 14 | Wrapper for warning-box content frame |
| 15 | UIStroke on the tab button |

The factory also uses the library object for `IsMobile`, `CanDrag`,
`GetTextBounds`, `Font`, `RegistryMap`, `MainColor`, `BackgroundColor`,
`FontColor`, `GetDarkerColor`, `IsDragging`, `TotalTabs`, and `ApplyLayout`.

## Native.tabBox(captures)

| Slot | Observed role |
|---:|---|
| 0 | Library object |
| 1 | Wrapper resolving the `Frame` class name |
| 2 | Tab button strip/container |
| 3 | Tabbox object receiving `Remove` and `AddTab` |
| 4 | Tabbox frame instance |
| 5 | Metatable applied to created tab panels |
| 6 | Instance carrying the tabbox name/key |
| 7 | Parent for tab panel content |
| 8 | Library registry exposing `Tabboxes` |
| 9 | Wrapper resolving the border color value |

## Runtime wiring

`src/Window.lua` constructs the real tab and tabbox instances, then passes
them into the original `Native.tab` and `Native.tabBox` factories. The
original factories handle tab selection, tabbox selection, resize behavior,
warning-box layout, and mobile scroll/drag coordination. Groupbox and
control APIs are layered into the resulting containers.
