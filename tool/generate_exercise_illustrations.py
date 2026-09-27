import os
import math
from PIL import Image, ImageDraw, ImageFilter

# Palette from DESIGN.md and docs/UI-allinone.md
SAGE = (143, 174, 139)          # #8FAE8B - primary accent
LAVENDER = (168, 160, 200)      # #A8A0C8 - secondary accent
TEAL = (107, 168, 160)          # #6BA8A0 - Still Teal
CHARCOAL = (58, 74, 91)         # Dark slate / clothing
CREAM = (248, 246, 240)         # Soft skin / highlight
SHADOW = (180, 195, 190, 80)    # Soft ground shadow

def create_base_canvas():
    return Image.new('RGBA', (1024, 1024), (0, 0, 0, 0))

def draw_capsule(draw, p1, p2, width, color):
    draw.line([p1, p2], fill=color, width=width)
    r = width // 2
    draw.ellipse([p1[0]-r, p1[1]-r, p1[0]+r, p1[1]+r], fill=color)
    draw.ellipse([p2[0]-r, p2[1]-r, p2[0]+r, p2[1]+r], fill=color)

def draw_ground_shadow(draw, center, rx, ry):
    x, y = center
    draw.ellipse([x - rx, y - ry, x + rx, y + ry], fill=SHADOW)

def draw_person(draw, head_c, head_r, shoulder, hip, elbow, hand, knee, foot,
                primary_color=SAGE, clothing_color=CHARCOAL, alpha=255):
    p_color = (*primary_color[:3], alpha)
    c_color = (*clothing_color[:3], alpha)
    skin_color = (235, 225, 215, alpha)

    # Torso
    draw_capsule(draw, shoulder, hip, 52, c_color)

    # Upper leg & lower leg
    draw_capsule(draw, hip, knee, 36, c_color)
    draw_capsule(draw, knee, foot, 30, skin_color)

    # Upper arm & forearm
    draw_capsule(draw, shoulder, elbow, 28, p_color)
    draw_capsule(draw, elbow, hand, 24, skin_color)

    # Head
    hx, hy = head_c
    draw.ellipse([hx - head_r, hy - head_r, hx + head_r, hy + head_r], fill=skin_color)
    # Hair cap
    draw.chord([hx - head_r, hy - head_r, hx + head_r, hy + head_r], 180, 360, fill=c_color)

def render_exercises():
    out_dir = 'assets/images/exercises'
    os.makedirs(out_dir, exist_ok=True)

    # 1. PUSHUP
    im = create_base_canvas()
    d = ImageDraw.Draw(im)
    draw_ground_shadow(d, (512, 740), 280, 22)
    # Top position (ghosted)
    draw_person(d, (310, 480), 38, (380, 520), (590, 560), (410, 600), (430, 700),
                (730, 620), (860, 680), primary_color=LAVENDER, alpha=110)
    # Bottom position (active)
    draw_person(d, (320, 610), 38, (390, 640), (600, 650), (410, 690), (440, 710),
                (740, 670), (870, 700), primary_color=SAGE, alpha=255)
    im.save(f'{out_dir}/pushup.png', 'PNG')

    # 2. KNEE PUSHUP
    im = create_base_canvas()
    d = ImageDraw.Draw(im)
    draw_ground_shadow(d, (490, 740), 260, 22)
    # Top position
    draw_person(d, (320, 480), 38, (390, 520), (590, 580), (410, 600), (420, 700),
                (700, 700), (780, 650), primary_color=LAVENDER, alpha=110)
    # Bottom position
    draw_person(d, (330, 600), 38, (400, 630), (590, 660), (420, 690), (430, 710),
                (700, 705), (780, 660), primary_color=SAGE, alpha=255)
    im.save(f'{out_dir}/knee_pushup.png', 'PNG')

    # 3. DIAMOND PUSHUP
    im = create_base_canvas()
    d = ImageDraw.Draw(im)
    draw_ground_shadow(d, (512, 740), 280, 22)
    # Top with angled inward arms
    draw_person(d, (320, 490), 38, (390, 530), (600, 570), (430, 610), (470, 700),
                (740, 630), (870, 690), primary_color=SAGE, alpha=255)
    im.save(f'{out_dir}/diamond_pushup.png', 'PNG')

    # 4. PIKE PUSHUP
    im = create_base_canvas()
    d = ImageDraw.Draw(im)
    draw_ground_shadow(d, (512, 740), 260, 22)
    # Inverted V shape (hip high at 380, hands at 700, feet at 700)
    draw_person(d, (380, 610), 38, (410, 550), (510, 390), (420, 620), (430, 700),
                (630, 550), (740, 700), primary_color=SAGE, alpha=255)
    # Down position ghosted
    draw_person(d, (390, 670), 36, (420, 610), (510, 410), (450, 660), (430, 700),
                (630, 560), (740, 700), primary_color=LAVENDER, alpha=110)
    im.save(f'{out_dir}/pike_pushup.png', 'PNG')

    # 5. SQUAT
    im = create_base_canvas()
    d = ImageDraw.Draw(im)
    draw_ground_shadow(d, (512, 760), 250, 24)
    # Standing position (ghosted)
    draw_person(d, (380, 320), 40, (380, 400), (380, 550), (440, 450), (460, 520),
                (380, 650), (380, 740), primary_color=LAVENDER, alpha=110)
    # Squat position (active)
    draw_person(d, (580, 460), 40, (570, 520), (530, 610), (640, 530), (690, 530),
                (640, 620), (580, 740), primary_color=SAGE, alpha=255)
    im.save(f'{out_dir}/squat.png', 'PNG')

    # 6. LUNGE
    im = create_base_canvas()
    d = ImageDraw.Draw(im)
    draw_ground_shadow(d, (512, 760), 280, 24)
    # Standing
    draw_person(d, (360, 340), 40, (360, 410), (360, 550), (360, 460), (360, 530),
                (360, 640), (360, 740), primary_color=LAVENDER, alpha=100)
    # Forward lunge: front leg 90 deg, back knee down
    draw_person(d, (560, 420), 40, (560, 490), (560, 600), (560, 530), (560, 590),
                (670, 610), (670, 740), primary_color=SAGE, alpha=255)
    draw_capsule(d, (560, 600), (460, 670), 34, CHARCOAL) # back thigh
    draw_capsule(d, (460, 670), (410, 740), 28, (235, 225, 215)) # back shin
    im.save(f'{out_dir}/lunge.png', 'PNG')

    # 7. JUMP SQUAT
    im = create_base_canvas()
    d = ImageDraw.Draw(im)
    draw_ground_shadow(d, (512, 770), 260, 20)
    # Low squat
    draw_person(d, (420, 510), 38, (420, 560), (390, 640), (470, 580), (510, 580),
                (480, 640), (440, 740), primary_color=LAVENDER, alpha=110)
    # Mid-air explosion (feet off ground)
    draw_person(d, (620, 260), 40, (620, 330), (620, 470), (580, 310), (560, 250),
                (620, 570), (620, 660), primary_color=SAGE, alpha=255)
    im.save(f'{out_dir}/jump_squat.png', 'PNG')

    # 8. WALL SIT
    im = create_base_canvas()
    d = ImageDraw.Draw(im)
    draw_ground_shadow(d, (560, 760), 190, 22)
    # Back against implied wall at x=440, thighs horizontal, shins vertical
    draw_person(d, (440, 400), 42, (440, 480), (440, 610), (480, 540), (520, 600),
                (570, 610), (570, 740), primary_color=SAGE, alpha=255)
    # Subtle implied vertical guide
    d.line([(400, 320), (400, 750)], fill=(*TEAL, 70), width=4)
    im.save(f'{out_dir}/wall_sit.png', 'PNG')

    # 9. PLANK
    im = create_base_canvas()
    d = ImageDraw.Draw(im)
    draw_ground_shadow(d, (512, 740), 300, 22)
    # Pure straight alignment head to toe
    draw_person(d, (310, 560), 40, (380, 590), (600, 600), (380, 660), (440, 700),
                (740, 630), (870, 680), primary_color=SAGE, alpha=255)
    im.save(f'{out_dir}/plank.png', 'PNG')

    # 10. CRUNCH
    im = create_base_canvas()
    d = ImageDraw.Draw(im)
    draw_ground_shadow(d, (512, 740), 280, 22)
    # Back on floor, knees up, shoulders raised
    draw_person(d, (360, 620), 40, (420, 650), (570, 700), (370, 590), (340, 580),
                (670, 610), (740, 710), primary_color=SAGE, alpha=255)
    im.save(f'{out_dir}/crunch.png', 'PNG')

    # 11. MOUNTAIN CLIMBER
    im = create_base_canvas()
    d = ImageDraw.Draw(im)
    draw_ground_shadow(d, (512, 740), 290, 22)
    # Plank with one knee tucked forward to chest
    draw_person(d, (320, 510), 40, (390, 550), (600, 580), (400, 620), (420, 700),
                (510, 630), (540, 700), primary_color=SAGE, alpha=255)
    # Extended back leg
    draw_capsule(d, (600, 580), (740, 630), 34, CHARCOAL)
    draw_capsule(d, (740, 630), (870, 690), 28, (235, 225, 215))
    im.save(f'{out_dir}/mountain_climber.png', 'PNG')

    # 12. BICYCLE CRUNCH
    im = create_base_canvas()
    d = ImageDraw.Draw(im)
    draw_ground_shadow(d, (512, 740), 280, 22)
    # Supine, rotated torso, right elbow toward left knee
    draw_person(d, (360, 600), 40, (430, 630), (560, 690), (460, 570), (480, 540),
                (510, 590), (530, 530), primary_color=SAGE, alpha=255)
    # Opposite leg extended
    draw_capsule(d, (560, 690), (680, 660), 32, CHARCOAL)
    draw_capsule(d, (680, 660), (790, 640), 26, (235, 225, 215))
    im.save(f'{out_dir}/bicycle_crunch.png', 'PNG')

    # 13. JUMPING JACK
    im = create_base_canvas()
    d = ImageDraw.Draw(im)
    draw_ground_shadow(d, (512, 760), 260, 22)
    # P1: Arms down, feet together (ghosted)
    draw_person(d, (400, 320), 40, (400, 390), (400, 530), (400, 450), (400, 530),
                (400, 630), (400, 740), primary_color=LAVENDER, alpha=110)
    # P2: Star position (arms up, feet apart)
    draw_person(d, (620, 320), 40, (620, 390), (620, 530), (560, 300), (520, 230),
                (550, 630), (500, 740), primary_color=SAGE, alpha=255)
    # Second arm & leg of star
    draw_capsule(d, (620, 390), (680, 300), 28, SAGE)
    draw_capsule(d, (680, 300), (720, 230), 24, (235, 225, 215))
    draw_capsule(d, (620, 530), (690, 630), 36, CHARCOAL)
    draw_capsule(d, (690, 630), (740, 740), 30, (235, 225, 215))
    im.save(f'{out_dir}/jumping_jack.png', 'PNG')

    # 14. HIGH KNEES
    im = create_base_canvas()
    d = ImageDraw.Draw(im)
    draw_ground_shadow(d, (512, 760), 240, 22)
    # Runner upright, right knee raised 90 deg, opposite arm forward
    draw_person(d, (512, 330), 40, (512, 400), (512, 530), (450, 460), (420, 410),
                (600, 530), (600, 640), primary_color=SAGE, alpha=255)
    # Standing support leg
    draw_capsule(d, (512, 530), (500, 640), 36, CHARCOAL)
    draw_capsule(d, (500, 640), (500, 740), 30, (235, 225, 215))
    im.save(f'{out_dir}/high_knees.png', 'PNG')

    # 15. BURPEE
    im = create_base_canvas()
    d = ImageDraw.Draw(im)
    draw_ground_shadow(d, (512, 750), 360, 24)
    # Phase 1: Squat tuck
    draw_person(d, (260, 550), 34, (260, 590), (250, 650), (290, 620), (320, 700),
                (290, 650), (280, 720), primary_color=LAVENDER, alpha=130)
    # Phase 2: Plank
    draw_person(d, (480, 620), 34, (530, 640), (660, 650), (540, 670), (560, 720),
                (730, 660), (810, 700), primary_color=LAVENDER, alpha=130)
    # Phase 3: Upright jump finish
    draw_person(d, (780, 310), 38, (780, 370), (780, 490), (740, 290), (720, 230),
                (780, 580), (780, 680), primary_color=SAGE, alpha=255)
    im.save(f'{out_dir}/burpee.png', 'PNG')

    print('Successfully rendered all 15 exercise illustrations!')

if __name__ == '__main__':
    render_exercises()
