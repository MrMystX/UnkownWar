#define CreateSystem
globalvar SYSTEMINIT;
SYSTEMINIT = true

//Mouse Functions
_MouseFunctions_ = object_add()
object_event_add(_MouseFunctions_, ev_create, 0, "mouse_init()")
object_event_add(_MouseFunctions_, ev_step, ev_step, "mouse_step()")
instance_create(mouse_x,mouse_y,_MouseFunctions_)

if error_occurred = true
{
return false
}
else
{
return true
}
