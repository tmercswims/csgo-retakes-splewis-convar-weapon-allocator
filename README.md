#This plugin is not maintained anymore.  
# You can fork it if you want to improve it.  
# Many thanks to all of people who used it and still use it.

Customised Weapon Allocator 
-------------------

This plugin is an alternate weapon allocator of [Splewis RETAKES Plugin](https://github.com/splewis/csgo-retakes)

**Please be sure to create Issues if you've got trouble on your server, even for a simple question**

Install
---------------------

**The compiled SMX file for linux is in the source code zip file**

Just replace the smx file in */csgo/addons/sourcemod/plugins*

Explanations
---------------------

I've created those **cvars** to customise your server. 

Just add those cvars to change their default value in **server.cfg / autoexec.cfg** :
> - sm_retakes_weapon_pistolrounds
>   - **default 1**
>   - *you can set it to 0 if you want a gunmode*
> - sm_retakes_weapon_pistolrounds
>   - **default 5**
>   - *The number of gun rounds (0 = no gun round)*
> - sm_retakes_weapon_mimic_competitive_pistol_rounds
>   - **default 1**
>   - *Whether pistol rounds are like 800$ rounds*
> - sm_retakes_weapon_primary_enabled
>   - **default 1**
>   - *Whether the players can have primary weapon*
> - sm_retakes_weapon_nades_enabled
>   - **default 1**
>   - *Whether the players can have nades*
> - sm_retakes_weapon_allow_nades_on_pistol_rounds
>   - **default 1**
>   - *Whether the players can have nades on pistol rounds*
> - sm_retakes_weapon_nades_hegrenade_ct_max
>   - **default 1**
>   - *Number of hegrenade CT team can have*
> - sm_retakes_weapon_nades_hegrenade_t_max
>   - **default 1**
>   - *Number of hegrenade T team can have*
> - sm_retakes_weapon_nades_flashbang_ct_max
>   - **default 1**
>   - *Number of flashbang CT team can have*
> - sm_retakes_weapon_nades_flashbang_t_max
>   - **default 1**
>   - *Number of flashbang T team can have*
> - sm_retakes_weapon_nades_smokegrenade_ct_max
>   - **default 1**
>   - *Number of smokegrenade CT team can have*
> - sm_retakes_weapon_nades_smokegrenade_t_max
>   - **default 1**
>   - *Number of smokegrenade T team can have*
> - sm_retakes_weapon_nades_molotov_ct_max
>   - **default 1**
>   - *Number of molotov CT team can have*
> - sm_retakes_weapon_nades_molotov_t_max
>   - **default 1**
>   - *Number of molotov T team can have*
> - sm_retakes_weapon_helmet_enabled
>   - **default 1**
>   - *Whether the players have helmet*
> - sm_retakes_weapon_kevlar_enabled
>   - **default 1**
>   - *Whether the players have kevlar*
> - sm_retakes_weapon_awp_team_max
>   - **default 1**
>   - *The max number of AWP per team (0 = no awp)*
> - sm_retakes_weapon_deagle_enabled
>   - **default 1**
>   - *Whether the players can choose deagle*
> - sm_retakes_weapon_r8_enabled
>   - **default 1**
>   - *Whether the players can choose revolver*
> - sm_retakes_weapon_cz_enabled
>   - **default 1**
>   - *Whether the playres can choose CZ*
> - sm_retakes_weapon_p250_enabled
>   - **default 1**
>   - *Whether the players can choose P250*
> - sm_retakes_weapon_tec9_fiveseven_enabled
>   - **default 1**
>   - *Whether the players can choose Tec9/Five seven*
> - sm_retakes_kevlar_probability_on_competitive_pistol_rounds
>   - **default 6**
>   - *The probability to get kevlar for each player on competitive pistol rounds. Between 0 to 10. 0 = never, 10 = always*
> - sm_retakes_defusekit_probability_on_competitive_pistol_rounds
>   - **default 6**
>   - *The probability to get defusal kit for each player on competitive pistol rounds. Between 0 to 10. 0 = never, 10 = always*
> - sm_retakes_kev_kit_nad_priority_on_comp_pistol_rounds_kev
>   - **default 1**
>   - *The relative priority to have kevlar against kit/nade. Between 1 to 3. Default 1 (first).*
> - sm_retakes_kev_kit_nad_priority_on_comp_pistol_rounds_kit
>   - **default 2**
>   - *The relative priority to have kit against kevlar/nade. Between 1 to 3. Default 2 (second).*
> - sm_retakes_kev_kit_nad_priority_on_comp_pistol_rounds_nad
>   - **default 3**
>   - *The relative priority to have nade against kevlar/kit. Between 1 to 3. Default 3 (third).*


Guns !
-----------------------
**Players can write /guns /gun .guns .gun !guns !gun to change their weapons'preferences**
