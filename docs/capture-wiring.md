# UI Reborn Enhancement: capture wiring

This file records only mappings verified from the extracted source. Unknown slots
must be supplied explicitly; the bootstrap refuses to guess them.

## Native.library(captures)

| Slot | Verified meaning |
|---:|---|
| 0 | Library object extended by the factory |
| 6 | UserInputService |
| 13 | ContextActionService |
| 18 | TextService |
| 19 | RunService |
| 21 | Teams service |
| 22 | Players service |

Evidence in `Rivals_UE_UI_Library.lua`:
- Slot 6 is read through `InputBegan` and `IsMouseButtonPressed`.
- Slot 13 receives `UnbindAction('Freeze')`.
- Slot 18 calls `GetTextSize`.
- Slot 19 waits on `Heartbeat`.
- Slot 21 calls `GetTeams()`.
- Slot 22 calls `GetPlayers()`.

## Unresolved slots

The factory also reads slots 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 14, 15,
16, 17, 20, and 23. Their capture headers alone do not identify the underlying
runtime values. The bootstrap requires these values through its `bindings`
argument instead of silently assigning speculative services or instances.

Observed usage constraints:
- Slot 1 and slot 2 are lookup wrappers: the source indexes
  `captures[n][3][captures[n][2]]`.
- Slot 3 exposes X/Y coordinates.
- Slot 4 exposes `:Wait()`.
- Slot 7 is a wrapped boolean read by the library.
- Slot 9 is an Instance-like parent/container with `DescendantRemoving`
  and `:Destroy()`.
- Slot 10 is the parent assigned to the library ScreenGui.
- Slot 12 wraps an Instance with `Visible` and
  `GetPropertyChangedSignal('Visible')`.
- Slot 14 is passed to `setmetatable`.
- Slot 15 is a wrapped color used as `BorderColor3`.
- Slot 16, 20, and 5 are destroyed during unload.
- Slot 17 is called with a result value.
- Slot 23 is called with the constructed ScreenGui.

These are usage observations, not complete semantic mappings. Confirm the
original VM capture construction before assigning production values.

## Next implementation sequence

1. Recover the VM's capture construction for every unresolved slot.
2. Complete configuration, themes, dependencies, and value callback wiring.
3. Rebuild the exact window and tab glue from the extracted factories.
4. Wire controls and then reconstruct menu content from the VM string dump.

Do not treat the bootstrap as a finished UI until all captures are mapped and
the library is exercised in Delta on-device.
