///generate_map(percentage)
/*
 * Generates a map
 *
 * percentage: The percentage of the map to fill
*/
var percent = argument0;
for(var j = 0; j < room_height / aStar_get_cell_size(); j ++)
{
    for(var i = 0; i < room_width / aStar_get_cell_size(); i ++)
    {
        if(irandom(99) <= percent)
        {
            instance_create(i * aStar_get_cell_size(), j * aStar_get_cell_size(), obj_tree);
        }
    }
}
