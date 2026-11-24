# Native.library bootstrap captures

The bootstrap supplies a complete runtime table for the `Native.library(captures)` factory. Slots are mapped from the factory's actual operations. Some slots are safe adapter values rather than recovered VM object identities; they are marked below.

| Slot | Runtime value | Basis |
|---:|---|---|
| 0 | Base Library table | Factory extends this object |
| 1 | `Frame` class lookup wrapper | Used by `Library:Create` for frame construction |
| 2 | `BindableEvent` class lookup wrapper | Used by `CreateEvent` |
| 3 | LocalPlayer mouse | Read for pointer X/Y |
| 4 | `RunService.RenderStepped` | Waited during drag loops |
| 5 | Cleanup Folder | Destroyed during unload; adapter-owned |
| 6 | UserInputService | InputBegan and mouse-button state |
| 7 | Visibility state wrapper | Read by `IsVisible` and input dispatch |
| 8 | Player getter table | Factory stores its player-list callback here |
| 9 | Main ScreenGui | DescendantRemoving and unload target |
| 10 | `gethui()` or CoreGui | Parent for library-owned ScreenGuis |
| 11 | Team getter table | Factory stores its team-list callback here |
| 12 | Optional active-container wrapper | Tooltip visibility guard; nil until assigned |
| 13 | ContextActionService | Unbinds the Freeze action on unload |
| 14 | Empty metatable | Applied to popout objects |
| 15 | Dynamic OutlineColor wrapper | Used as a BorderColor3 value |
| 16 | Cleanup Folder | Destroyed during unload; adapter-owned |
| 17 | `warn` | Reports property assignment failures |
| 18 | TextService | TextService:GetTextSize |
| 19 | RunService | Heartbeat wait for tooltip tracking |
| 20 | Cleanup Folder | Destroyed during unload; adapter-owned |
| 21 | Teams | GetTeams |
| 22 | Players | GetPlayers |
| 23 | GUI protection adapter | Calls protect_gui/protectgui/syn.protect_gui when present |

The service mappings (6, 13, 18, 19, 21, 22) are directly supported by the factory body. Class wrappers and pointer/event adapters are supplied to satisfy the exact operations visible in that body. The three cleanup folders and empty metatable are lifecycle-safe adapter values; they are not claimed to be the original VM's captured instances.

## Factory adapters

`src/Bootstrap.lua` initializes the base Library, runs the original `Native.library` factory, then initializes the original theme and configuration managers.

`src/Window.lua` constructs the compact window and passes each tab's actual UI instances into `Native.tab`. The original factory provides tab selection, warning-box layout, mobile scroll/drag coordination, and the shared tab registry. Groupbox and control APIs are built on the library's original Create/CreateLabel/registry/theme methods.

The bootstrap deliberately does not claim to recover the original VM's object identities or compiled gameplay callbacks.
