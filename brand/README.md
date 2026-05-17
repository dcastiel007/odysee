# Odysee Brand Assets

Canonical brand system v1.0 · May 2026

## Files

| File | Purpose |
|---|---|
| `odysee-tokens.css` | All design tokens (colors, type, spacing) as CSS custom properties. Source of truth. |
| `brand.css` | Layout + typography utilities. `@import`s `odysee-tokens.css`. |
| `odysee-mark-light.svg` | Primary mark — navy ring + dotted trail. For ivory/paper backgrounds. |
| `odysee-mark-dark.svg` | Inverted mark — white ring + navy trail. For Odysee Navy backgrounds. |
| `odysee-mark-mono.svg` | Single-color variant using `currentColor`. For foil, embossing, single-ink print. |
| `lockup-examples.html` | Reference HTML for the Wordmark and Stacked lockups. Copy-paste the markup into pages. |

## Usage

### As a single mark
```html
<img src="brand/odysee-mark-light.svg" alt="Odysee" width="64" height="64">
```

### Inline (themable, smaller payload)
Open the `.svg` file, copy the contents, and paste inline into your HTML. The mark inherits via `currentColor` if you use the mono variant.

### As a wordmark / stacked lockup
The wordmark and stacked variants are HTML+SVG composites (the mark serves as the "O" of Odysee, with "dysee" set in Sora 800 alongside). See `lockup-examples.html` for the canonical markup.

## Geometry

The mark is drawn in a `100 × 100` viewBox.

- **Ring:** `circle cx=50 cy=50 r=45.4 stroke-width=9.2`
- **Trail:** `path d="M 26 50 A 24 24 0 0 0 74 50"` — a half-circle smile arc, rendered with `stroke-dasharray="0.1 12"` to produce dotted markers along the path.
- **Start cap:** `circle cx=26 cy=50 r=3.6` — navy dot.
- **Destination:** `circle cx=74 cy=50 r=5.4` — terracotta dot.
- **Tilt:** entire trail group is rotated `-32°` around `(50, 50)`.

## Colors

| Token | Hex | Pantone |
|---|---|---|
| Odysee Navy | `#0C1F3F` | 282 C |
| Terracotta | `#B85A3E` | 7588 C / 185 C |
| Ivory | `#F6F4EF` | — |
| Paper | `#FFFFFF` | — |

## Do not

- Rotate, skew, or stretch the mark. The needle's angle is fixed at -32°.
- Recolour. Use only Odysee Navy and Terracotta.
- Place the navy mark directly on Terracotta — contrast is fine, but the terracotta destination dot disappears.
- Drop below 16 px for the standalone mark. Below 16 px, drop the trail dots and use only the navy roundel.
