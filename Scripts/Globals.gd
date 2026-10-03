extends Node

#global vars

var jumpsleft = 4
var speedup = 60
var score = 0
var tempspeedupamount = 0

var showFPS = false
var DEBUG = true

var resolutions = {
	"3840x2160": Vector2i(3840,2160),
	"2560x1440": Vector2i(2560,1440),
	"1920x1080": Vector2i(1920,1080),
	"1366x768": Vector2i(1366,768),
	"1280x720": Vector2i(1280,720),
	"1440x900": Vector2i(1440,900),
	"1600x900": Vector2i(1600,900),
	"1152x648": Vector2i(1152,648),
	"1024x600": Vector2i(1024,600),
	"800x600": Vector2i(800,600)
}
