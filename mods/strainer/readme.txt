STRAINER MOD READEME
(NICI) = Not in creative inventory

PURPOSE:
The STRAINER mod is used to simulate separating liquids from solids by a straining process.

MOD FUNCTION:
To be strainable, a solid node must belong to group "strainable"
All strainable nodes must have "strainer_settings" added to their node registration.
    strainer_settings = {
        output_residual_func = <a function which returns the node and position for both output and residual>     (REQUIRED)
        strain_time          = <number of second to elapse before separation occurs>                             (REQUIRED)
        drip_color           = <color of particles which drip out of the node while before strain_time elapses>  (REQUIRED)
    }

output_residual_func is a function which is defined in the strainable node definition. This function will be passed two parameters: the
position of the strainable node and the place where the strainer mod suggests the output should be placed. For example: 
ouptput_residaul_func(node_pos, drop_pos).
The function must return the following table containing the following index lables:
return {output = <string name of output node/item>,
        output_pos = {position for placing output},
        residual=<string name of residual node/item>,
        residual_pos = {position for placing residual},
}

strainer.strainable_override(name, strainer_settings) is a function which can be called to override an existing node with 
the required group and the strainer_settings passed to the function. See the override for default:water_source in the
STRAINER MOD init.lua.

There are three strainer nodes: strainer:strainer_cloth, strainer:strainer_cloth_active (NICI), strainer:strainer_cloth_broken (NICI).
Once placed, a strainer:strainer_cloth checks the node above it on a timer until a strainable node is placed on it. Once the strainable
node is placed on the strainer, it turns into a strainer:strainer_cloth_active node. After the strain_time entered into the strainer_settings
has elapsed, the strainable node is replaced with its residual and the output product is placed below the strainer. An ABM 
is used to find active strainers and add the dripping effect under them. The same ABM is used to deactivate the active strainer if the 
strainable node is removed before straining is completed.

Strainers break after a set number of uses. If a used strainer is dug before it breaks, it drops a broken strainer.

DEPENDANCIES:
default