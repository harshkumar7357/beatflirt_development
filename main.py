import sys
from unittest.mock import MagicMock

# Mock darkdetect to avoid platform version detection crash on macOS in sandbox
mock_darkdetect = MagicMock()
mock_darkdetect.theme.return_value = "Dark"
mock_darkdetect.isDark.return_value = True
mock_darkdetect.isLight.return_value = False
sys.modules['darkdetect'] = mock_darkdetect

import tkinter as tk
import customtkinter as ctk
import math
import random
from collections import deque

# Color Palette
NEON_COLORS = {
    "Sun Yellow": "#FFD700",
    "Aqua Cyan": "#00F0FF",
    "Purple Haze": "#D000FF",
    "Matrix Green": "#39FF14",
    "Neon Red": "#FF3F3F",
    "Deep Orange": "#FF7F00",
    "Hot Pink": "#FF1493",
    "Space Gray": "#8A9EA7"
}

class GravityPoint:
    def __init__(self, name, x, y, mass=100.0, color="Sun Yellow", enabled=True, radius=14):
        self.name = name
        self.x = x
        self.y = y
        self.mass = mass
        self.color = color
        self.enabled = enabled
        self.radius = radius
        self.canvas_id = None
        self.glow_id = None
        self.text_id = None

class Particle:
    def __init__(self, x, y, vx, vy, size=2, color="#FFFFFF", max_trail=12):
        self.x = x
        self.y = y
        self.vx = vx
        self.vy = vy
        self.size = size
        self.color = color
        self.trail = deque(maxlen=max_trail)
        self.canvas_id = None
        self.trail_ids = []

class SpaceSimulatorApp(ctk.CTk):
    def __init__(self):
        super().__init__()
        
        self.title("Gravitational Orbit Simulator")
        self.geometry("1300x850")
        self.minsize(1100, 750)
        
        # State Variables
        self.is_playing = True
        self.time_speed = 1.0
        self.particle_count = 180
        self.particle_size = 2
        self.particle_color = "#E5ECF6"
        self.softening_factor = 20.0
        self.g_constant = 1.5
        self.trail_length = 10
        
        self.gravity_points = []
        self.particles = []
        self.dragged_point = None
        self.selected_point = None
        self.star_coords = []
        
        # Setup UI
        self.setup_ui()
        
        # Load Initial Default Preset (Solar System style)
        self.load_preset_solar_system()
        self.reset_particles()
        
        # Start Physics/Rendering Loop
        self.update_simulation()

    def setup_ui(self):
        self.grid_columnconfigure(0, weight=1)
        self.grid_columnconfigure(1, minsize=350, weight=0)
        self.grid_rowconfigure(0, weight=1)
        
        # Left Panel: Space Viewport
        self.canvas_container = ctk.CTkFrame(self, corner_radius=0, fg_color="#080810")
        self.canvas_container.grid(row=0, column=0, sticky="nsew", padx=0, pady=0)
        self.canvas_container.grid_rowconfigure(0, weight=1)
        self.canvas_container.grid_columnconfigure(0, weight=1)
        
        self.canvas = tk.Canvas(
            self.canvas_container, 
            bg="#030308", 
            highlightthickness=0,
            border=0
        )
        self.canvas.grid(row=0, column=0, sticky="nsew", padx=15, pady=15)
        
        # Canvas Bindings
        self.canvas.bind("<Button-1>", self.on_canvas_click)
        self.canvas.bind("<B1-Motion>", self.on_canvas_drag)
        self.canvas.bind("<ButtonRelease-1>", self.on_canvas_release)
        self.canvas.bind("<Configure>", self.on_canvas_resize)
        
        # Right Panel: Configuration Sidebar
        self.sidebar = ctk.CTkScrollableFrame(self, width=340, corner_radius=0, fg_color="#0F0F16")
        self.sidebar.grid(row=0, column=1, sticky="nsew", padx=0, pady=0)
        
        # Brand Header
        title_lbl = ctk.CTkLabel(
            self.sidebar, 
            text="ORBIT SIMULATOR", 
            font=ctk.CTkFont(family="Courier New", size=24, weight="bold"),
            text_color="#00F0FF"
        )
        title_lbl.pack(pady=(20, 2), padx=20, fill="x")
        
        subtitle_lbl = ctk.CTkLabel(
            self.sidebar, 
            text="N-Body Gravity & Orbital Physics", 
            font=ctk.CTkFont(family="Arial", size=12, slant="italic"),
            text_color="#6B7A8A"
        )
        subtitle_lbl.pack(pady=(0, 20), padx=20, fill="x")
        
        # Section 1: Playback Controls
        self.create_section_header("SYSTEM CONTROLS")
        
        self.btn_play = ctk.CTkButton(
            self.sidebar, 
            text="PAUSE",
            command=self.toggle_play,
            fg_color="#00F0FF",
            text_color="#000000",
            font=ctk.CTkFont(size=14, weight="bold"),
            hover_color="#00C4D1"
        )
        self.btn_play.pack(pady=10, padx=20, fill="x")
        
        btn_grid = ctk.CTkFrame(self.sidebar, fg_color="transparent")
        btn_grid.pack(pady=5, padx=20, fill="x")
        btn_grid.grid_columnconfigure(0, weight=1)
        btn_grid.grid_columnconfigure(1, weight=1)
        
        btn_reset = ctk.CTkButton(
            btn_grid, 
            text="Reset Particles", 
            command=self.reset_particles,
            fg_color="#2A2A38",
            hover_color="#3D3D52",
            text_color="#FFFFFF"
        )
        btn_reset.grid(row=0, column=0, padx=(0, 5), sticky="ew")
        
        btn_clear = ctk.CTkButton(
            btn_grid, 
            text="Clear Gravity", 
            command=self.clear_gravity_points,
            fg_color="#FF3F3F",
            hover_color="#D12F2F",
            text_color="#FFFFFF"
        )
        btn_clear.grid(row=0, column=1, padx=(5, 0), sticky="ew")
        
        # Sliders: Speed and G
        self.create_slider_row("Simulation Speed", 0.1, 4.0, self.time_speed, self.change_speed, "speed_lbl")
        self.create_slider_row("Gravity Constant (G)", 0.1, 5.0, self.g_constant, self.change_g, "g_lbl")
        
        # Section 2: Particles Configuration
        self.create_section_header("PARTICLE CONFIGURATION")
        self.create_slider_row("Particle Count", 10, 500, self.particle_count, self.change_count, "count_lbl", is_int=True)
        self.create_slider_row("Particle Size", 1, 6, self.particle_size, self.change_size, "size_lbl", is_int=True)
        self.create_slider_row("Trail Length", 2, 30, self.trail_length, self.change_trail_length, "trail_lbl", is_int=True)
        
        # Section 3: Presets
        self.create_section_header("PRESET SCENARIOS")
        self.preset_var = ctk.StringVar(value="Solar System")
        preset_menu = ctk.CTkOptionMenu(
            self.sidebar,
            values=["Solar System", "3-Body Chaos", "Binary Star System", "Black Hole", "Empty Space"],
            variable=self.preset_var,
            command=self.apply_preset,
            fg_color="#1C1C24",
            button_color="#2A2A38",
            button_hover_color="#3D3D52"
        )
        preset_menu.pack(pady=10, padx=20, fill="x")
        
        # Section 4: Gravity Points List
        self.create_section_header("GRAVITY POINTS LIST")
        self.gravity_list_frame = ctk.CTkFrame(self.sidebar, fg_color="#1A1A22", corner_radius=8)
        self.gravity_list_frame.pack(fill="x", padx=20, pady=10)

        # Section 5: Gravity Point Editor (Dynamic / Selected)
        self.create_section_header("SELECTED GRAVITY POINT")
        
        self.selected_panel = ctk.CTkFrame(self.sidebar, fg_color="#181822", corner_radius=8)
        self.selected_panel.pack(fill="x", padx=20, pady=10)
        self.build_selected_panel_ui()

        # Section 6: Add Gravity Point Form
        self.create_section_header("ADD GRAVITY POINT")
        self.build_add_gravity_ui()
        
    def create_section_header(self, text):
        lbl = ctk.CTkLabel(
            self.sidebar, 
            text=text, 
            font=ctk.CTkFont(size=11, weight="bold"),
            text_color="#64788C"
        )
        lbl.pack(anchor="w", pady=(20, 6), padx=20)
        
    def create_slider_row(self, title, from_val, to_val, start_val, callback, attr_name, is_int=False):
        frame = ctk.CTkFrame(self.sidebar, fg_color="transparent")
        frame.pack(fill="x", padx=20, pady=(4, 0))
        
        lbl_title = ctk.CTkLabel(frame, text=title, font=ctk.CTkFont(size=12), text_color="#A4B3C6")
        lbl_title.pack(side="left")
        
        fmt = "{:.0f}" if is_int else "{:.2f}"
        lbl_val = ctk.CTkLabel(frame, text=fmt.format(start_val), font=ctk.CTkFont(size=12, weight="bold"), text_color="#00F0FF")
        lbl_val.pack(side="right")
        setattr(self, attr_name, lbl_val)
        
        slider = ctk.CTkSlider(
            self.sidebar, 
            from_=from_val, 
            to=to_val, 
            number_of_steps=100 if not is_int else int(to_val - from_val),
            command=lambda val: self.handle_slider(val, callback, attr_name, is_int)
        )
        slider.set(start_val)
        slider.pack(fill="x", padx=20, pady=(0, 10))
        
    def handle_slider(self, val, callback, attr_name, is_int):
        display_val = int(val) if is_int else round(val, 2)
        lbl = getattr(self, attr_name)
        fmt = "{}" if is_int else "{:.2f}"
        lbl.configure(text=fmt.format(display_val))
        callback(display_val)

    def change_speed(self, val): self.time_speed = val
    def change_g(self, val): self.g_constant = val
    def change_count(self, val):
        self.particle_count = int(val)
        self.reset_particles()
    def change_size(self, val):
        self.particle_size = int(val)
    def change_trail_length(self, val):
        self.trail_length = int(val)
        for p in self.particles:
            new_trail = deque(p.trail, maxlen=self.trail_length)
            p.trail = new_trail

    def toggle_play(self):
        self.is_playing = not self.is_playing
        if self.is_playing:
            self.btn_play.configure(text="PAUSE", fg_color="#00F0FF", text_color="#000000")
        else:
            self.btn_play.configure(text="PLAY", fg_color="#2ECC71", text_color="#FFFFFF")
            
    def clear_gravity_points(self):
        for gp in self.gravity_points:
            if gp.canvas_id:
                self.canvas.delete(gp.canvas_id)
            if gp.glow_id:
                self.canvas.delete(gp.glow_id)
            if gp.text_id:
                self.canvas.delete(gp.text_id)
        self.gravity_points.clear()
        self.rebuild_gravity_ui_list()

    def rebuild_gravity_ui_list(self):
        # Clear child widgets
        for widget in self.gravity_list_frame.winfo_children():
            widget.destroy()
            
        if not self.gravity_points:
            no_pts_lbl = ctk.CTkLabel(
                self.gravity_list_frame, 
                text="No gravity points active", 
                text_color="#8F8FA0",
                font=ctk.CTkFont(size=12, slant="italic")
            )
            no_pts_lbl.pack(pady=15)
            return
            
        for idx, gp in enumerate(self.gravity_points):
            gp_frame = ctk.CTkFrame(self.gravity_list_frame, fg_color="#24242E", corner_radius=6)
            gp_frame.pack(fill="x", padx=8, pady=5)
            
            # Dot representing color
            color_hex = NEON_COLORS.get(gp.color, "#00F0FF")
            color_dot = tk.Canvas(gp_frame, width=12, height=12, bg="#24242E", highlightthickness=0)
            color_dot.create_oval(1, 1, 11, 11, fill=color_hex, outline="")
            color_dot.pack(side="left", padx=(10, 5))
            
            # Title & Mass Info
            title_lbl = ctk.CTkLabel(
                gp_frame, 
                text=f"{gp.name} ({int(gp.mass)}M)", 
                font=ctk.CTkFont(size=12, weight="bold"),
                text_color="#FFFFFF"
            )
            title_lbl.pack(side="left", padx=5)

    def build_selected_panel_ui(self):
        for widget in self.selected_panel.winfo_children():
            widget.destroy()
            
        if not self.selected_point:
            lbl = ctk.CTkLabel(
                self.selected_panel, 
                text="Click or drag a gravity point\nin space to edit its values.",
                text_color="#6B7A8A",
                font=ctk.CTkFont(size=12, slant="italic")
            )
            lbl.pack(pady=20)
            return

        # Name label
        name_lbl = ctk.CTkLabel(
            self.selected_panel,
            text=f"Editing: {self.selected_point.name}",
            font=ctk.CTkFont(size=14, weight="bold"),
            text_color=NEON_COLORS.get(self.selected_point.color, "#FFFFFF")
        )
        name_lbl.pack(pady=(12, 4), padx=15, anchor="w")
        
        # Mass Control Slider
        mass_frame = ctk.CTkFrame(self.selected_panel, fg_color="transparent")
        mass_frame.pack(fill="x", padx=15, pady=4)
        ctk.CTkLabel(mass_frame, text="Mass", font=ctk.CTkFont(size=12), text_color="#A4B3C6").pack(side="left")
        
        mass_val_lbl = ctk.CTkLabel(
            mass_frame, 
            text=f"{int(self.selected_point.mass)}", 
            font=ctk.CTkFont(size=12, weight="bold"), 
            text_color="#00F0FF"
        )
        mass_val_lbl.pack(side="right")
        
        def update_selected_mass(val):
            if self.selected_point:
                self.selected_point.mass = float(val)
                mass_val_lbl.configure(text=f"{int(val)}")
                self.draw_gravity_points()
                
        mass_slider = ctk.CTkSlider(
            self.selected_panel,
            from_=10,
            to=2000,
            number_of_steps=199,
            command=update_selected_mass
        )
        mass_slider.set(self.selected_point.mass)
        mass_slider.pack(fill="x", padx=15, pady=(0, 10))

        # Color Selector Row
        color_frame = ctk.CTkFrame(self.selected_panel, fg_color="transparent")
        color_frame.pack(fill="x", padx=15, pady=4)
        ctk.CTkLabel(color_frame, text="Color", font=ctk.CTkFont(size=12), text_color="#A4B3C6").pack(side="left")
        
        def update_selected_color(col):
            if self.selected_point:
                self.selected_point.color = col
                self.draw_gravity_points()
                self.build_selected_panel_ui()
                
        color_opt = ctk.CTkOptionMenu(
            color_frame,
            values=list(NEON_COLORS.keys()),
            command=update_selected_color,
            width=120,
            height=24,
            fg_color="#1C1C24",
            button_color="#2A2A38"
        )
        color_opt.set(self.selected_point.color)
        color_opt.pack(side="right")

        # Toggle Active
        def toggle_active():
            if self.selected_point:
                self.selected_point.enabled = not self.selected_point.enabled
                self.draw_gravity_points()
                
        toggle_cb = ctk.CTkCheckBox(
            self.selected_panel,
            text="Active (Exerts Gravity)",
            command=toggle_active,
            font=ctk.CTkFont(size=12),
            text_color="#A4B3C6"
        )
        toggle_cb.pack(anchor="w", padx=15, pady=10)
        if self.selected_point.enabled:
            toggle_cb.select()
        else:
            toggle_cb.deselect()

        # Delete Button
        def delete_selected():
            if self.selected_point in self.gravity_points:
                self.gravity_points.remove(self.selected_point)
                if self.selected_point.canvas_id:
                    self.canvas.delete(self.selected_point.canvas_id)
                if self.selected_point.glow_id:
                    self.canvas.delete(self.selected_point.glow_id)
                if self.selected_point.text_id:
                    self.canvas.delete(self.selected_point.text_id)
                self.selected_point = None
                self.draw_gravity_points()
                self.build_selected_panel_ui()

        delete_btn = ctk.CTkButton(
            self.selected_panel,
            text="Delete Gravity Point",
            command=delete_selected,
            fg_color="#FF3F3F",
            hover_color="#D12F2F",
            text_color="#FFFFFF"
        )
        delete_btn.pack(fill="x", padx=15, pady=(5, 12))

    def build_add_gravity_ui(self):
        add_frame = ctk.CTkFrame(self.sidebar, fg_color="#181822", corner_radius=8)
        add_frame.pack(fill="x", padx=20, pady=10)
        
        ctk.CTkLabel(add_frame, text="Name", font=ctk.CTkFont(size=12), text_color="#A4B3C6").pack(anchor="w", padx=15, pady=(10, 2))
        name_entry = ctk.CTkEntry(add_frame, placeholder_text="e.g. Planet X", height=28)
        name_entry.pack(fill="x", padx=15, pady=(0, 10))
        
        ctk.CTkLabel(add_frame, text="Initial Mass", font=ctk.CTkFont(size=12), text_color="#A4B3C6").pack(anchor="w", padx=15, pady=(0, 2))
        mass_slider = ctk.CTkSlider(add_frame, from_=10, to=2000, number_of_steps=199)
        mass_slider.set(150)
        mass_slider.pack(fill="x", padx=15, pady=(0, 10))
        
        ctk.CTkLabel(add_frame, text="Color Preset", font=ctk.CTkFont(size=12), text_color="#A4B3C6").pack(anchor="w", padx=15, pady=(0, 2))
        color_menu = ctk.CTkOptionMenu(
            add_frame,
            values=list(NEON_COLORS.keys()),
            fg_color="#1C1C24",
            button_color="#2A2A38"
        )
        color_menu.set("Aqua Cyan")
        color_menu.pack(fill="x", padx=15, pady=(0, 15))
        
        def submit_new_point():
            name = name_entry.get().strip() or f"Point {len(self.gravity_points) + 1}"
            mass = mass_slider.get()
            color = color_menu.get()
            
            # Spawn at random center position
            width = self.canvas.winfo_width() or 800
            height = self.canvas.winfo_height() or 600
            rx = width / 2 + random.randint(-100, 100)
            ry = height / 2 + random.randint(-100, 100)
            
            gp = GravityPoint(name, rx, ry, mass=mass, color=color)
            self.gravity_points.append(gp)
            self.selected_point = gp
            self.draw_gravity_points()
            self.build_selected_panel_ui()
            
        add_btn = ctk.CTkButton(
            add_frame,
            text="Add Custom Gravity Point",
            command=submit_new_point,
            fg_color="#00F0FF",
            text_color="#000000",
            hover_color="#00C4D1",
            font=ctk.CTkFont(weight="bold")
        )
        add_btn.pack(fill="x", padx=15, pady=(5, 15))

    def on_canvas_click(self, event):
        click_radius = 20
        # Check if clicked on/near a point to drag/select
        for gp in self.gravity_points:
            dist = math.hypot(event.x - gp.x, event.y - gp.y)
            if dist < click_radius:
                self.dragged_point = gp
                self.selected_point = gp
                self.build_selected_panel_ui()
                return
                
        # Clicked empty space: Create a new gravity point at mouse click (Default mass: 100)
        name = f"Point {len(self.gravity_points) + 1}"
        color_keys = list(NEON_COLORS.keys())
        color = color_keys[len(self.gravity_points) % len(color_keys)]
        
        gp = GravityPoint(name, event.x, event.y, mass=100.0, color=color)
        self.gravity_points.append(gp)
        self.selected_point = gp
        self.draw_gravity_points()
        self.build_selected_panel_ui()
        
    def on_canvas_drag(self, event):
        if self.dragged_point:
            self.dragged_point.x = event.x
            self.dragged_point.y = event.y
            self.draw_gravity_points()
            
    def on_canvas_release(self, event):
        self.dragged_point = None

    def on_canvas_resize(self, event):
        self.draw_background_stars()
        
    def draw_background_stars(self):
        self.canvas.delete("star")
        width = self.canvas.winfo_width() or 800
        height = self.canvas.winfo_height() or 600
        
        if not self.star_coords or len(self.star_coords) < 120:
            self.star_coords = []
            for _ in range(120):
                x = random.randint(0, width + 500)
                y = random.randint(0, height + 500)
                brightness = random.choice(["#1A1A2A", "#2F2F4A", "#4E4E6D", "#767699"])
                self.star_coords.append((x, y, brightness))
                
        for x, y, b in self.star_coords:
            self.canvas.create_line(x, y, x+1, y, fill=b, tags="star")

    def load_preset_solar_system(self):
        self.clear_gravity_points()
        width = self.canvas.winfo_width() or 800
        height = self.canvas.winfo_height() or 600
        cx, cy = width / 2, height / 2
        
        # Sun
        self.gravity_points.append(GravityPoint("Sun", cx, cy, mass=350.0, color="Sun Yellow", radius=18))
        # Inner Planet
        self.gravity_points.append(GravityPoint("Earth", cx + 180, cy, mass=150.0, color="Aqua Cyan", radius=12))
        # Outer Moon
        self.gravity_points.append(GravityPoint("Luna", cx + 180, cy + 45, mass=15.0, color="Space Gray", radius=8))
        
        self.draw_gravity_points()
        
    def apply_preset(self, preset_name):
        self.clear_gravity_points()
        width = self.canvas.winfo_width() or 800
        height = self.canvas.winfo_height() or 600
        cx, cy = width / 2, height / 2
        
        if preset_name == "Solar System":
            self.load_preset_solar_system()
        elif preset_name == "3-Body Chaos":
            self.gravity_points.append(GravityPoint("Star A", cx - 140, cy - 80, mass=200.0, color="Neon Red"))
            self.gravity_points.append(GravityPoint("Star B", cx + 140, cy - 80, mass=200.0, color="Purple Haze"))
            self.gravity_points.append(GravityPoint("Star C", cx, cy + 130, mass=200.0, color="Matrix Green"))
        elif preset_name == "Binary Star System":
            self.gravity_points.append(GravityPoint("Alpha", cx - 90, cy, mass=220.0, color="Deep Orange", radius=15))
            self.gravity_points.append(GravityPoint("Beta", cx + 90, cy, mass=220.0, color="Aqua Cyan", radius=15))
        elif preset_name == "Black Hole":
            self.gravity_points.append(GravityPoint("Singularity", cx, cy, mass=550.0, color="Hot Pink", radius=16))
            
        self.selected_point = None
        self.draw_gravity_points()
        self.build_selected_panel_ui()
        self.reset_particles()
        
    def draw_gravity_points(self):
        self.canvas.delete("gravity_element")
        for gp in self.gravity_points:
            color_hex = NEON_COLORS.get(gp.color, "#00F0FF")
            
            # Glow Rings (Double layer)
            if gp.enabled:
                self.canvas.create_oval(
                    gp.x - gp.radius - 8, gp.y - gp.radius - 8, 
                    gp.x + gp.radius + 8, gp.y + gp.radius + 8,
                    outline=color_hex, width=1, tags="gravity_element"
                )
                
            # Main Body
            gp.canvas_id = self.canvas.create_oval(
                gp.x - gp.radius, gp.y - gp.radius, 
                gp.x + gp.radius, gp.y + gp.radius,
                fill=color_hex if gp.enabled else "#22222D", 
                outline="#FFFFFF" if gp == self.selected_point else "#555566", 
                width=2, tags="gravity_element"
            )
            
            # Name Tag
            gp.text_id = self.canvas.create_text(
                gp.x, gp.y - gp.radius - 12,
                text=f"{gp.name} ({int(gp.mass)}M)",
                fill="#FFFFFF" if gp.enabled else "#8F8FA0",
                font=("Helvetica", 9, "bold"),
                tags="gravity_element"
            )

    def reset_particles(self):
        # Clear particles
        for p in self.particles:
            if p.canvas_id:
                self.canvas.delete(p.canvas_id)
            for tid in p.trail_ids:
                self.canvas.delete(tid)
                
        self.particles.clear()
        
        width = self.canvas.winfo_width() or 800
        height = self.canvas.winfo_height() or 600
        cx, cy = width / 2, height / 2
        
        # Generate new particles with standard orbital vectors
        for _ in range(self.particle_count):
            angle = random.uniform(0, 2 * math.pi)
            distance = random.uniform(30, min(width, height) * 0.4)
            x = cx + math.cos(angle) * distance
            y = cy + math.sin(angle) * distance
            
            # Velocity: orbital direction perpendicular to center
            speed = random.uniform(1.2, 3.8)
            vx = -math.sin(angle) * speed
            vy = math.cos(angle) * speed
            
            p = Particle(x, y, vx, vy, size=self.particle_size, color=self.particle_color, max_trail=self.trail_length)
            p.canvas_id = self.canvas.create_oval(
                x - p.size, y - p.size, x + p.size, y + p.size,
                fill=p.color, outline=""
            )
            self.particles.append(p)
            
    def update_simulation(self):
        if self.is_playing:
            dt = 0.6 * self.time_speed
            active_gps = [gp for gp in self.gravity_points if gp.enabled]
            
            width = self.canvas.winfo_width() or 800
            height = self.canvas.winfo_height() or 600
            
            for p in self.particles:
                # Store trail position
                p.trail.append((p.x, p.y))
                
                # Apply gravitational pull from all active gravity sources
                ax, ay = 0.0, 0.0
                for gp in active_gps:
                    dx = gp.x - p.x
                    dy = gp.y - p.y
                    dist_sq = dx*dx + dy*dy
                    dist = math.sqrt(dist_sq)
                    
                    if dist > 1.0:
                        # Gravitational acceleration: a = G * M / (r^2 + softening^2)
                        acc = (self.g_constant * gp.mass) / (dist_sq + self.softening_factor**2)
                        ax += acc * (dx / dist)
                        ay += acc * (dy / dist)
                        
                # Update velocity and position
                p.vx += ax * dt
                p.vy += ay * dt
                p.x += p.vx * dt
                p.y += p.vy * dt
                
                # Wrap-around boundary conditions
                if p.x < 0: p.x = width
                elif p.x > width: p.x = 0
                if p.y < 0: p.y = height
                elif p.y > height: p.y = 0
                
                # Redraw particle
                if p.canvas_id:
                    self.canvas.coords(
                        p.canvas_id,
                        p.x - p.size, p.y - p.size,
                        p.x + p.size, p.y + p.size
                    )
                
                # Redraw trails using lines
                for tid in p.trail_ids:
                    self.canvas.delete(tid)
                p.trail_ids.clear()
                
                if len(p.trail) > 1:
                    for i in range(len(p.trail) - 1):
                        x1, y1 = p.trail[i]
                        x2, y2 = p.trail[i+1]
                        # Interpolate opacity/brightness along trail
                        alpha = int(255 * (i / len(p.trail)))
                        # Since standard Tkinter canvas lines don't support true RGBA transparency directly,
                        # we shade the color towards dark background (deep indigo/grayish blue)
                        color_mix = f"#{alpha:02x}{alpha:02x}{alpha:02x}"
                        
                        tid = self.canvas.create_line(
                            x1, y1, x2, y2,
                            fill=color_mix,
                            width=1
                        )
                        p.trail_ids.append(tid)

        # Loop at 60 FPS
        self.after(16, self.update_simulation)

if __name__ == "__main__":
    app = SpaceSimulatorApp()
    app.mainloop()
