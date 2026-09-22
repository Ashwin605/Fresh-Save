# FreshSave Customer App - Design System

## Visual Direction: Liquid Glass & Pastel Premium
The FreshSave Customer App must evoke a sense of sustainability, trust, calm, and premium quality.
We achieve this through a "Liquid Glass" visual identity mapped over soft pastel surfaces.

### STRICT RULES
- **NO Linear Gradients**: Rely on layered translucency, blurs, and shadows instead of harsh gradients.
- **NO Neon Colors**: Avoid over-saturated 'cyberpunk' palettes.
- **Glassmorphism in Moderation**: Use the `GlassSurface` widget for overlays, bottom sheets, and elevated cards, but preserve solid backgrounds for fundamental readability.

### 1. Colors (`app_colors.dart`)
- **Backgrounds**: Soft off-white and very pale mint/sage.
- **Primary**: A calm, sophisticated forest/sage green (e.g., `#2B5C4B`).
- **Surface**: White with varying opacities.
- **Text**: Dark slate (`#1A1A1A`) for high contrast.

### 2. Typography (`app_typography.dart`)
- We use a clean, geometric sans-serif (system default San Francisco/Roboto for now, to be swapped with something like Inter or Plus Jakarta Sans if needed).
- Hierarchy relies on weights (`w600` for headings, `w400` for body) rather than randomly scattered sizes.

### 3. Spacing (`app_spacing.dart`)
- A strict 4px/8px grid system (`xs: 4`, `sm: 8`, `md: 16`, `lg: 24`, `xl: 32`, `xxl: 48`).

### 4. Motion (`app_motion.dart`)
- **Micro (150ms)**: Used for button taps, scale effects.
- **Short (300ms)**: Used for card expansions, sheet sliding.
- **Medium (500ms)**: Used for page transitions.
- **Curve**: `Curves.easeOutCubic` for natural deceleration.

### 5. Components
- **`GlassSurface`**: A reusable widget utilizing `BackdropFilter` with `sigmaX: 10, sigmaY: 10` and a subtle 1px white border. Use this for app bars and floating cards.
