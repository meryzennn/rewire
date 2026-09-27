import math
import os
import random
from PIL import Image, ImageDraw, ImageFilter

def create_brain_stages():
    base_path = 'assets/images/onboarding/welcome_brain.png'
    out_dir = 'assets/images/brain'
    os.makedirs(out_dir, exist_ok=True)

    base_img = Image.open(base_path).convert('RGBA')
    width, height = base_img.size

    # Color palette from docs/UI-allinone.md
    sage = (143, 174, 139)       # #8FAE8B
    lavender = (168, 160, 200)   # #A8A0C8
    teal = (107, 168, 160)       # #6BA8A0
    bright_sage = (185, 220, 180)
    white = (255, 255, 255)

    # Brain interior mask (where alpha > 200)
    alpha = base_img.split()[-1]
    brain_mask = alpha.point(lambda p: 255 if p > 200 else 0)

    # 1. DORMANT: Subdued brain, faint single spark
    dormant = base_img.copy()
    # Dim existing glow slightly by blending with a dimmed version of itself
    glow_layer = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    d_draw = ImageDraw.Draw(glow_layer)
    # Just one tiny faint dim sage point at center left
    d_draw.ellipse((390, 480, 406, 496), fill=(*sage, 60))
    d_draw.ellipse((395, 485, 401, 491), fill=(*bright_sage, 120))
    glow_blurred = glow_layer.filter(ImageFilter.GaussianBlur(4))
    dormant = Image.alpha_composite(dormant, glow_blurred)
    dormant.save(os.path.join(out_dir, 'dormant.png'), 'PNG')
    print('Generated dormant.png')

    # 2. AWAKENING: Base image with a couple clear glowing nodes
    awakening = base_img.copy()
    glow_layer = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    d_draw = ImageDraw.Draw(glow_layer)
    # Add a couple subtle nodes
    nodes = [(260, 420), (250, 480), (385, 480)]
    for nx, ny in nodes:
        d_draw.ellipse((nx-12, ny-12, nx+12, ny+12), fill=(*sage, 80))
        d_draw.ellipse((nx-5, ny-5, nx+5, ny+5), fill=(*bright_sage, 180))
    glow_blurred = glow_layer.filter(ImageFilter.GaussianBlur(6))
    awakening = Image.alpha_composite(awakening, glow_blurred)
    awakening.save(os.path.join(out_dir, 'awakening.png'), 'PNG')
    print('Generated awakening.png')

    # Seed positions for growing, thriving, transcendent
    # Key anatomical hubs within the brain bbox (143, 190, 881, 834)
    frontal = [(280, 380), (320, 320), (380, 280), (260, 460), (340, 440), (390, 485)]
    parietal = [(480, 260), (550, 280), (620, 320), (500, 360), (580, 380)]
    occipital = [(700, 380), (740, 450), (680, 480), (720, 520)]
    temporal = [(460, 500), (540, 520), (620, 530), (480, 580), (560, 600)]

    all_network_nodes = frontal + parietal + occipital + temporal

    # 3. GROWING: More connected neural pathways, balanced sage & lavender
    growing = base_img.copy()
    g_layer = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    g_draw = ImageDraw.Draw(g_layer)

    g_nodes = frontal + [(480, 260), (550, 280), (500, 360), (460, 500), (540, 520)]
    # Draw connections
    for i in range(len(g_nodes) - 1):
        x1, y1 = g_nodes[i]
        x2, y2 = g_nodes[i + 1]
        dist = math.hypot(x2 - x1, y2 - y1)
        if dist < 160:
            color = sage if i % 2 == 0 else lavender
            g_draw.line((x1, y1, x2, y2), fill=(*color, 120), width=3)

    # Draw node glows
    for i, (nx, ny) in enumerate(g_nodes):
        color = sage if i % 2 == 0 else lavender
        g_draw.ellipse((nx-18, ny-18, nx+18, ny+18), fill=(*color, 70))
        g_draw.ellipse((nx-8, ny-8, nx+8, ny+8), fill=(*color, 160))
        g_draw.ellipse((nx-3, ny-3, nx+3, ny+3), fill=(*white, 220))

    g_blurred = g_layer.filter(ImageFilter.GaussianBlur(3))
    # Mask to keep inside brain
    g_final = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    g_final.paste(g_blurred, (0, 0), brain_mask)
    growing = Image.alpha_composite(growing, g_final)
    growing.save(os.path.join(out_dir, 'growing.png'), 'PNG')
    print('Generated growing.png')

    # 4. THRIVING: Dense, organized neural network with confident sage & teal
    thriving = base_img.copy()
    t_layer = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    t_draw = ImageDraw.Draw(t_layer)

    t_nodes = all_network_nodes
    for i in range(len(t_nodes)):
        for j in range(i + 1, len(t_nodes)):
            x1, y1 = t_nodes[i]
            x2, y2 = t_nodes[j]
            dist = math.hypot(x2 - x1, y2 - y1)
            if dist < 140:
                color = sage if (i + j) % 3 == 0 else (teal if (i + j) % 3 == 1 else lavender)
                t_draw.line((x1, y1, x2, y2), fill=(*color, 140), width=3)

    for i, (nx, ny) in enumerate(t_nodes):
        color = sage if i % 3 == 0 else (teal if i % 3 == 1 else lavender)
        t_draw.ellipse((nx-24, ny-24, nx+24, ny+24), fill=(*color, 90))
        t_draw.ellipse((nx-10, ny-10, nx+10, ny+10), fill=(*color, 200))
        t_draw.ellipse((nx-4, ny-4, nx+4, ny+4), fill=(*white, 240))

    t_blurred = t_layer.filter(ImageFilter.GaussianBlur(3))
    t_final = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    t_final.paste(t_blurred, (0, 0), brain_mask)
    thriving = Image.alpha_composite(thriving, t_final)
    thriving.save(os.path.join(out_dir, 'thriving.png'), 'PNG')
    print('Generated thriving.png')

    # 5. TRANSCENDENT: Full radiant neural network with a subtle surrounding aura
    transcendent = base_img.copy()
    
    # Outer subtle aura
    aura_layer = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    a_draw = ImageDraw.Draw(aura_layer)
    # Draw soft aura using brain mask expanded
    expanded_mask = brain_mask.filter(ImageFilter.GaussianBlur(25))
    aura_color = Image.new('RGBA', (width, height), (*sage, 90))
    aura_layer.paste(aura_color, (0, 0), expanded_mask)

    # Neural network layer
    tr_layer = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    tr_draw = ImageDraw.Draw(tr_layer)

    # Full mesh of connections
    for i in range(len(t_nodes)):
        for j in range(i + 1, len(t_nodes)):
            x1, y1 = t_nodes[i]
            x2, y2 = t_nodes[j]
            dist = math.hypot(x2 - x1, y2 - y1)
            if dist < 170:
                color = bright_sage if (i + j) % 2 == 0 else teal
                tr_draw.line((x1, y1, x2, y2), fill=(*color, 180), width=4)

    for i, (nx, ny) in enumerate(t_nodes):
        color = bright_sage if i % 2 == 0 else lavender
        tr_draw.ellipse((nx-30, ny-30, nx+30, ny+30), fill=(*color, 110))
        tr_draw.ellipse((nx-14, ny-14, nx+14, ny+14), fill=(*color, 220))
        tr_draw.ellipse((nx-5, ny-5, nx+5, ny+5), fill=(*white, 255))

    tr_blurred = tr_layer.filter(ImageFilter.GaussianBlur(3))
    tr_final = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    tr_final.paste(tr_blurred, (0, 0), brain_mask)

    # Composite: aura behind brain, then radiant neural network on top
    result = Image.alpha_composite(aura_layer, base_img)
    result = Image.alpha_composite(result, tr_final)
    result.save(os.path.join(out_dir, 'transcendent.png'), 'PNG')
    print('Generated transcendent.png')

if __name__ == '__main__':
    create_brain_stages()
