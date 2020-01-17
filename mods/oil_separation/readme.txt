OIL_SEPARATION MOD READEME
(NICI) = Not in creative inventory

PURPOSE:
This MOD adds a physical method for extracting oil from an agricultural product. The process 
is intended to be labor intensive and to consume the excess seeds produced from farming.
The BLIGHT extension of this mod (which can be enabled or disabled in the init scripts) adds 
a crop disease which kills crops, trees, and other flora. It also changes how crops in the 
farming mod drop their harvest. Instead of dropping a harvest or seeds, mature crops will
only drop their harvest (wheat or cotton etc.) the harvest can then be crafted into seed if the
farmer chooses. If the farmer does not balance his production well, the effects of an outbreak
of blight can be severe. 

FEATURES:
Oily seed paste is crafted from the seeds. 9 seeds = 1 oily seed paste. Oil can be extracted from
oily seed paste by placing the seed paste underwater and placing a flame node one block away from
the seed paste. If the STRAINER mod is enabled, the strainer can be used to extract oil.
 - Oil can be picked up using a bucket
 - Oil floats on water
 - Oil is flammable
 - Oil buckets can be used as fuel
 - Oily seed paste dries out in direct sunlight
 - If flames are near the seed paste at the moment the oil separates out, there is a chance you
   can collect more than one oil source from the node.

MOD FUNCTION:
--- Blight ---
Understand the following terms:
Infectable Node: A node which can be infected by blight
Blighted Node: The blighted version of an infectable node.
Registered Blighted Node: A blighted version of an infectable node which has been registered
    using the "register_blighted_node" function. Registered Blighted Nodes are a subset of 
    Blighted nodes which have two important features. 1) They cause a player to become a 
    carrier of blight if the player digs them (only if no other "on_dig" function is listed).
    2) After being placed in the world, they will blight their infectable neighbors after a few 
    seconds (this is only attempted once, the timer is not perpetual). 3) An ABM is used to 
    occasionally trigger the Registered Blighted node to scatter blight through the air.  
Contaminating Node   = A node which will cause a player to become a carrier of blight if a player
    is near it. Only nodes listed in the "contaminating_nodes" list are contaminating nodes.
Decontaminating Node = A node which will clean a player of blight

Blight is introduced to the world by the creation of a Contaminating node. This Blight extension of
the oil_separations mod includes an override for "oil_separation:seed_paste_dry" which causes it to
rot into "oil_separation:seed_paste_dry_blighted". "oil_separation:seed_paste_dry_blighted" is a 
Registered Blighted node.

A global step is used to detect if a player is near a Contaminating node. If near a Contaminating
node, the player is contaminated and will scatter the blight for a period of time. The blight is
scattered using the "scatter_blight" function. When this function is called, a path from the player
to an area of bright light and an area of low light are found. At the end of this path, the function
places a "blight spot" and infects all infectable nodes neighboring the blight spot. The blight spot
is a contaminating node.

The "scatter_blight" function can only find a path through nodes which allow light to pass through
(this includes nodes from moreblocks table saw). There are some exceptions. Some nodes allow light
to pass through but should still be considered air-tight and should not allow blight to pass through.
These exceptions are listed as, "airtight_translucent_nodes".

The "scatter_blight" function can only place "blight spots" on nodes of drawtype = "normal". There
are some exceptions. These exceptions are listed as, "no_blight_spot_nodes"

The player will be contaminated and continue to scatter blight until the time of infection has elapsed
or until the player stands on a Decontaminating Node. After a few seconds on a decontaminating node,
the player will no longer scatter blight.

If a player is contaminated and scatters blight into a field of wheat, the following takes place:
first the blight scatters from the player and may land on the soil under the wheat. Since farming
soil is an Infectable node, the soil will be infected but no blight spot will be placed since the wheat
is occupying the node above the soil. The blighted version of farming soil is a Registered Blighted
node so it will contaminate its neighbors and the wheat above it. Quickly the entire field will be
contaminated since both the blighted wheat and the ground are spreading the blight to their neighbors.

Cotton will not spread the blight as quickly. The blighted version of cotton is not a Registered
Blighted node, so only the dirt will carry the blight. In addition, cotton has a lower chance of
being contaminated than wheat does.

MODIFYING THE MOD
I do not want this node to get blight spots on it. -- Add the node name to the "no_blight_spot_nodes" list
This node looks airtight, blight should not pass through. -- Add the node name to the "airtight_translucent_nodes" list
This node would infect a player with blight -- Add the node name to the "contaminating_nodes" list
I want this node to disinfect a contaminated player -- Add the node name to the "decontaminating_nodes" list
I have a new plant! It should be affected by blight -- This can be added in two ways. BY GROUP: Add the group name
    to the "blight_settings_by_name" table as an index and fill out the following settings: "new_node" is the
    name of the blighted version of the node to be affected by blight, "chance" is the change that the node
    will change to "new_node" when affected by blight, "contaminates" determines if the "new_node" will be a contaminating
    node (will contaminate players). BY NAME: Add the name of the node to be blighted to the "blight_settings_by_name" 
    table. Settings are the same.
I want this node to have all the functionality of a Registered Blighted Node -- Register the node using the
    "register_blighted_node" function, if you also wish it to contaminate players, be sure to add it to the "contaminating_node" list.

DEPENDANCIES
Requires: default, bucket, farming, fire, flowers (flowers only needed if the BLIGHT extension is used)
optional: strainer (adds another method to extract oil), moreblocks (adds a sweeper to clean blight)
