STRAINER MOD READEME
(NICI) = Not in creative inventory

PURPOSE:
The STRAINER mod is used to simulate separating liquids from solids by a straining process.

MOD FUNCTION:
To be strainable, a solid node must belong to group "strainable"
All strainable nodes must have "strainer_settings" added to their node registration.
    strainer_settings = {
        output               = <name of node which drops through the strainer, usually a liquid>                 (REQUIRED)
        alt_output           = <some other node name which could be an output>                                   
        do_alt_output_bool   = <a function which returns true if alt_output should be used instead of output>    
        residual             = <name of node left on top of strainer after output or alt_output has dropped out> (REQUIRED)
        alt_residual         = <some other node name which could be residual>                                    
        do_alt_residual_bool = <a function which returns true if alt_residual should be used instead of residual>
        strain_time          = <number of second to elapse before separation occurs>                             (REQUIRED)
        drip_color           = <color of particles which drip out of the node while before strain_time elapses>  (REQUIRED)
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

DEPENDANCIES
Needs DEFAULT