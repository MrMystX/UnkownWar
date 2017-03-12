#define mouse_init
globalvar mouse_xprevious, mouse_yprevious, mouse_pressedamount1;
globalvar mouse_pressedamount2, mouse_hspeed, mouse_vspeed, mouse_speed;
globalvar _MCW

_MCW = 0
mouse_xprevious = mouse_x
mouse_yprevious = mouse_y
mouse_pressedamount1 = 0
mouse_pressedamount2 = 0
mouse_hspeed = 0
mouse_vspeed = 0
mouse_speed = 0
#define mouse_step
mouse_vspeed = mouse_y - mouse_yprevious
mouse_hspeed = mouse_x - mouse_xprevious
mouse_speed = abs(mouse_vspeed) + abs(mouse_hspeed)

mouse_check_wheel()

if mouse_check_button_pressed(mb_left)
{
mouse_xprevious = mouse_x
mouse_yprevious = mouse_y
}

if mouse_check_button(mb_left)
{
mouse_pressedamount1 += 1
}

if mouse_check_button_released(mb_left)
{
mouse_pressedamount1 = 0
}

if mouse_check_button(mb_right)
{
mouse_pressedamount2 += 1
}

if mouse_check_button_released(mb_right)
{
mouse_pressedamount2 = 0
}
#define draw_mousewindow
//Argument0 = Outline
draw_rectangle(mouse_xprevious,mouse_yprevious,mouse_x,mouse_y,argument0)
#define draw_mousewindow_ex
//Argument0 = Color
//Argument1 = Alpha
//Argument2 = Outline
draw_set_color(argument0)
draw_set_alpha(argument1)
if argument2 = true 
{
draw_rectangle(mouse_xprevious,mouse_yprevious,mouse_x,mouse_y,1)
}
else
{
draw_rectangle(mouse_xprevious,mouse_yprevious,mouse_x,mouse_y,0)
}
draw_set_color(c_black)
draw_set_alpha(1)
#define mouse_scare
//argument0 = x
//argument1 = y
//argument2 = w
//argument3 = h
//[argument4] = Cursor
if mouse_x >= argument0 && mouse_x <= argument2 && mouse_y >= argument1 && mouse_y <= argument3
{
window_set_cursor(cr_none)
}
else
{
window_set_cursor(argument4)
}
#define mouse_position
//argument0 = x
//argument1 = y
//argument2 = w
//argument3 = h
if mouse_x >= argument0 && mouse_x <= argument2 && mouse_y >= argument1 && mouse_y <= argument4
return true;
else
return false;
#define mouse_direction
return point_direction(mouse_xprevious,mouse_yprevious,mouse_x,mouse_y)
#define mouse_hide
//argument0 = show
//[argument1] = mouse
if argument0 = true
{
window_set_cursor(cr_none)
}

if argument0 = false
{
window_set_cursor(argument1)
}
#define mouse_set_x
display_mouse_set(argument0,mouse_y);
#define mouse_set_y
display_mouse_set(mouse_x,argument0);
#define mouse_set_pos
display_mouse_set(argument0,argument1)
#define mouse_check_wheel
if (!variable_global_exists("_MWC")) {
  _MWC = object_add();
  object_event_add(_MWC,ev_create,0,"rolling = 0;");
  object_event_add(_MWC,ev_step,ev_step_begin,"rolling = -1;");
  object_event_add(_MWC,ev_mouse,ev_mouse_wheel_down,"rolling = 0;");
  object_event_add(_MWC,ev_mouse,ev_mouse_wheel_up,"rolling = 1;");
}

if (!instance_exists(_MWC)) {
  instance_create(0,0,_MWC);
}

return ((_MWC).rolling);
