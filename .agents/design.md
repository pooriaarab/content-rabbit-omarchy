# Content Rabbit Omarchy design system

## Overview

The plugin has two surfaces: a compact `CR` bar button and a keyboard-accessible
capture panel. The panel switches between capture and saved-draft views.

The host owns the visual system. Use Omarchy `Style`, `Color`, and bar tokens.
Do not introduce a separate web design system in this repository.

## Colors

The plugin defines no fixed color palette.

- Use `root.barForeground` for text and one-pixel borders.
- Use `root.bar.background` when a host bar is available.
- Use `Color.background` only as the host fallback.
- Let host `Button` components render their own states.

Keep foreground and background values paired. Do not add fixed hex colors.

## Typography

Use the bar font family when available. Use `Style.font.family` as the host
fallback.

- Use `Style.font.subtitle` and bold weight for the panel title.
- Use `Style.font.body` for descriptions, draft text, and the composer.
- Use `Style.font.caption` and bold weight for “QUICK CAPTURE.”
- Use `Style.font.caption` for status notices.

Wrap descriptions and notices. Elide saved-draft previews on the right.

## Layout

Use `Style.space()` for dimensions, gaps, margins, and item heights. The panel
targets `Style.space(420)` before host fitting. Its active view is
`Style.space(230)` high.

Use an eight-unit host gap between major rows. Use a six-unit host gap between
buttons and draft cards. The composer is `Style.space(126)` high. Saved draft
cards are `Style.space(70)` high.

Keep panel width tied to the host's fitted content width. Do not add viewport
breakpoints that bypass Omarchy panel sizing.

## Elevation & Depth

The plugin defines no shadows, gradients, or elevation levels. It separates
content with background contrast and one-pixel foreground borders.

Let `KeyboardPanel`, `WidgetButton`, and `Button` provide host depth and states.

## Shapes

Use `Style.cornerRadius` for the active view container and saved-draft cards.
Use host button shapes without overrides.

Do not define a separate radius scale.

## Components

**Bar widget:** Show `CR`. Append the saved draft count when it is greater than
zero. Keep the tooltip count in sync.

**Keyboard panel:** Preserve close, focus, and adjacent-panel keyboard behavior.

**View selector:** Use host buttons for Capture, Saved, and Open app.

**Composer:** Use a wrapping `TextEdit`. Keep mouse selection and
`Ctrl+Enter` handoff behavior.

**Draft list:** Use a clipped `ListView`. Show one-line previews with Open and
Delete actions.

**Notice:** Show concise operation feedback below the active view.

## Do's and Don'ts

### Do

- Inherit host color, type, spacing, radius, and button rules.
- Keep capture and saved views within one panel.
- Preserve keyboard access and clear operation feedback.
- Reject empty drafts before saving or handoff.
- Keep local writes atomic through `FileView`.

### Don't

- Do not add fixed colors or custom fonts.
- Do not copy the Content Rabbit website styles.
- Do not add cloud storage or publishing behavior here.
- Do not hide destructive draft actions behind gestures.
- Do not treat the opened website as this repository's deployment.
