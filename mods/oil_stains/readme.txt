OIL_STAINS MOD READEME
(NICI) = Not in creative inventory

PURPOSE:
The OIL_STAINS mod adds an in-game method of changing the color of a material which is more labor intensive than crafting. It
is intended to make colors more difficult to obtain, raising their value as a luxury item.

FEATURES:
Stain is created from oil. Dye can be added to oil to create stain in two ways: it can be added through crafting, or a player
can right click an oil_source node while holding dye. Materials can be stained by placing one of the four colors of stain (red,
blue, yellow, or black) on top of an object to be stained. After an amount of time the node to be stained will change color and
the stain which was placed upon it will be removed. Although not required, this method of coloring objects is intended to replace
crafting recipes.

MOD FUNCTION:
To make a node stainable, all color options must be minetest registered nodes. Each color must be added to the "staining_directory"
using oil_stains.register_stainable_node(). The "staining_directory" is a table which indicates how each color option for the 
material to be stained reacts to the four colors of stain.