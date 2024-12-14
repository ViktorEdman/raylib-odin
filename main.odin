package main

import "core:fmt"
import "core:time"
import rl "vendor:raylib"

window_width: i32 = 800
window_height: i32 = 600


Player :: struct {
	pos:               rl.Vector2,
	vel:               rl.Vector2,
	grounded:          bool,
	run_frame_timer:   f32,
	run_current_frame: int,
	run_frame_length:  f32,
}

player := Player{{f32(window_width) / 2, f32(window_height / 2)}, {}, false, 0, 0, 0}

main :: proc() {
	rl.SetConfigFlags({.MSAA_4X_HINT})
	rl.SetTargetFPS(75)
	rl.InitWindow(window_width, window_height, "Hello world")
	spriteSheet := rl.LoadTexture("./ninja-1-removebg-preview.png")
	spriteSource := rl.Rectangle{80, 170, 55, 55}
	player.run_frame_length = f32(0.1)
	for (!rl.WindowShouldClose()) {
		handleGravity()
		handleInput()
		handleBounds()
		rl.BeginDrawing()
		rl.ClearBackground(rl.Color{10, 80, 10, 255})
		rl.DrawTextureRec(spriteSheet, spriteSource, player.pos, rl.WHITE)
		rl.DrawFPS(10, 10)
		rl.EndDrawing()
	}
	rl.CloseWindow()


}

handleBounds :: proc() {
	h := f32(window_height)
	w := f32(window_width)
	if player.pos.y > h - 50 {
		player.pos.y = h - 50
		player.grounded = true
	}
	if player.pos.y < 0 {
		player.pos.y = h - 50
	}
	if player.pos.x > w {
		player.pos.x = 0
	}
	if player.pos.x < 0 {
		player.pos.x = w
	}
}

handleGravity :: proc() {
	player.vel.y += 2000 * rl.GetFrameTime()
}

handleInput :: proc() {
	frametime := rl.GetFrameTime()
	if (rl.IsKeyPressed(.Q)) {
		rl.CloseWindow()
	}
	if (rl.IsKeyDown(.D)) {
		player.vel.x = 400
	} else if (rl.IsKeyDown(.A)) {
		player.vel.x = -400
	} else {
		player.vel.x = 0
	}
	if (rl.IsKeyDown(.SPACE) && player.grounded) {
		player.vel.y = -900
		player.grounded = false
	}
	if (rl.IsMouseButtonDown(.LEFT)) {
		player.pos = rl.GetMousePosition()
		player.vel = 0
		player.grounded = false
	}
	player.pos += player.vel * frametime
}
