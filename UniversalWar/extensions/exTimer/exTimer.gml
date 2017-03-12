#define ex_timer_count
///ex_timer_count()

var _list = obj_ex_timer._ex_timers;

if (not ds_exists(_list, ds_type_grid)) {
    return 0;
}

if (ds_grid_height(_list) < 2) {

    if (ds_grid_get(_list, 0, 0) == "") {
        return 0;
    }

}

return ds_grid_height(_list);


#define ex_timer_create
///ex_timer_create(name, duration, speed, loop, script, classes)

var _list              = obj_ex_timer._ex_timers;
var _list_max_size     = 10;
var _autoincrement     = 0;
var _timer_name        = argument[0];
var _timer_duration    = argument[1];
var _timer_speed       = 1;
var _timer_loop        = false;
var _timer_script      = -1;
var _timer_classes     = "";

if (argument_count >= 3) {
    _timer_speed = argument[2];
}

if (argument_count >= 4) {
    _timer_loop = argument[3];
}

if (argument_count >= 5) {
    _timer_script = argument[4];
}

// create or update the timer list
if (ds_exists(_list, ds_type_grid)) {
    
    // workaround
    if (ds_grid_get(_list, 0, 0) == "") {
    
    } else {
    
    ds_grid_resize(_list, _list_max_size, ds_grid_height(_list)+1);
    _autoincrement = ds_grid_height(_list)-1;
    
    }

} else {
    obj_ex_timer._ex_timers = ds_grid_create(_list_max_size, 0);
    _list = obj_ex_timer._ex_timers;
    ds_grid_resize(_list, _list_max_size, ds_grid_height(_list)+1);
}


// check if timer with the same name exists
var _y = ds_grid_value_y(_list, 0, 0, ds_grid_width(_list), ds_grid_height(_list), string( _timer_name ));
if (_y > -1) {
    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, timer name "'+string( _timer_name )+'" already exists, timer names must be unique');
    }
    return -1;
}


// add timer to the list
ds_grid_set(_list, 0,  _autoincrement, _timer_name);     // name
ds_grid_set(_list, 1,  _autoincrement, 0);               // position
ds_grid_set(_list, 2,  _autoincrement, _timer_speed);    // speed
ds_grid_set(_list, 3,  _autoincrement, 0);               // length
ds_grid_set(_list, 4,  _autoincrement, false);           // is playing
ds_grid_set(_list, 5,  _autoincrement, false);           // is pause
ds_grid_set(_list, 6,  _autoincrement, false);           // sync
ds_grid_set(_list, 7,  _autoincrement, _timer_script);   // script
ds_grid_set(_list, 8,  _autoincrement, _timer_duration); // duration
ds_grid_set(_list, 9,  _autoincrement, _timer_loop);     // loop-interval

if (ex_timer_get_debug_mode()) {
    var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( _timer_name ));
    show_debug_message('exTimer: Created timer with name "'+string( _timer_name )+'" ['+string( _y )+']');
}

if (argument_count >= 6) {
    
    if (argument[5] != "") {
        
        if (ex_timer_class_count() > 0) {

            _timer_classes = argument[5];

            // add timer to each class
            var _timer_classes_array = ex_timer_string_split(_timer_classes, " ");
            var _timer_classes_array_size = array_length_1d(_timer_classes_array);

            for (var _i=0; _i < _timer_classes_array_size; ++_i) {
                if (ex_timer_class_exists(_timer_classes_array[_i])) {
                    ex_timer_class_add_timer(_timer_name, _timer_classes_array[_i]);
                    if (ex_timer_get_debug_mode()) {
                        show_debug_message('exTimer: Added timer "'+string( _timer_name )+'" under timer class "'+_timer_classes_array[_i]+'"');
                    }
                } else {
                    if (ex_timer_get_debug_mode()) {
                    show_debug_message('exTimer: Cannot add timer "'+string( _timer_name )+'" to non-existent class "'+_timer_classes_array[_i]+'", you need to create that class first before adding the timer');
                    }
                }
            }

        }
        
    }
    
}

// return grid y position
return _autoincrement;




#define ex_timer_destroy
///ex_timer_destroy(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

// remove timer
if (ds_grid_height(_list) < 2) {

    ds_grid_clear(_list, "");
    ds_grid_resize(_list, ds_grid_width(_list), 1);

} else {
    ex_timer_ds_grid_delete_row(_list, _y);
}


if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Destroyed timer with name "'+string( _name )+'"');
}

return 1;


#define ex_timer_ds_grid_delete_row
///ex_timer_ds_grid_delete_row(grid, row)

// for internal use

var _ea_grid = argument[0];
var _ea_row = argument[1];

var _ea_gw = ds_grid_width(_ea_grid);
var _ea_gh = ds_grid_height(_ea_grid);

ds_grid_set_grid_region(_ea_grid, _ea_grid, 0, _ea_row+1, _ea_gw-1, _ea_gh-_ea_row, 0, _ea_row);
ds_grid_resize(_ea_grid, _ea_gw, _ea_gh-1);

return 1;

#define ex_timer_exists
///ex_timer_exists(name)

var _name = argument[0];
var _list = ex_timer_get_index(_name);

if (_list < 0) {
    return 0;    
} else {
    return 1;
}



#define ex_timer_get_asset_index
///ex_timer_get_asset_index(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

var _y = ex_timer_get_index(_name);
if (_y < 0) {
    return 0;
}


#define ex_timer_get_debug_mode
///ex_timer_get_debug_mode()

return obj_ex_timer._ex_timer_debug_mode;


#define ex_timer_get_duration
///ex_timer_get_duration(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

// get duration
return ds_grid_get(_list, 8, _y);



#define ex_timer_get_index
///ex_timer_get_index(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check if timer exist first
if (ex_timer_count() < 1) {
    return -1;
}

var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( _name ));
if (_y < 0) {
    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    _y = -1;
}

return _y;


#define ex_timer_get_loop
///ex_timer_get_loop(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

// get loop
return ds_grid_get(_list, 9, _y);



#define ex_timer_get_name
///ex_timer_get_name(index)

var _timer_index = argument[0];
var _timer_list = obj_ex_timer._ex_timers;
var _out_name  = "";

if (_timer_list < 0) {
return "";
}

if (_timer_index < 0 or _timer_index > ds_grid_height(_timer_list)) {
    return "";
}

// get timer name
_out_name = ds_grid_get(_timer_list, 0, _timer_index);

return _out_name;


#define ex_timer_get_position
///ex_timer_get_position(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

// get position
return ds_grid_get(_list, 1, _y);



#define ex_timer_get_script
///ex_timer_get_script(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

// get script
return ds_grid_get(_list, 7, _y);




#define ex_timer_get_speed
///ex_timer_get_speed(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

// get speed
return ds_grid_get(_list, 2, _y);




#define ex_timer_initialize
///ex_timer_initialize()

if (instance_exists(obj_ex_timer)) {
	
	if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Warning, exTimer system is already initialized');
    }
	
	return 0;
}

// create exTimer object
instance_create(0, 0, obj_ex_timer);

return 1;



#define ex_timer_is_paused
///ex_timer_is_paused(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }

    return 0;
}

// get paused state
return ds_grid_get(_list, 5, _y);



#define ex_timer_is_playing
///ex_timer_is_playing(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }

    return 0;
}

// get playing state
return ds_grid_get(_list, 4, _y);



#define ex_timer_pause
///ex_timer_pause(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

// set playing state
ds_grid_set(_list, 4, _y, false);

// set paused state
ds_grid_set(_list, 5, _y, true);

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Paused timer with name: "'+string( _name )+'"');
}

return 1;



#define ex_timer_pause_all
///ex_timer_pause_all()

var _ex_timer_count = ex_timer_count();
for (var _i=0; _i < _ex_timer_count; ++_i) {
    ex_timer_pause(ex_timer_get_name(_i));
}

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Paused all timers');
}

return 1;


#define ex_timer_play
///ex_timer_play(name)

var _name              = argument[0];
var _list              = obj_ex_timer._ex_timers;
var _timer_speed       = ex_timer_get_speed(_name);
var _timer_position    = ex_timer_get_duration(_name);
var _timer_loop        = ex_timer_get_loop(_name);

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

// set playing state
ds_grid_set(_list, 4, _y, true);

// set speed
ds_grid_set(_list, 2, _y, _timer_speed);

// set position
ds_grid_set(_list, 1, _y, _timer_position);

// set loop
ds_grid_set(_list, 9, _y, _timer_loop);

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Started timer with name: "'+string( _name )+'"');
}

return 1;



#define ex_timer_resume
///ex_timer_resume(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

if (ds_grid_get(_list, 5, _y) == false) {
    
    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Timer with name: "'+string( _name )+'" is not paused, resume aborted');
    }
    
    return 0;
}

// set playing state
ds_grid_set(_list, 4, _y, true);

// set paused state
ds_grid_set(_list, 5, _y, false);

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Resumed timer with name: "'+string( _name )+'"');
}

return 1;



#define ex_timer_resume_all
///ex_timer_resume_all()

var _ex_timer_count = ex_timer_count();
for (var _i=0; _i < _ex_timer_count; ++_i) {
    ex_timer_resume(ex_timer_get_name(_i));
}

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Resumed all timers');
}

return 1;


#define ex_timer_set_debug_mode
///ex_timer_set_debug_mode(enabled)

obj_ex_timer._ex_timer_debug_mode = argument[0];


#define ex_timer_set_loop
///ex_timer_set_loop(name, loop)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }

    return 0;
}

// set loop
ds_grid_set(_list, 9, _y, argument[1]);

return 1;



#define ex_timer_set_position
///ex_timer_set_position(name, position)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }

    return 0;
}

var _position = argument[1];
var _max = ex_timer_get_duration(_name);
if (_position > _max) {
    _position = _max;
}
if (_position < 0) {
    _position = -1;
}

// set position
ds_grid_set(_list, 1, _y, _position);

return 1;





#define ex_timer_set_script
///ex_timer_set_script(name, script)

var _name     = argument[0];
var _script   = argument[1];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }

    return 0;
}

ds_grid_set(_list, 7, _y, _script);

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Added script '+string(_script)+' for timer: "'+string( _name )+'"');
}

return 1;


#define ex_timer_set_speed
///ex_timer_set_speed(name, speed)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }

return 0;
}

// set speed
ds_grid_set(_list, 2, _y, argument[1]);

return 1;





#define ex_timer_string_split
///ex_timer_string_split(string, delimiter)

// for internal use

var _ea_string = argument[0], _ea_delimiter = argument[1];
var _ea_position = string_pos(_ea_delimiter, _ea_string);
var _ea_array;

if (_ea_position == 0) {
    _ea_array[0] = _ea_string; 
    return _ea_array;
}

var _ea_delimiter_length = string_length(_ea_delimiter);
var _ea_array_length = 0;

while (true) {

    _ea_array[_ea_array_length++] = string_copy(_ea_string, 1, _ea_position - 1);
    _ea_string = string_copy(_ea_string, _ea_position + _ea_delimiter_length, string_length(_ea_string) - _ea_position - _ea_delimiter_length + 1);
    _ea_position = string_pos(_ea_delimiter, _ea_string);
    
    if (_ea_position == 0) {
        _ea_array[_ea_array_length] = _ea_string;
        return _ea_array;
    }
}


#define ex_timer_stop
///ex_timer_stop(name)

var _name = argument[0];
var _list = obj_ex_timer._ex_timers;

// check name column
var _y = ex_timer_get_index(_name);
if (_y < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer with name "'+string( _name )+'"');
    }
    
    return 0;
}

// set speed
ds_grid_set(_list, 2, _y, 0);

// set position
ds_grid_set(_list, 1, _y, -1);

// set playing state
ds_grid_set(_list, 4, _y, false);

// set paused state
ds_grid_set(_list, 5, _y, false);

// set loop
ds_grid_set(_list, 9, _y, false);

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Stopped timer with name: "'+string( _name )+'"');
}

return 1;



#define ex_timer_stop_all
///ex_timer_stop_all()

var _ex_timer_count = ex_timer_count();
for (var _i=0; _i < _ex_timer_count; ++_i) {
    ex_timer_stop(ex_timer_get_name(_i));
}

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Stopped all timers');
}

return 1;


#define ex_timer_class_add_timer
///ex_timer_class_add_timer(timerName, className)

var _name           = argument[0];
var _class_name     = argument[1];
var _list           = obj_ex_timer._ex_timers;
var _classes_list   = obj_ex_timer._ex_timer_classes;
var _class_list     = -1;
var _resource       = -1;
var _autoincrement  = 0;

// check name column of classes parent grid
_class_list = ex_timer_class_get_index(_class_name);

// get asset resource
_resource = ex_timer_get_asset_index(_name);

// resize class list and set autoincrement
if (ds_grid_height(_class_list) <= 0) {
    ds_grid_resize(_class_list, 4, 1);
    ds_grid_clear(_class_list, "");
} else {
    ds_grid_resize(_class_list, 4, ds_grid_height(_class_list)+1);
    _autoincrement = ds_grid_height(_class_list)-1;
}

// add resource to class list
ds_grid_set(_class_list, 0, _autoincrement, _name);           // name
ds_grid_set(_class_list, 1, _autoincrement, _resource);       // resource id
ds_grid_set(_class_list, 2, _autoincrement, 0);               // has played
ds_grid_set(_class_list, 3, _autoincrement, 0);               // is latter

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Added timer with name "'+string( _name )+'" to timer class "'+_class_name+'" ['+string( _class_list)+ ', ' +string( _autoincrement )+']'+'');
}

// return grid y position
return _autoincrement;


#define ex_timer_class_count
///ex_timer_class_count()

var _classes_list = obj_ex_timer._ex_timer_classes;

if (not ds_exists(_classes_list, ds_type_grid)) {
    return 0;
}

if (ds_grid_height(_classes_list) < 2) {

    if (ds_grid_get(_classes_list, 0, 0) == "") {
        return 0;
    }

}

return ds_grid_height(_classes_list);


#define ex_timer_class_create
///ex_timer_class_create(className)

var _list           = obj_ex_timer._ex_timer_classes;
var _list_max_size  = 2;
var _name           = argument[0];
var _class_list     = -1;
var _autoincrement  = 0;

// create or update the classes list
if (ds_exists(_list, ds_type_grid)) {
    
// workaround
if (ds_grid_get(_list, 0, 0) == "") {

} else {

    ds_grid_resize(_list, _list_max_size, ds_grid_height(_list)+1);
    _autoincrement = ds_grid_height(_list)-1;

}
    
} else {
    obj_ex_timer._ex_timer_classes = ds_grid_create(_list_max_size, 1);
    _list = obj_ex_timer._ex_timer_classes;
}

// create a new class grid
_class_list = ds_grid_create(4, 0);

// add new grid
ds_grid_set(_list, 0, _autoincrement, _name);       // name
ds_grid_set(_list, 1, _autoincrement, _class_list); // class grid

var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( _name ));

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Created timer class with name "'+string( _name )+'" ['+string( _y )+']');
}


#define ex_timer_class_destroy
///ex_timer_class_destroy(className)

var _class_name     = argument[0];
var _classes_list   = obj_ex_timer._ex_timer_classes;
var _class_list     = -1;

if (not ex_timer_class_exists(_class_name)) {
    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Trying to destroy class but timer class with name "'+string( _class_name )+'" does not exist');
    }
    return 0;
}

// check name column of classes parent grid
var _y = ds_grid_value_y(_classes_list, 0, 0, 1, ds_grid_height(_classes_list), string( _class_name ));

_class_list = ds_grid_get(_classes_list, 1, _y);

// remove class index
if (ds_grid_height(_classes_list) < 2) {

    ds_grid_clear(_classes_list, "");
    ds_grid_resize(_classes_list, ds_grid_width(_classes_list), 1);

} else {
    ex_timer_ds_grid_delete_row(_classes_list, _y);
}

ds_grid_destroy(_class_list);

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Destroyed timer class with name "'+string( _class_name )+'" ['+string( _y )+']');
}

return 1;


#define ex_timer_class_exists
///ex_timer_class_exists(className)

var _name = argument[0];
var _list = ex_timer_class_get_index(_name);

if (_list < 0) {
    return 0;    
} else {
    return 1;
}


#define ex_timer_class_get_index
///ex_timer_class_get_index(className)

var _class_name     = argument[0];
var _classes_list   = obj_ex_timer._ex_timer_classes;
var _class_list     = -1;

// check if classes exist first
if (ex_timer_class_count() < 1) {
    return -1;
}

// check name column of classes parent grid
var _cy = ds_grid_value_y(_classes_list, 0, 0, 0, ds_grid_height(_classes_list), string( _class_name ));
if (_cy < 0) {
    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, could not find timer class with name "'+string( _class_name )+'"');
    }
    return -1;
}

// get class list
_class_list = ds_grid_get(_classes_list, 1, _cy);

return _class_list;


#define ex_timer_class_pause
///ex_timer_class_pause(className)

var _name = argument[0];
var _list = ex_timer_class_get_index(_name);

if (_list < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// loop through all timers in the group
for (var _i=0; _i < _list_size; ++_i) {
    
    _result += 1;
    ex_timer_pause( ds_grid_get(_list, 0, _i) );
    
}

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Paused all timers with class "'+string( _name )+'", '+string( _result )+' in total');
}

return _result;


#define ex_timer_class_play
///ex_timer_class_play(className)

var _name = argument[0];
var _list = ex_timer_class_get_index(_name);

if (_list < 0) {
    
    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// loop through all timers in the group
for (var _i=0; _i < _list_size; ++_i) {
    
    _result += 1;
    ex_timer_play(ds_grid_get(_list, 0, _i));
    
}

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Playing all timers with class "'+string( _name )+'"');
}

return _result;


#define ex_timer_class_resume
///ex_timer_class_resume(className)

var _name = argument[0];
var _list = ex_timer_class_get_index(_name);

if (_list < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// loop through all timers in the group
for (var _i=0; _i < _list_size; ++_i) {
    
    _result += 1;
    ex_timer_resume( ds_grid_get(_list, 0, _i) );
    
}

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Resumed all timers with class "'+string( _name )+'", '+string( _result )+' in total');
}

return _result;


#define ex_timer_class_set_loop
///ex_timer_class_set_loop(className, value)

var _name  = argument[0];
var _value = argument[1];
var _list  = ex_timer_class_get_index(_name);

//ds resize bug workaround
if (ds_grid_get(_list, 0, 0) == "" and ds_grid_height(_list) < 2) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Warning, no timers exist in class with name "'+string( _name )+'"');
    }

    return 0;
}

if (_list < 0) {
    
    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// loop through all timers in the group
for (var _i=0; _i < _list_size; ++_i) {
    
    _result += 1;
    ex_timer_set_loop( ds_grid_get(_list, 0, _i), _value );
    
}

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Set loop to '+string( _value )+' all timers with class "'+string( _name )+'", '+string( _result )+' in total');
}

return _result;


#define ex_timer_class_set_position
///ex_timer_class_set_position(className, value)

var _name  = argument[0];
var _value = argument[1];
var _list  = ex_timer_class_get_index(_name);

//ds resize bug workaround
if (ds_grid_get(_list, 0, 0) == "" and ds_grid_height(_list) < 2) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Warning, no timers exist in class with name "'+string( _name )+'"');
    }

    return 0;
}

if (_list < 0) {
    
    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// loop through all timers in the group
for (var _i=0; _i < _list_size; ++_i) {
    
    _result += 1;
    ex_timer_set_position( ds_grid_get(_list, 0, _i), _value );
    
}

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Set position to '+string( _value )+' all timers with class "'+string( _name )+'", '+string( _result )+' in total');
}

return _result;


#define ex_timer_class_set_speed
///ex_timer_class_set_speed(className, value)

var _name  = argument[0];
var _value = argument[1];
var _list  = ex_timer_class_get_index(_name);

//ds resize bug workaround
if (ds_grid_get(_list, 0, 0) == "" and ds_grid_height(_list) < 2) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Warning, no timers exist in class with name "'+string( _name )+'"');
    }

    return 0;
}

if (_list < 0) {
    
    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// loop through all timers in the group
for (var _i=0; _i < _list_size; ++_i) {
    
    _result += 1;
    ex_timer_set_speed( ds_grid_get(_list, 0, _i), _value );
    
}

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Set speed to '+string( _value )+' all timers with class "'+string( _name )+'", '+string( _result )+' in total');
}

return _result;


#define ex_timer_class_stop
///ex_timer_class_stop(className)

var _name = argument[0];
var _list = ex_timer_class_get_index(_name);

if (_list < 0) {

    if (ex_timer_get_debug_mode()) {
        show_debug_message('exTimer: Error, trying to access non-existing class with name "'+string( _name )+'"');
    }
    
    return 0;

}

var _list_size = ds_grid_height(_list);
var _result    = 0;

// loop through all timers in the group
for (var _i=0; _i < _list_size; ++_i) {
    
    _result += 1;
    ex_timer_stop( ds_grid_get(_list, 0, _i) );
    
}

if (ex_timer_get_debug_mode()) {
    show_debug_message('exTimer: Stopped all timers with class "'+string( _name )+'", '+string( _result )+' in total');
}

return _result;

