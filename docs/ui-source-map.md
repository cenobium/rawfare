# UE UI source map

This document records UI-only findings from the user-provided `Rivals UE.txt` source attachment. It is an analysis reference, not a copy of the original script.

## Scope

Rebuild a standalone, reusable Roblox Luau interface library with the visual behavior shown in the user's reference screenshot. Keep gameplay automation, aim/trigger logic, weapon manipulation, exploit loading, and executor-specific functionality out of this project. The source is used only to understand generic UI construction and interaction patterns.

## Reference design contract

- Classic, dark, sharp-cornered executor-style interface.
- Wide, shallow rectangular composition; do not default to a tall Linoria-style window.
- Horizontal top-level tabs.
- Two content columns.
- Thin outlines and restrained blue accent.
- Compact square checkboxes, sliders, dropdowns, and group headings.
- Draggable window.
- Bottom-right resize grip.
- A separate accent outline/preview follows the window during drag and resize.
- Mobile touch support for movement and resizing.
- `Toggle UI` hides the complete interface and restores it when toggled again.
- Preserve position, size, and selected tab across hide/show.

The screenshot's dimensions are not yet a final implementation size. Earlier supplied dimensions (1032 × 275) and the later screenshot's apparent dimensions are different references; choose a final mobile target only after comparing against the actual on-device screenshot.

## Source map

Line numbers refer to the supplied `Rivals UE.txt` attachment.

| Source location | Symbol | UI-relevant behavior |
|---|---|---|
| 266 onward | `Native.library(captures)` | Core UI helper initialization and common methods. |
| 399 | `uiLibrary:MakeDraggable` | Dragging by a bounded top region; checks drag lock. |
| 427 | `uiLibrary:MakeDraggableOutline` | Creates a temporary transparent frame with accent `UIStroke`; updates its position during drag; commits the final position and destroys the preview. Has mouse and touch paths. |
| 526 | `uiLibrary:MakeDraggableUsingParent` | Uses a separate handle to move a target frame; branches on mobile mode. |
| 555 | `uiLibrary:MakeResizable` | Adds a bottom-right resize hit area; uses `uiLibrary.MinSize`; previews the new size with a temporary outline; commits size on release. Has separate mouse and touch handling. |
| 1414 | `Native.configuration(captures)` | Configuration-management module. |
| 1743 | `Native.themes(captures)` | Theme-management module. |
| 2379 | `Native.toggle(captures)` | Toggle component with value display, callbacks, changed listeners, visibility, and cleanup. |
| 2511 | `Native.slider(captures)` | Slider component. |
| 2716 | `Native.dropdown(captures)` | Dropdown component. |
| 3104 | `Native.colorPicker(captures)` | Color-picker component. |
| 3512 | `Native.tabBox(captures)` | Nested tab-box component. |
| 3694 | `Native.tab(captures)` | Tab behavior, tab switching, left/right groupboxes, and two-column content sizing. |

## Verified implementation details

### Drag outline

At line 427, `MakeDraggableOutline` creates a temporary frame in a separate ScreenGui. The frame matches the target's anchor point, size, and position, and receives a `UIStroke` using the current accent color. While dragging, the temporary frame follows the pointer. On release, its position is copied to the real frame, then the preview is destroyed. The touch branch tracks the initiating touch input and disconnects its completion listener.

### Resize preview

At line 555, `MakeResizable` creates a 25-pixel corner hit area and an ImageButton. It uses a minimum size supplied by `uiLibrary.MinSize` unless overridden. During resize, it creates a temporary outline and updates its dimensions while clamping to the minimum. On release, it applies the preview dimensions to the real frame and removes the preview. Desktop and mobile use different input events.

### Two-column tabs

At line 3694, `Native.tab` works with left and right scrolling containers. Their widths are each approximately half the available content width. It recalculates their positions and sizes when warning content is shown or hidden. Each scrolling canvas is updated when its UIListLayout content size changes. On mobile, scrolling temporarily disables dragging to avoid confusing a scroll gesture with a window drag.

### Components and managers

The source has separate modules for toggles, sliders, dropdowns, color pickers, tab boxes, configuration management, and themes. These are useful behavioral references for a new generic library; the new project should implement its own clean API rather than importing obfuscated source or game-specific callbacks.

## Build plan

1. Create a clean Roblox Studio-compatible Luau project structure.
2. Implement window geometry, drag, resize, preview outline, hide/show, and lock behavior.
3. Implement horizontal tabs and two-column scrolling group containers.
4. Add reusable controls one at a time: button, toggle, slider, dropdown, textbox, keybind, color picker, paragraph.
5. Add theme and configuration interfaces as independent modules.
6. Verify mouse and touch input, minimum dimensions, clipping, scrolling, and cleanup.
7. Compare the rendered result against the user's actual mobile screenshot before tuning final dimensions.

## Open questions

- Final mobile portrait and landscape dimensions.
- Whether portrait mode should preserve the wide ratio or switch to a stacked content arrangement.
- Whether the top navigation scrolls horizontally when all tabs do not fit.
- Exact title-bar height and exact outer-frame offset.
- Whether the blue outline is shown only during interaction or remains visible in a resting state (the source drag helper creates it during interaction).
