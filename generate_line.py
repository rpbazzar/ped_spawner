# ================================================================
# PED SPAWNER — LINE GENERATOR
# ----------------------------------------------------------------
# Peds ko ek SEEDHI line me EQUAL gap ke saath generate karta hai
# aur seedhe peds.lua me likh deta hai. Manually calculate karne ki
# zaroorat nahi — bas neeche SETTINGS badlo aur run karo:
#     python generate_line.py
# ================================================================
import os
import math

# ---------------- SETTINGS (yahan change karo) ----------------
START   = (-1059.611, -3203.711, 12.944)   # pehla ped / grid ka corner (x, y, z)
HEADING = 149.920                          # gizmo se aaya heading
SPACING = 1.2                              # ek row me do peds ka gap (meters)

# LAYOUT — "grid" (rows me, compact) ya "line" (ek lambi line)
#   Bahut saare peds ke liye "grid" best hai (terrain problem nahi).
LAYOUT      = "line"
COLS        = 25                           # ek row me kitne peds (grid mode)
ROW_SPACING = 1.5                          # do rows ke beech ka gap (meters)

# LINE ki DIRECTION kaise decide ho (line white line ko follow kare):
#   "two_point" -> START se DIR_POINT tak (DONO white line par) -> PERFECT follow [BEST]
#   "bearing"   -> LINE_BEARING degree (white line ka apna angle, CodeWalker se)
#   "perp"      -> heading ke perpendicular (side-by-side row)
#   "along"     -> heading ke saath (queue)
#   "fixed"     -> neeche FIXED_DIR
DIR_SOURCE = "bearing"               # gizmo ke RED axis ko white line pe align kiya

# white line par DOOSRA point (sirf DIR_SOURCE = "two_point" ke liye)
DIR_POINT  = (-965.00, -3470.00)

LINE_BEARING = 149.920               # gizmo se aaya bearing
FIXED_DIR    = (-0.86880, 0.49517)   # sirf DIR_SOURCE = "fixed" ke liye

# Line kis gizmo AXIS ke saath jaye:
#   "red"   -> RED axis (forward) ke saath
#   "green" -> GREEN axis (perpendicular) ke saath  [tu ne green base samjha tha]
LINE_AXIS = "green"

# Peds ka MUH (facing):
#   FACE_ACROSS = True  -> line ke PERPENDICULAR (side-by-side, HORIZONTAL row) [chahiye ye]
#   FACE_ACROSS = False -> line ke ALONG (queue, verticle) -> HEADING use hoga
#   FACE_FLIP           -> across facing ka side ulta karne ke liye (True/False)
FACE_ACROSS = True
FACE_FLIP   = False

# MODELS kahan se aaye?
#   FROM_CONFIG = True  -> config.lua ke Config.Peds se SAARE peds (recommended)
#   FROM_CONFIG = False -> neeche MANUAL_MODELS list use hogi
FROM_CONFIG = True
CONFIG_FILE = "config.lua"

MANUAL_MODELS = [
    "cs_amandatownley",
    "a_f_y_yoga_01",
    "a_f_y_vinewood_01",
]
# --------------------------------------------------------------

import re

def load_models_from_config(cfg_path):
    """config.lua ke Config.Peds = { ... } block se saare model naam nikaalo."""
    with open(cfg_path, "r", encoding="utf-8") as f:
        text = f.read()
    # Config.Peds ke baad wala hissa lo (uske pehle ke config strings ignore)
    idx = text.find("Config.Peds")
    if idx == -1:
        return []
    block = text[idx:]
    peds = []
    for line in block.splitlines():
        s = line.strip()
        if s.startswith("--") or s == "":
            continue                       # comment / khaali line skip
        m = re.search(r'["\']([^"\']+)["\']', s)
        if m:
            peds.append(m.group(1))
    return peds

here = os.path.dirname(os.path.abspath(__file__))

if FROM_CONFIG:
    MODELS = load_models_from_config(os.path.join(here, CONFIG_FILE))
    print("config.lua se {} peds mile.".format(len(MODELS)))
else:
    MODELS = MANUAL_MODELS

# Direction vectors (heading ke hisaab se)
rad = math.radians(HEADING)
right = (-math.cos(rad), -math.sin(rad))   # side-by-side (row ki direction)
back  = ( math.sin(rad), -math.cos(rad))   # peeche ki taraf (agli row yahan)

# Har ped ka coord banao
rows = []
if LAYOUT == "grid":
    # Grid: har row me COLS peds, phir agli row ROW_SPACING peeche
    for i, model in enumerate(MODELS):
        col = i % COLS
        row = i // COLS
        x = START[0] + right[0] * SPACING * col + back[0] * ROW_SPACING * row
        y = START[1] + right[1] * SPACING * col + back[1] * ROW_SPACING * row
        z = START[2]
        rows.append('    {{ model = "{}", coords = vector4({:.3f}, {:.3f}, {:.3f}, {:.3f}) }},'.format(
            model, x, y, z, HEADING))
else:
    # Line: ek hi seedhi line — direction DIR_SOURCE se
    if DIR_SOURCE == "two_point":
        dx = DIR_POINT[0] - START[0]
        dy = DIR_POINT[1] - START[1]
        d = math.hypot(dx, dy) or 1.0
        ux, uy = dx / d, dy / d                 # START -> DIR_POINT (white line follow)
    elif DIR_SOURCE == "bearing":
        b = math.radians(LINE_BEARING)
        ux, uy = -math.sin(b), math.cos(b)      # GTA bearing -> unit vector
    elif DIR_SOURCE == "along":
        ux, uy = -math.sin(rad), math.cos(rad)
    elif DIR_SOURCE == "perp":
        ux, uy = right
    else:  # "fixed"
        dx, dy = FIXED_DIR
        d = math.hypot(dx, dy) or 1.0
        ux, uy = dx / d, dy / d

    # RED axis -> GREEN axis (90° rotate) agar LINE_AXIS = "green"
    if LINE_AXIS == "green":
        ux, uy = uy, -ux

    # Peds ka facing (heading) — across (horizontal row) ya along (queue)
    if FACE_ACROSS:
        # line direction ke perpendicular -> side-by-side
        if FACE_FLIP:
            fx, fy = -uy, ux
        else:
            fx, fy = uy, -ux
        face = math.degrees(math.atan2(-fx, fy)) % 360.0   # direction -> GTA heading
    else:
        face = HEADING

    for i, model in enumerate(MODELS):
        x = START[0] + ux * SPACING * i
        y = START[1] + uy * SPACING * i
        z = START[2]
        rows.append('    {{ model = "{}", coords = vector4({:.3f}, {:.3f}, {:.3f}, {:.3f}) }},'.format(
            model, x, y, z, face))

if LAYOUT == "grid":
    n_rows = (len(MODELS) + COLS - 1) // COLS
    layout_desc = "GRID {}x{} | col-gap {}m, row-gap {}m".format(COLS, n_rows, SPACING, ROW_SPACING)
else:
    layout_desc = "LINE | gap {}m".format(SPACING)

content = (
    "-- ================================================================\n"
    "-- PED SPAWNER — SAVED PEDS  (auto-generated: generate_line.py)\n"
    "--   {} peds | {}\n"
    "--   settings badalne ke liye generate_line.py edit karke dobara run karo\n"
    "-- ================================================================\n"
    "return {{\n"
    "{}\n"
    "}}\n"
).format(len(MODELS), layout_desc, "\n".join(rows))

# peds.lua isi folder me likho
here = os.path.dirname(os.path.abspath(__file__))
out_path = os.path.join(here, "peds.lua")
with open(out_path, "w", encoding="utf-8") as f:
    f.write(content)

print(content)
print("=> {} peds peds.lua me likh diye (gap {}m).".format(len(MODELS), SPACING))
