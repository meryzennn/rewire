# Rewire — UI Design Specification

## Design System

### Color Tokens

```
Light Mode:
  background:       #FAF8F5  (warm cream)
  surface:          #FFFFFF
  surface-variant:  #F0EDE8
  primary:          #8FAE8B  (sage green)
  primary-container:#D4E8D2
  secondary:        #A8A0C8  (dusty lavender)
  secondary-container: #DDD8EE
  accent:           #6BA8A0  (muted teal)
  text-primary:     #2D2D2D  (charcoal)
  text-secondary:   #7A7A7A  (warm gray)
  text-on-primary:  #FFFFFF
  success:          #7BC67E
  warning:          #E8B86D
  danger:           #D4836D
  divider:          #E8E4DF

Dark Mode:
  background:       #1A1A2E  (deep slate)
  surface:          #22223B  (dark navy)
  surface-variant:  #2A2A45
  primary:          #9EC49A
  primary-container:#3A5038
  secondary:        #B8B0D8
  secondary-container: #4A4468
  accent:           #7DBDB5
  text-primary:     #E8E8E8  (off-white)
  text-secondary:   #9A9A9A
  text-on-primary:  #1A1A2E
  success:          #8AD68D
  warning:          #F0C87D
  danger:           #E0937D
  divider:          #3A3A55
```

### Typography

```
Font Family: Nunito (primary) / Inter (fallback)

Display Large:   32sp / Bold      — Brain level name
Display Medium:  28sp / Bold      — Screen titles (rarely used)
Headline:        24sp / SemiBold  — Section headers
Title Large:     20sp / SemiBold  — Card titles, streak number
Title Medium:    18sp / SemiBold  — Sub-section headers
Body Large:      16sp / Regular   — Primary body text
Body Medium:     14sp / Regular   — Secondary body text, descriptions
Body Small:      12sp / Regular   — Captions, timestamps
Label Large:     14sp / SemiBold  — Button text
Label Medium:    12sp / SemiBold  — Badge labels, tags
Label Small:     10sp / Medium    — Micro labels
```

### Spacing & Layout

```
Base unit: 4dp
Spacing scale: 4, 8, 12, 16, 20, 24, 32, 40, 48, 64

Screen padding: 20dp horizontal
Card padding: 16dp
Card border radius: 16dp
Button border radius: 12dp
Icon size: 24dp (standard), 20dp (small), 32dp (large)
Bottom nav height: 64dp
App bar height: 56dp

Elevation:
  Card: 0dp (use border or surface-variant bg instead)
  Modal/Sheet: 8dp
  FAB: 4dp
```

### Iconography

```
Style: Rounded line icons
Weight: 1.5-2px stroke
Library: Lucide Icons or Phosphor Icons (rounded variant)
Active state: Filled variant
Inactive state: Outline variant
```

---

## Screen 1: Onboarding Flow (3-4 screens swipeable)

### Screen 1a: Welcome
```
┌─────────────────────────────┐
│                             │
│                             │
│     [Brain illustration]    │
│     (dormant, gray, soft    │
│      glow starting)         │
│                             │
│                             │
│     Welcome to Rewire       │  ← Display Large, centered
│                             │
│  Mulai perjalanan rewiring  │  ← Body Large, text-secondary
│  otakmu hari ini.           │     centered
│                             │
│                             │
│  ● ○ ○ ○                    │  ← Page indicator, centered
│                             │
│  ┌─────────────────────┐    │
│  │    Mulai Sekarang    │    │  ← Primary button, full width
│  └─────────────────────┘    │
│                             │
│       Sudah punya data?     │  ← Text button, text-secondary
│                             │
└─────────────────────────────┘
```

### Screen 1b: Three Pillars
```
┌─────────────────────────────┐
│                             │
│     Tiga Pilar Rewire       │  ← Headline, centered
│                             │
│  ┌─────────────────────┐    │
│  │ 🧠                  │    │
│  │ Track & Recover      │    │  ← Card, sage green tint bg
│  │ Lacak streak dan     │    │
│  │ pantau pemulihanmu   │    │
│  └─────────────────────┘    │
│                             │
│  ┌─────────────────────┐    │
│  │ 🧘                  │    │
│  │ Meditasi             │    │  ← Card, lavender tint bg
│  │ Tenangkan pikiran    │    │
│  │ dengan ambient sound │    │
│  └─────────────────────┘    │
│                             │
│  ┌─────────────────────┐    │
│  │ 💪                  │    │
│  │ Olahraga Rumahan     │    │  ← Card, teal tint bg
│  │ Latihan tanpa alat   │    │
│  │ untuk tubuh & mental │    │
│  └─────────────────────┘    │
│                             │
│  ○ ● ○ ○                    │
│                             │
│  ┌─────────────────────┐    │
│  │     Selanjutnya      │    │
│  └─────────────────────┘    │
│                             │
└─────────────────────────────┘
```

### Screen 1c: Gamification Intro
```
┌─────────────────────────────┐
│                             │
│   Level Up Otakmu           │  ← Headline, centered
│                             │
│   [5 brain stages in a      │
│    horizontal row showing   │
│    evolution from dormant   │
│    to transcendent, small]  │
│                             │
│   Setiap aktivitas positif  │  ← Body Large, centered
│   memberi XP dan membuat    │
│   otakmu berevolusi.        │
│                             │
│   ┌──────┐ ┌──────┐         │
│   │ +20  │ │ +15  │         │  ← Small chips showing XP
│   │Check │ │Work  │         │     sources
│   │ -in  │ │ out  │         │
│   └──────┘ └──────┘         │
│   ┌──────┐ ┌──────┐         │
│   │ +10  │ │ +25  │         │
│   │Medi- │ │Quest │         │
│   │tasi  │ │      │         │
│   └──────┘ └──────┘         │
│                             │
│  ○ ○ ● ○                    │
│                             │
│  ┌─────────────────────┐    │
│  │     Selanjutnya      │    │
│  └─────────────────────┘    │
│                             │
└─────────────────────────────┘
```

### Screen 1d: Set Reminder
```
┌─────────────────────────────┐
│                             │
│   Atur Pengingat Harian     │  ← Headline, centered
│                             │
│   Konsistensi adalah kunci. │  ← Body Large, text-secondary
│   Pilih waktu untuk         │
│   reminder check-in.        │
│                             │
│   ┌─────────────────────┐   │
│   │                     │   │
│   │    ⏰ 08:00 AM      │   │  ← Time picker, large
│   │                     │   │
│   └─────────────────────┘   │
│                             │
│   ☐ Ingatkan untuk meditasi │  ← Checkbox options
│   ☐ Ingatkan untuk olahraga │
│                             │
│                             │
│  ○ ○ ○ ●                    │
│                             │
│  ┌─────────────────────┐    │
│  │   Mulai Perjalanan   │    │  ← Primary button, bold
│  └─────────────────────┘    │
│                             │
│       Lewati untuk nanti    │  ← Text button
│                             │
└─────────────────────────────┘
```

---

## Screen 2: Home Screen (Main Hub)

```
┌─────────────────────────────┐
│ Rewire              ⚙️      │  ← App bar: logo left, settings right
├─────────────────────────────┤
│                             │
│  ┌─────────────────────┐    │
│  │                     │    │
│  │  [BRAIN VISUAL]     │    │  ← Centerpiece: animated brain
│  │  Glowing neurons    │    │     at current evolution stage
│  │  Particle effects   │    │     Tappable → detail view
│  │                     │    │
│  │  Level 12           │    │  ← Label, below brain
│  │  "Awakening"        │    │  ← Stage name, secondary color
│  │                     │    │
│  │  ████████░░ 720/1000│    │  ← XP progress bar to next level
│  │                     │    │
│  └─────────────────────┘    │
│                             │
│  ┌─────────────────────┐    │
│  │ 🔥 Streak           │    │
│  │                     │    │
│  │    14 Hari          │    │  ← Title Large, primary color, bold
│  │    Terpanjang: 21   │    │  ← Body Small, text-secondary
│  │                     │    │
│  │ ┌────────────────┐  │    │
│  │ │  ✅ Check-in   │  │    │  ← Button: primary if not done,
│  │ └────────────────┘  │    │     success/disabled if done today
│  └─────────────────────┘    │
│                             │
│  Daily Quests        2/4 ✓  │  ← Section header + progress
│  ┌─────────────────────┐    │
│  │ ✅ Check-in hari ini│+20 │  ← Completed quest, strikethrough
│  │ ✅ Meditasi 5 menit │+10 │
│  │ ⬜ Workout 1 routine│+25 │  ← Incomplete quest
│  │ ⬜ Catat 1 trigger  │+15 │
│  └─────────────────────┘    │
│                             │
│  Quick Actions              │  ← Section header
│  ┌────┐ ┌────┐ ┌────┐      │
│  │ 🧘 │ │ 💪 │ │ 📊 │      │  ← Round icon buttons
│  │Medi │ │Work│ │Stat│      │
│  │tasi │ │out │ │s   │      │
│  └────┘ └────┘ └────┘      │
│                             │
├─────────────────────────────┤
│ 🏠    🧘    💪    📊    ⚙️  │  ← Bottom navigation bar
│ Home  Medi  Work  Prog  Set │     5 items
│  ●                          │     Active = filled + primary color
└─────────────────────────────┘
```

**Behavior Notes:**
- Brain visual has subtle idle animation (gentle pulse/glow)
- Tapping brain opens full-screen brain detail with evolution timeline
- Check-in button changes state after daily check-in
- Quests auto-refresh at midnight
- Pull-to-refresh updates quest status

---

## Screen 3: Daily Check-in

```
┌─────────────────────────────┐
│ ←  Check-in Harian          │  ← App bar with back
├─────────────────────────────┤
│                             │
│  Hari ke-15                 │  ← Headline, primary color
│  26 September 2026          │  ← Body Medium, text-secondary
│                             │
│  Bagaimana hari ini?        │  ← Title Medium
│                             │
│  ┌─────────────────────┐    │
│  │                     │    │
│  │   ✅ Hari yang      │    │  ← Large tappable card
│  │      Bersih         │    │     Sage green bg when selected
│  │                     │    │
│  └─────────────────────┘    │
│                             │
│  ┌─────────────────────┐    │
│  │                     │    │
│  │   🔄 Relapse        │    │  ← Large tappable card
│  │      Hari ini       │    │     Muted coral bg when selected
│  │                     │    │
│  └─────────────────────┘    │
│                             │
│  Mood kamu hari ini?        │  ← Title Medium
│                             │
│  😫  😟  😐  🙂  😄       │  ← 5 emoji mood selector
│                             │  ← Selected = enlarged + circle bg
│                             │
│  Trigger hari ini?          │  ← Title Medium (optional section)
│                             │
│  ┌─────────────────────┐    │
│  │ Tulis trigger...    │    │  ← Text input, optional
│  │                     │    │
│  └─────────────────────┘    │
│                             │
│  ┌─────────────────────┐    │
│  │     Simpan          │    │  ← Primary button, full width
│  └─────────────────────┘    │
│                             │
└─────────────────────────────┘
```

**If Relapse selected → show encouraging message:**
```
┌─────────────────────────────┐
│                             │
│  Tidak apa-apa.             │  ← Headline, warm tone
│                             │
│  Setiap master pernah       │  ← Body Large, text-secondary
│  gagal. Yang penting        │
│  adalah bangkit lagi.       │
│                             │
│  Streak kamu akan reset,    │
│  tapi XP dan level tetap.   │
│                             │
│  ┌─────────────────────┐    │
│  │   Mulai Lagi 💪     │    │  ← Primary button
│  └─────────────────────┘    │
│                             │
└─────────────────────────────┘
```

---

## Screen 4: Meditation

### 4a: Meditation Home
```
┌─────────────────────────────┐
│  Meditasi                   │  ← App bar title
├─────────────────────────────┤
│                             │
│  ┌─────────────────────┐    │
│  │ Total Meditasi      │    │
│  │ 🧘 245 menit        │    │  ← Stats card, lavender tint
│  │ 18 sesi             │    │
│  └─────────────────────┘    │
│                             │
│  Pilih Durasi               │  ← Section header
│                             │
│  ┌────┐┌────┐┌────┐┌────┐  │
│  │ 5  ││ 10 ││ 15 ││ 20 │  │  ← Duration chips (minutes)
│  │min ││min ││min ││min │  │     Selected = primary bg
│  └────┘└────┘└────┘└────┘  │
│  ┌────┐┌────────────────┐  │
│  │ 30 ││   Custom ⏱️   │  │
│  │min ││                │  │
│  └────┘└────────────────┘  │
│                             │
│  Pilih Suara                │  ← Section header
│                             │
│  ┌─────────────────────┐    │
│  │ 🌧️  Hujan           │ ▶ │  ← List item, preview button
│  ├─────────────────────┤    │
│  │ 🌊  Ombak Laut      │ ▶ │
│  ├─────────────────────┤    │
│  │ 🌲  Hutan           │ ▶ │
│  ├─────────────────────┤    │
│  │ 📻  White Noise     │ ▶ │
│  ├─────────────────────┤    │
│  │ 🎵  Lo-fi Ambient   │ ▶ │
│  ├─────────────────────┤    │
│  │ 🔥  Campfire        │ ▶ │
│  └─────────────────────┘    │
│                             │
│  Breathing Exercise         │  ← Section header
│  ┌──────────┐┌──────────┐   │
│  │ Box      ││ 4-7-8    │   │  ← Cards
│  │Breathing ││Breathing │   │
│  │ 4-4-4-4  ││ Relax    │   │
│  └──────────┘└──────────┘   │
│                             │
│  ┌─────────────────────┐    │
│  │  Mulai Meditasi 🧘  │    │  ← Primary button, full width
│  └─────────────────────┘    │
│                             │
├─────────────────────────────┤
│ 🏠    🧘    💪    📊    ⚙️  │
│        ●                    │
└─────────────────────────────┘
```

### 4b: Active Meditation Timer
```
┌─────────────────────────────┐
│                             │
│                             │
│                             │
│      [Subtle animated       │
│       circle / mandala      │
│       pulsing slowly]       │
│                             │
│                             │
│         12:34               │  ← Display Large, centered
│       / 15:00               │  ← Body Medium, text-secondary
│                             │
│      🌧️ Hujan              │  ← Current audio label
│                             │
│                             │
│  [Breathing guide visual    │  ← Only if breathing exercise
│   expanding/contracting     │     selected. Animated circle
│   circle with text:         │     with "Tarik napas..."
│   "Tarik napas... 4"]       │     "Tahan... 7"
│                             │     "Buang napas... 8"
│                             │
│                             │
│     ⏸️          ⏹️          │  ← Pause / Stop buttons
│                             │  ← Minimal UI, mostly empty
│                             │     for focus
│                             │
└─────────────────────────────┘
```

**Notes:**
- Screen stays awake during meditation
- Background is slightly darker than normal (dimmed)
- Minimal UI to avoid distraction
- Completion shows celebratory animation + XP earned

### 4c: Meditation Complete
```
┌─────────────────────────────┐
│                             │
│                             │
│     [Gentle checkmark       │
│      animation / confetti]  │
│                             │
│     Sesi Selesai! 🧘        │  ← Headline
│                             │
│     15 menit meditasi       │  ← Body Large
│                             │
│     ┌──────────────┐        │
│     │   +20 XP ✨  │        │  ← XP earned chip, animated
│     └──────────────┘        │
│                             │
│                             │
│  ┌─────────────────────┐    │
│  │      Selesai         │    │
│  └─────────────────────┘    │
│                             │
└─────────────────────────────┘
```

---

## Screen 5: Workout

### 5a: Workout Home
```
┌─────────────────────────────┐
│  Olahraga                   │  ← App bar title
├─────────────────────────────┤
│                             │
│  ┌─────────────────────┐    │
│  │ Total Olahraga      │    │
│  │ 💪 180 menit        │    │  ← Stats card, teal tint
│  │ 12 sesi             │    │
│  └─────────────────────┘    │
│                             │
│  Workout Routines           │  ← Section header
│                             │
│  ┌─────────────────────┐    │
│  │ [illustration]       │    │
│  │ Morning Energy       │    │  ← Card with illustration
│  │ 15 menit · Beginner  │    │
│  │ 6 gerakan            │    │
│  │ ┌──────────────────┐ │    │
│  │ │   Mulai ▶        │ │    │
│  │ └──────────────────┘ │    │
│  └─────────────────────┘    │
│                             │
│  ┌─────────────────────┐    │
│  │ [illustration]       │    │
│  │ Full Body Burn       │    │
│  │ 20 menit · Intermediate│
│  │ 8 gerakan            │    │
│  │ ┌──────────────────┐ │    │
│  │ │   Mulai ▶        │ │    │
│  │ └──────────────────┘ │    │
│  └─────────────────────┘    │
│                             │
│  ┌─────────────────────┐    │
│  │ [illustration]       │    │
│  │ Core Crusher         │    │
│  │ 10 menit · Beginner  │    │
│  │ 5 gerakan            │    │
│  │ ┌──────────────────┐ │    │
│  │ │   Mulai ▶        │ │    │
│  │ └──────────────────┘ │    │
│  └─────────────────────┘    │
│                             │
│  Semua Gerakan              │  ← Section header
│                             │
│  ┌─────┐┌─────┐┌─────┐     │  ← Category filter chips
│  │ All ││Upper││Lower│     │
│  └─────┘└─────┘└─────┘     │
│  ┌─────┐┌─────┐            │
│  │Core ││Card.│            │
│  └─────┘└─────┘            │
│                             │
│  ┌─────────────────────┐    │
│  │ [img] Push-up       │    │  ← Exercise list item
│  │       3×12 · Upper   │    │
│  ├─────────────────────┤    │
│  │ [img] Squat         │    │
│  │       3×15 · Lower   │    │
│  ├─────────────────────┤    │
│  │ [img] Plank         │    │
│  │       3×30s · Core   │    │
│  └─────────────────────┘    │
│                             │
├─────────────────────────────┤
│ 🏠    🧘    💪    📊    ⚙️  │
│              ●              │
└─────────────────────────────┘
```

### 5b: Exercise Detail
```
┌─────────────────────────────┐
│ ←  Push-up                  │  ← App bar with back
├─────────────────────────────┤
│                             │
│  ┌─────────────────────┐    │
│  │                     │    │
│  │  [Large illustration │    │  ← Flat illustration showing
│  │   of exercise form]  │    │     correct form, 2 poses
│  │                     │    │     (start & end position)
│  │                     │    │
│  └─────────────────────┘    │
│                             │
│  Push-up                    │  ← Headline
│  Upper Body · Beginner      │  ← Body Medium, chips
│                             │
│  Instruksi:                 │  ← Title Medium
│                             │
│  1. Posisi plank, tangan    │  ← Body Large
│     selebar bahu            │
│  2. Turunkan badan sampai   │
│     dada hampir sentuh      │
│     lantai                  │
│  3. Dorong kembali ke       │
│     posisi awal             │
│  4. Jaga core tetap         │
│     engaged                 │
│                             │
│  ┌────────┐ ┌────────┐     │
│  │ 3 Set  │ │ 12 Rep │     │  ← Info chips
│  └────────┘ └────────┘     │
│                             │
│  Tips:                      │  ← Body Medium, text-secondary
│  Kalau belum kuat, mulai    │
│  dari lutut (knee push-up)  │
│                             │
└─────────────────────────────┘
```

### 5c: Active Workout
```
┌─────────────────────────────┐
│  Morning Energy    ✕ Batal  │  ← Routine name + cancel
├─────────────────────────────┤
│                             │
│  Gerakan 3 / 6              │  ← Body Medium, text-secondary
│  ████████████░░░░░░         │  ← Overall progress bar
│                             │
│  ┌─────────────────────┐    │
│  │                     │    │
│  │  [Exercise           │    │  ← Current exercise illustration
│  │   illustration]      │    │
│  │                     │    │
│  └─────────────────────┘    │
│                             │
│  Squat                      │  ← Title Large, centered
│                             │
│  Set 2 / 3                  │  ← Body Large, centered
│  15 repetisi                │  ← Body Medium
│                             │
│                             │
│  ┌─────────────────────┐    │
│  │   Set Selesai ✓     │    │  ← Primary button
│  └─────────────────────┘    │
│                             │
│  Next: Plank (30 detik)     │  ← Body Small, text-secondary
│                             │
└─────────────────────────────┘
```

### 5d: Rest Timer (between sets)
```
┌─────────────────────────────┐
│                             │
│                             │
│       Istirahat             │  ← Headline, centered
│                             │
│                             │
│       ┌───────────┐         │
│       │           │         │
│       │    0:23   │         │  ← Large countdown timer
│       │   / 0:30  │         │     in circular progress
│       │           │         │
│       └───────────┘         │
│                             │
│                             │
│  Next: Plank                │  ← Body Large
│  3 × 30 detik               │  ← Body Medium, text-secondary
│                             │
│                             │
│  ┌─────────────────────┐    │
│  │    Skip Istirahat   │    │  ← Outlined button
│  └─────────────────────┘    │
│                             │
│                             │
└─────────────────────────────┘
```

### 5e: Workout Complete
```
┌─────────────────────────────┐
│                             │
│     [Celebration animation  │
│      / confetti]            │
│                             │
│     Workout Selesai! 💪     │  ← Headline
│                             │
│     Morning Energy          │  ← Body Large
│     15 menit · 6 gerakan    │
│                             │
│     ┌──────────────┐        │
│     │   +30 XP ✨  │        │  ← XP chip
│     └──────────────┘        │
│                             │
│  ┌─────────────────────┐    │
│  │      Selesai         │    │
│  └─────────────────────┘    │
│                             │
└─────────────────────────────┘
```

---

## Screen 6: Progress & Stats

```
┌─────────────────────────────┐
│  Progress                   │  ← App bar title
├─────────────────────────────┤
│                             │
│  ┌─────────────────────┐    │
│  │ [Brain evolution     │    │
│  │  timeline showing    │    │  ← Horizontal scrollable
│  │  all 5 stages,       │    │     timeline of brain stages
│  │  current highlighted]│    │     Current = larger + glowing
│  │                     │    │
│  │ Dormant → Awakening → Growing → Thriving → Transcendent
│  │           ●current              │
│  └─────────────────────┘    │
│                             │
│  Level 12 · 4,230 XP Total  │  ← Title Medium
│                             │
│  Overview                   │  ← Section header
│  ┌──────┐ ┌──────┐ ┌──────┐│
│  │  14  │ │  21  │ │ 245  ││  ← Stat cards grid
│  │hari  │ │hari  │ │menit ││
│  │streak│ │best  │ │medi- ││
│  │      │ │streak│ │tasi  ││
│  └──────┘ └──────┘ └──────┘│
│  ┌──────┐ ┌──────┐ ┌──────┐│
│  │  180 │ │  42  │ │  85% ││
│  │menit │ │total │ │hari  ││
│  │work- │ │check │ │clean ││
│  │out   │ │-in   │ │      ││
│  └──────┘ └──────┘ └──────┘│
│                             │
│  Streak History             │  ← Section header
│  ┌─────────────────────┐    │
│  │ [Line chart showing  │    │
│  │  streak over time    │    │  ← Simple line graph
│  │  with dots at        │    │     30/60/90 day view toggle
│  │  relapses]           │    │
│  │                     │    │
│  │ 30d  60d  90d        │    │  ← Toggle tabs
│  └─────────────────────┘    │
│                             │
│  Mood Trend                 │  ← Section header
│  ┌─────────────────────┐    │
│  │ [Mood trend chart    │    │  ← Emoji-based line chart
│  │  emoji dots on       │    │
│  │  timeline]           │    │
│  └─────────────────────┘    │
│                             │
│  Weekly Challenges    1/3   │  ← Section header
│  ┌─────────────────────┐    │
│  │ ✅ Meditasi 5 hari  │+100│
│  │ ⬜ 3 workout        │+100│  ← Challenge progress
│  │    ██░░░ 2/3        │    │
│  │ ⬜ Streak 7 hari    │+100│
│  │    ████░ 5/7        │    │
│  └─────────────────────┘    │
│                             │
│  Achievements          8/20 │  ← Section header
│  ┌────┐┌────┐┌────┐┌────┐  │
│  │ 🔥 ││ ⚡ ││ 🧘 ││ 🔒 │  │  ← Badge grid
│  │Got ││Got ││Got ││Lock││  │     Unlocked = full color
│  └────┘└────┘└────┘└────┘  │     Locked = grayscale + lock
│  ┌────┐┌────┐┌────┐┌────┐  │
│  │ 💪 ││ 🔒 ││ 🔒 ││ 🔒 │  │
│  │Got ││Lock││Lock││Lock││
│  └────┘└────┘└────┘└────┘  │
│                             │
├─────────────────────────────┤
│ 🏠    🧘    💪    📊    ⚙️  │
│                    ●        │
└─────────────────────────────┘
```

---

## Screen 7: Settings

```
┌─────────────────────────────┐
│  Pengaturan                 │  ← App bar title
├─────────────────────────────┤
│                             │
│  Profil                     │  ← Section header
│  ┌─────────────────────┐    │
│  │ Level 12 · Awakening│    │
│  │ Total XP: 4,230     │    │  ← Profile summary card
│  │ Member since Sep '26 │    │
│  └─────────────────────┘    │
│                             │
│  Tampilan                   │  ← Section header
│  ┌─────────────────────┐    │
│  │ Dark Mode        🌙 │ ⬤ │  ← Toggle switch
│  ├─────────────────────┤    │
│  │ Bahasa          🌐  │ > │  ← ID / EN
│  └─────────────────────┘    │
│                             │
│  Notifikasi                 │  ← Section header
│  ┌─────────────────────┐    │
│  │ Daily Reminder    ⏰│ ⬤ │  ← Toggle
│  ├─────────────────────┤    │
│  │ Waktu Reminder      │ > │  ← Opens time picker
│  │ 08:00 AM            │    │
│  ├─────────────────────┤    │
│  │ Meditation Reminder │ ⬤ │
│  ├─────────────────────┤    │
│  │ Workout Reminder    │ ⬤ │
│  └─────────────────────┘    │
│                             │
│  Data                       │  ← Section header
│  ┌─────────────────────┐    │
│  │ Export Data       📤│ > │  ← Export as JSON
│  ├─────────────────────┤    │
│  │ Import Data       📥│ > │
│  ├─────────────────────┤    │
│  │ Reset Semua Data  🗑️│ > │  ← Danger, needs confirmation
│  └─────────────────────┘    │
│                             │
│  Tentang                    │  ← Section header
│  ┌─────────────────────┐    │
│  │ Versi           1.0 │    │
│  ├─────────────────────┤    │
│  │ Privacy Policy      │ > │
│  ├─────────────────────┤    │
│  │ Open Source License │ > │
│  └─────────────────────┘    │
│                             │
├─────────────────────────────┤
│ 🏠    🧘    💪    📊    ⚙️  │
│                          ●  │
└─────────────────────────────┘
```

---

## Navigation Structure

```
Bottom Navigation (5 tabs):
├── 🏠 Home (default)
├── 🧘 Meditasi
├── 💪 Olahraga
├── 📊 Progress
└── ⚙️ Pengaturan

Flows:
Home → Check-in (modal bottom sheet or new screen)
Home → Brain Detail (full screen overlay)
Meditasi → Active Timer → Complete
Olahraga → Routine Detail → Active Workout → Rest Timer → Complete
Olahraga → Exercise Detail (standalone view)
Progress → Achievement Detail (bottom sheet)
```

---

## Animations & Micro-interactions

| Element | Animation |
|---|---|
| Brain (home) | Subtle pulse/glow idle animation, neurons flicker softly |
| Brain (level up) | Burst of light, new connections form, particle explosion |
| XP earned | Chip flies up and fades, number counter animates |
| Streak counter | Number flip animation on change |
| Quest complete | Checkmark draw animation + strikethrough |
| Badge unlock | Scale-up bounce + golden shimmer |
| Meditation timer | Circular progress, breathing circle expands/contracts |
| Workout set done | Satisfying checkmark + haptic feedback |
| Page transitions | Shared element transitions where possible (Material Motion) |
| Pull to refresh | Custom brain-themed refresh indicator |

---

## Responsive Notes

- Designed for standard Android phone (360-412dp width)
- Content scrollable, no horizontal scroll
- Bottom nav fixed
- Cards fill width with 20dp side padding
- Brain visual scales proportionally
- Landscape: not priority, but should not break

---

## Accessibility

- All interactive elements: min 48dp touch target
- Color contrast: minimum 4.5:1 for text
- Semantic labels on all icons and illustrations
- Screen reader support for brain evolution state
- Mood selector: accessible labels (Sangat Buruk → Sangat Baik)
- Timer: announced via accessibility service
