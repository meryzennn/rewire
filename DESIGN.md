# Design System: Rewire — Brain Rewiring App

## 1. Visual Theme & Atmosphere

Rewire embodies a **serene, nurturing calm** — the visual equivalent of a deep breath. The aesthetic is soft and muted, never loud or jarring. Think of morning light filtered through frosted glass. The design philosophy centers on creating a safe, non-judgmental space that encourages healing and growth. Whitespace is used generously, giving every element room to breathe. The overall density is low — airy and open, with rounded shapes that feel gentle and approachable. The app should feel like a quiet sanctuary, not a productivity tool.

## 2. Color Palette & Roles

### Light Mode

- **Warm Parchment** (#FAF8F5) — Primary background. A warm cream that feels like natural paper, softer than pure white.
- **Clean Canvas** (#FFFFFF) — Card and surface backgrounds. Provides subtle lift from the parchment base.
- **Weathered Linen** (#F0EDE8) — Surface variant for subtle section differentiation and inactive states.
- **Garden Sage** (#8FAE8B) — Primary brand color. Used for primary buttons, active states, streak counters, and positive actions. Evokes growth and natural healing.
- **Sage Whisper** (#D4E8D2) — Primary container. Light sage tint for card backgrounds related to recovery/streak features.
- **Dusty Lavender** (#A8A0C8) — Secondary color. Used for meditation-related elements, secondary actions, and mind/brain features. Evokes calm and introspection.
- **Lavender Mist** (#DDD8EE) — Secondary container. Light lavender tint for meditation-related card backgrounds.
- **Still Teal** (#6BA8A0) — Accent color. Used for workout/exercise elements and tertiary highlights. Evokes balance and vitality.
- **Charcoal Ink** (#2D2D2D) — Primary text. Deep but not pure black, easier on the eyes.
- **Warm Stone** (#7A7A7A) — Secondary text for descriptions, timestamps, and supporting content.
- **Meadow Green** (#7BC67E) — Success states. Clean day confirmations, completed quests, achievement unlocks.
- **Amber Glow** (#E8B86D) — Warning states. Gentle alerts and caution indicators.
- **Muted Coral** (#D4836D) — Danger/relapse indicator. Warm, not aggressive — acknowledges difficulty without shame.
- **Faded Parchment Edge** (#E8E4DF) — Dividers and borders. Barely visible separation lines.

### Dark Mode

- **Deep Midnight Slate** (#1A1A2E) — Primary background. A deep blue-black, warmer than pure dark.
- **Twilight Navy** (#22223B) — Card and surface backgrounds. Subtle lift from the midnight base.
- **Dusk Indigo** (#2A2A45) — Surface variant for sections and inactive states.
- **Moonlit Sage** (#9EC49A) — Primary in dark mode. Slightly brighter sage to maintain readability.
- **Forest Shadow** (#3A5038) — Primary container in dark mode.
- **Pale Wisteria** (#B8B0D8) — Secondary in dark mode. Brighter lavender for contrast.
- **Amethyst Shadow** (#4A4468) — Secondary container in dark mode.
- **Aqua Glow** (#7DBDB5) — Accent in dark mode.
- **Ivory Mist** (#E8E8E8) — Primary text in dark mode.
- **Silver Ash** (#9A9A9A) — Secondary text in dark mode.
- **Twilight Border** (#3A3A55) — Dividers in dark mode.

## 3. Typography Rules

**Font Family:** Nunito — a rounded, friendly sans-serif that feels warm and approachable without being childish. Fallback to Inter for a slightly more structured feel.

- **Display Large** (32sp, Bold) — Reserved for the brain evolution stage name on home screen. Commanding but soft.
- **Headline** (24sp, SemiBold) — Section headers. Clear hierarchy without shouting.
- **Title Large** (20sp, SemiBold) — Card titles, streak number, exercise names. Prominent but contained.
- **Title Medium** (18sp, SemiBold) — Sub-section headers, question prompts.
- **Body Large** (16sp, Regular) — Primary reading text. Comfortable reading size.
- **Body Medium** (14sp, Regular) — Secondary descriptions, supporting text.
- **Body Small** (12sp, Regular) — Timestamps, captions, small metadata.
- **Label Large** (14sp, SemiBold) — Button text, interactive labels.
- **Label Medium** (12sp, SemiBold) — Badge labels, chips, tags.

Letter-spacing is natural, not condensed or expanded. Line height is generous (1.5× for body text) to maintain the airy, breathable feel.

## 4. Component Stylings

### Buttons
- **Primary Button:** Pill-shaped with generously rounded corners (12dp radius). Garden Sage (#8FAE8B) background with white text. Full-width on action screens. Gentle scale animation on press. No harsh shadows — uses subtle color darkening on press state.
- **Secondary/Outlined Button:** Same pill shape, transparent background with 1.5dp Garden Sage border and sage text. Used for secondary actions like "Skip" or "Cancel."
- **Text Button:** No background, no border. Warm Stone (#7A7A7A) text. Used for tertiary actions like "Lewati untuk nanti."
- **Icon Button:** 48dp circular touch target, 24dp icon centered. Used in bottom navigation and quick actions.

### Cards & Containers
- **Standard Card:** Gently rounded corners (16dp radius). Clean Canvas (#FFFFFF) background on light mode, Twilight Navy (#22223B) on dark. No shadow — differentiated by background color alone. 16dp internal padding.
- **Tinted Card:** Same shape, but uses light primary/secondary/accent tint as background (Sage Whisper for streak, Lavender Mist for meditation, light teal tint for workout).
- **Selection Card:** Same as standard but with a 2dp primary border when selected. Subtle scale-up animation (1.02×) on selection.

### Chips & Tags
- **Duration Chip:** Small rounded rectangles (8dp radius). Weathered Linen background, Charcoal text. Selected state: Garden Sage background with white text.
- **XP Chip:** Rounded pill with Garden Sage background. "+20 XP ✨" format. Subtle glow animation when earned.
- **Category Filter Chip:** Rounded pill, outlined in dormant state, filled in active state.

### Inputs & Forms
- **Text Input:** Rounded rectangle (12dp radius). Weathered Linen background with no visible border in rest state. 1.5dp Garden Sage border on focus. Warm Stone placeholder text.
- **Time Picker:** Large, centered display with Nunito Bold typography. Standard Material time picker behavior.

### Progress Bars
- **XP Bar:** Rounded full (pill shape). Weathered Linen track, Garden Sage fill. 8dp height. Smooth fill animation on XP gain.
- **Workout Progress:** Same style but wider (12dp height). Shows overall routine progress.

### Navigation
- **Bottom Navigation Bar:** 5 items evenly spaced. 64dp height. Clean Canvas background. Active item: filled icon + primary color + label. Inactive: outline icon + Warm Stone color + label.

## 5. Layout Principles

- **Screen Padding:** 20dp horizontal on all screens. Content never touches screen edges.
- **Vertical Rhythm:** 16dp standard gap between cards. 24dp between sections. 32dp before section headers that follow dense content.
- **Card Stacking:** Cards stack vertically with 12-16dp gaps. No horizontal card scrolling except for the brain evolution timeline.
- **Content Density:** Low. Generous whitespace between elements. Maximum 60-70% of screen real estate used for content — the rest is breathing room.
- **Grid:** Single column layout for all main content. 2-column grids only for stat cards (3×2) and badge grids (4×n). Category chips wrap in horizontal rows.
- **Safe Areas:** Proper inset handling for notches and navigation bars.
- **Scrolling:** Main content scrolls vertically. Bottom nav is fixed. App bar scrolls away on long pages (meditation list, workout list).

## 6. Animation & Motion Principles

- **Speed:** All transitions are 200-300ms. Nothing feels sluggish or jarring.
- **Easing:** Standard Material easing curves. Ease-out for enters, ease-in for exits.
- **Brain Idle:** Subtle 3-second pulse/glow cycle. Neurons flicker softly at random intervals.
- **Level Up:** 800ms burst animation — light emanates from brain center, new neural connections draw in with a trace effect.
- **XP Earned:** Chip scales up from 0, holds 500ms, then settles to final size.
- **Quest Complete:** Checkmark draws on (200ms), then text gets strikethrough effect (150ms).
- **Page Transitions:** Shared element transitions where elements exist on both pages. Standard slide for new screens.
- **Haptics:** Light haptic on button press, medium on quest complete, heavy on level up.
