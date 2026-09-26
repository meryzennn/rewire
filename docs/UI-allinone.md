# Rewire image asset brief for Antigravity

## Goal

Generate the complete set of original, production-ready PNG illustrations for Rewire. Save each image as a separate file at the exact path below. Do not edit app code, generate a contact sheet, or add text/logos to images.

## Product and visual direction

Rewire is an Android recovery app built around steady progress, meditation, and bodyweight exercise. The visual mood is calm, nurturing, non-judgmental, and gently hopeful. Follow `DESIGN.md` and `docs/UI.md` for the product palette and screen context. Use the existing Rewire brain illustration in the Stitch project as a visual reference for the brain motif only; do not copy complete screens or introduce a new brand direction.

Use muted Garden Sage `#8FAE8B` and Dusty Lavender `#A8A0C8` as the main illustration colors, with restrained Still Teal `#6BA8A0` accents. Use soft, clear shapes and controlled highlights. Keep each subject legible when displayed around 160–240 logical pixels on a phone. Avoid busy detail, heavy shadows, gradients covering the whole image, and glow everywhere.

## Shared output requirements

- PNG, RGBA, true transparent alpha outside the artwork. Do not draw a checkerboard or white background.
- Square 1024 × 1024 px canvas; center the subject and leave about 8% clear padding so the image can scale and crop safely.
- One asset per file, no labels, letters, numbers, captions, border, watermark, or embedded UI.
- Keep a consistent illustration language across the full set: polished, calm, rounded vector-like forms with subtle painterly light, clear silhouette, and restrained detail. Avoid photorealism, stock art, clip-art, and generic 3D blobs.
- Use clean edges and preserve transparent pixels. Do not flatten transparency against a solid color.
- Exercise figures: anonymous adult, anatomically plausible bodyweight form, modest plain clothing, no visible brand, no equipment. Show the full body and the movement clearly; use a small secondary pose only when needed to explain motion. Avoid sexualized framing.
- Export directly to the requested paths. Report any asset that could not be generated rather than silently omitting or renaming it.

## Asset inventory

### Brain evolution: five separate stages

Make these five illustrations read as the same Rewire brain evolving through the stages. Preserve a consistent brain silhouette, viewing angle, scale, and visual construction; increase neural activity gradually. Do not make the early stage look damaged or frightening. The progression represents patient growth, not a medical claim.

1. `assets/images/brain/dormant.png` — Quiet, subdued brain silhouette; very few dim neural connections; charcoal and soft gray with only a faint sage signal. Calm, not broken.
2. `assets/images/brain/awakening.png` — Same brain; several small sage neural points begin to glow, with a few visible connections.
3. `assets/images/brain/growing.png` — Same brain; more connected neural pathways and balanced sage/lavender light, clearly more active than awakening.
4. `assets/images/brain/thriving.png` — Same brain; dense, organized neural network with confident sage light and restrained teal details.
5. `assets/images/brain/transcendent.png` — Same brain; complete, coherent neural network with the brightest controlled illumination and a subtle surrounding aura. Keep the silhouette crisp and transparent outside it.

### Onboarding welcome illustration

`assets/images/onboarding/welcome_brain.png` — Use the dormant brain artwork as the visual base, with a gentle first neural light appearing. Match the brain-stage family so this can be reused on the welcome screen. Do not make a separate unrelated logo or add text.

### Exercise illustrations: 15 separate assets

Use a consistent full-body three-quarter or side view, whichever makes the movement easiest to understand. For exercises with motion, depict start and end positions together within the same composition, with restrained motion cues that remain understandable without arrows or text. Keep limb positions unobstructed. File names must be lowercase and match exactly.

1. `assets/images/exercises/pushup.png` — Beginner push-up, straight body line, hands under shoulders; show top and lowered positions.
2. `assets/images/exercises/knee_pushup.png` — Knee push-up, straight line from head through hips to knees; show top and lowered positions.
3. `assets/images/exercises/diamond_pushup.png` — Diamond push-up, hands close beneath chest; show top and lowered positions.
4. `assets/images/exercises/pike_pushup.png` — Pike push-up, hips raised in an inverted V; show bent-elbow and extended positions.
5. `assets/images/exercises/squat.png` — Bodyweight squat, feet grounded and knees tracking naturally; show standing and lowered positions.
6. `assets/images/exercises/lunge.png` — Forward lunge, stable torso and front knee aligned over foot; show standing and lunge positions.
7. `assets/images/exercises/jump_squat.png` — Jump squat, show the loaded squat and a small, controlled airborne pose; keep landing form readable.
8. `assets/images/exercises/wall_sit.png` — Wall sit, back against an implied invisible wall, thighs near parallel, knees aligned; no wall object required.
9. `assets/images/exercises/plank.png` — Forearm plank, straight head-to-heel alignment and elbows under shoulders; show a clear side view.
10. `assets/images/exercises/crunch.png` — Crunch, knees bent and feet grounded; show relaxed start and lifted shoulder-blade position.
11. `assets/images/exercises/mountain_climber.png` — High plank with one knee driving forward; show the opposite extended-leg position subtly.
12. `assets/images/exercises/bicycle_crunch.png` — Supine bicycle crunch, opposite elbow and knee approaching with controlled form; show a second leg position subtly.
13. `assets/images/exercises/jumping_jack.png` — Jumping jack, show arms-down/feet-together and arms-up/feet-apart poses.
14. `assets/images/exercises/high_knees.png` — Upright high-knee run in place, one knee lifted and opposite arm forward; show alternating leg position subtly.
15. `assets/images/exercises/burpee.png` — Safe bodyweight burpee sequence compressed into a clean composition: squat, plank, return to squat, upright finish. Keep poses separated and readable, no floor equipment.

## Delivery check

Before reporting completion:

- Confirm all 21 files exist at the exact paths above.
- Confirm each is a valid 1024 × 1024 PNG with an alpha channel and transparent exterior pixels.
- Confirm each file contains one illustration, no text, no watermark, and no checkerboard.
- Confirm the five brain stages visibly progress while retaining a shared silhouette and style.
- Confirm all 15 exercise poses are recognizable, anatomically plausible, and use the same illustration language.
- Report the output paths and any deviations. Do not claim Flutter integration or runtime verification; this task produces image assets only.
