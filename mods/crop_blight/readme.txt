CROP_BLIGHT MOD READEME
(NICI) = Not in creative inventory

PURPOSE:
This mod adds a blight which is designed to effect crops. There is no natural way for blight to
occure with this mod alone, other mods my start blight by adding some method of creating a
contaminating node and adding it to the world. Once added to the world, players can track the
blight around which will hurt crops, trees, and other flora. 

NODE SETTINGS
The following node settings are used by the mod. Use these settings to make other nodes compatable
with the CROP_BLIGHT MOD:
crop_blight_settings = {
    reverse_spot_default  = BOOL      --All drawtype = normal nodes will allow a blight spot to appear unless this is 'true'. All other nodes
                                        will not allow a blight spot to appear above it unless this is set to 'true'.
    reverse_seal_default  = BOOL      --Only sunlight_propigates = true nodes use this setting. If set to 'true', blight will not pass through
                                        the node. By default, blight can pass through if light can pass through.
    contaminates_player   = BOOL      --Default is false/nil
    decontaminates_player = BOOL      --Default is false/nil
    scatter_on_dig        = BOOL      --Default is false/nil. If true, node will have a 1 in 2 chance of scattering blight when dug. (Must have
                                        "blight_on_dig" assigned as on_dig function)
    infectable_settings   = {         --If 'infectable_settings' exist, node is an infectable node and must have the following settings:
        chance            = NUMBER    -- 1/chance = chance that node will infect when exposed to blight)
        infected_version  = NODE NAME --Infected version of the infectable node)
    }
}

MOD FUNCTION:
Understand the following terms:
Infectable Node: A node which can be infected by blight
Infected Node: The infected version of an infectable node. 
Contaminating Node: A node which will cause a player to become a carrier of blight if a player is near it.
Decontaminating Node = A node which will clean a player of blight
NOTE: Membership in these catagories is controled by the node's crop_blight_settings.

Blight is introduced to the world by the creation of a Contaminating node. 

A global step is used to detect if a player is near a Contaminating node. If near a Contaminating
node, the player is contaminated and will scatter the blight for a period of time. The blight is
scattered using the "scatter_blight" function. When this function is called, a path from the player
to an area of bright light and an area of low light are found. At the end of this path, the function
places a "blight spot" and infects all infectable nodes neighboring the blight spot. The blight spot
is a contaminating node.

The "scatter_blight" function can only find a path through nodes which allow light to pass through.
There are some exceptions. Some nodes, like default glass, allow light to pass through but should
still be considered air-tight and should not allow blight to pass through. Overrides have been added
for these exceptions to add reverse_seal_default = true to their crop blight node registration
settings (see overrides.lua).

By default, the "scatter_blight" function will only place "blight spots" on nodes of drawtype = "normal".
Other drawtypes will not, by default, recieve a blightspot. Some drawtype=normal nodes should not recieve
a blight spot, overrides have been written for these exceptions to set add reverse_spot_default = true to
their crop blight node registration settins (see overrides.lua).

The player will be contaminated and continue to scatter blight until the time of infection has elapsed
or until the player stands on a Decontaminating Node. After a few seconds on a decontaminating node,
the player will no longer scatter blight.

Nodes registered using the crop_blight.register_blighted_node are assigned four poperties by default:
1) they will infect infectable neightbors afew seconds after construction
2) they will infect the player
3) they will infect the player when dug
4) they will NOT ocasionally scatter blight (controled by group 'scatters_blight' membership and an ABM)
   (Infected soils and Artist's Fungus will ocasionally scaatter blight)
These are the default properties. All can be altered. This registration
function is intended for registering the infected versions of infectable nodes.

If a player is contaminated and scatters blight into a field of wheat, the following takes place:
first the blight scatters from the player and may land on the soil under the wheat. Since farming
soil is an Infectable node, the soil will be infected but no blight spot will be placed since the wheat
is occupying the node above the soil. The blighted version of farming soil has the default properties
assigned by crop_blight.register_blighted_node so it will contaminate its neighbors and the wheat above
it. Quickly the entire field will be contaminated since both the blighted wheat and the ground are
spreading the blight to their neighbors.

Cotton will not spread the blight as quickly. The blighted version of cotton is not registered using the
crop_blight.register_blighted_node function, so only the dirt will carry the blight. In addition, cotton
has a lower chance of being contaminated than wheat does.

MAKING NODES COMPATABLE WITH THIS MOD:
I have a new node, how do I make it infectable? 
    --In the registration add the crop_blight_settings.infectable_settings.infected_version and .chance settings.
I have a new infected version, how do I make it work?
    --Use the crop_blight.register_blighted_node() function to register your infected version
I don't like property (1) given by crop_blight.register_blighted_node().
    --Write a different on_timer property. Try on_timer = function() return false end, (see artist's fungus registration)
I don't like property (2) given by crop_blight.register_blighted_node().
    --In the definition used by crop_blight.register_blighted_node(), set crop_blight_settings = {contaminates_player = false}
I don't like property (3) given by crop_blight.register_blighted_node().
    --Write a different on_dig property. Try on_dig = function(pos, node, player) minetest.node_dig(pos, node, player) end,
I don't like property (4) given by crop_blight.register_blighted_node().
    --Add 'scatters_blight = 1' to the groups definition.

DEPENDANCIES
Requires: default
optional: moreblocks, doors, home_mod, walls, seasons, farming, flowers (adds overrides for these mods)

PROPERTIES OF SOME NODES ADDED BY THIS MOD
Blighted Logs will infect their neightbors on construction, will not scatter more blight, will not infect the player,  
    will not infect the player when dug.
Artists fungus will not infect its neighbors on construction, will scatter more blight, will not infect the player, will
    not infect the player when dug.
Blighted farming soil will infect its neighbors on construction, will scatter more blight, will infect the player,
    will infect the player when dug.