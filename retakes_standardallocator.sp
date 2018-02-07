#include <sourcemod>
#include <cstrike>
#include <clientprefs>
#include "include/retakes.inc"
#include "retakes/generic.sp"

#pragma semicolon 1
#pragma newdecls required

#define MENU_TIME_LENGTH 15

const int money_for_competitive_pistol_round = 800;

const int rifle_choice_ct_famas = 1;
const int rifle_choice_ct_m4a4 = 2;
const int rifle_choice_ct_m4a1_s = 3;
const int rifle_choice_ct_aug = 4;

const int rifle_choice_t_galil = 1;
const int rifle_choice_t_ak47 = 2;
const int rifle_choice_t_sg553 = 3;

const int pistol_choice_ct_hkp2000 = 1;
const int pistol_choice_ct_usp = 7;
const int pistol_choice_ct_p250 = 2;
const int pistol_choice_ct_fiveseven = 3;
const int pistol_choice_ct_cz = 4;
const int pistol_choice_ct_deagle = 5;
const int pistol_choice_ct_r8 = 6;

const int pistol_choice_t_glock = 1;
const int pistol_choice_t_p250 = 2;
const int pistol_choice_t_tec9 = 3;
const int pistol_choice_t_cz = 4;
const int pistol_choice_t_deagle = 5;
const int pistol_choice_t_r8 = 6;

const int nade_price_for_hegrenade = 300;
const int nade_price_for_flashbang = 200;
const int nade_price_for_smokegrenade = 500;
const int nade_price_for_molotov = 400;
const int nade_price_for_incgrenade = 600;

const int gun_price_for_p250 = 300;
const int gun_price_for_cz = 500;
const int gun_price_for_fiveseven = 500;
const int gun_price_for_tec9 = 500;
const int gun_price_for_deagle = 700;
const int gun_price_for_r8 = 800;

const int kit_price = 400;
const int kevlar_price = 650;

int g_PistolRchoiceCT[MAXPLAYERS+1];
int g_PistolRchoiceT[MAXPLAYERS+1];
int g_PistolchoiceCT[MAXPLAYERS+1];
int g_PistolchoiceT[MAXPLAYERS+1];
int g_RifleChoiceCT[MAXPLAYERS+1];
int g_RifleChoiceT[MAXPLAYERS+1];
bool g_AwpChoiceT[MAXPLAYERS+1];
bool g_AwpChoiceCT[MAXPLAYERS+1];
int g_side[MAXPLAYERS+1];
Handle g_hPISTOLRChoiceCookieCT = INVALID_HANDLE;
Handle g_hPISTOLRChoiceCookieT = INVALID_HANDLE;
Handle g_hGUNChoiceCookieCT = INVALID_HANDLE;
Handle g_hGUNChoiceCookieT = INVALID_HANDLE;
Handle g_hRifleChoiceCookieCT = INVALID_HANDLE;
Handle g_hRifleChoiceCookieT = INVALID_HANDLE;
Handle g_hAwpChoiceCookieCT = INVALID_HANDLE;
Handle g_hAwpChoiceCookieT = INVALID_HANDLE;

Handle g_h_sm_retakes_weapon_mimic_competitive_pistol_rounds = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_primary_enabled = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_nades_enabled = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_nades_hegrenade_ct_max = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_nades_hegrenade_t_max = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_nades_flashbang_ct_max = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_nades_flashbang_t_max = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_nades_smokegrenade_ct_max = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_nades_smokegrenade_t_max = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_nades_molotov_ct_max = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_nades_molotov_t_max = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_helmet_enabled = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_kevlar_enabled = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_awp_team_max = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_pistolrounds  = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_deagle_enabled  = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_r8_enabled  = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_cz_enabled  = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_p250_enabled  = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_tec9_fiveseven_enabled = INVALID_HANDLE;
Handle g_h_sm_retakes_weapon_allow_nades_on_pistol_rounds = INVALID_HANDLE;
Handle g_h_sm_retakes_kevlar_probability_on_comp_pistol_rounds = INVALID_HANDLE;
Handle g_h_sm_retakes_defusekit_probability_on_comp_pistol_rounds = INVALID_HANDLE;

Handle g_h_sm_retakes_kev_kit_nad_priority_on_comp_pistol_rounds_kev = INVALID_HANDLE;
Handle g_h_sm_retakes_kev_kit_nad_priority_on_comp_pistol_rounds_kit = INVALID_HANDLE;
Handle g_h_sm_retakes_kev_kit_nad_priority_on_comp_pistol_rounds_nad = INVALID_HANDLE;

int nades_hegrenade_ct_max = 0;
int nades_hegrenade_t_max = 0;
int nades_flashbang_ct_max = 0;
int nades_flashbang_t_max = 0;
int nades_smokegrenade_ct_max = 0;
int nades_smokegrenade_t_max = 0;
int nades_molotov_ct_max = 0;
int nades_molotov_t_max = 0;

int dollars_for_mimic_competitive_pistol_rounds;

public Plugin myinfo = {
    name = "CS:GO Retakes: Customised Weapon Allocator for splewis retakes plugin",
    author = "BatMen",
    description = "Defines convars to customize weapon allocator of splewig retakes plugin",
    version = PLUGIN_VERSION,
    url = "https://github.com/BatMen/csgo-retakes-splewis-convar-weapon-allocator"
};

public void OnPluginStart() {
    g_hPISTOLRChoiceCookieCT = RegClientCookie("retakes_pistolrchoice_ct", "", CookieAccess_Private);
    g_hPISTOLRChoiceCookieT = RegClientCookie("retakes_pistolrchoice_t", "", CookieAccess_Private);
    g_hGUNChoiceCookieCT = RegClientCookie("retakes_pistolchoice_ct", "", CookieAccess_Private);
    g_hGUNChoiceCookieT = RegClientCookie("retakes_pistolchoice_t", "", CookieAccess_Private);
    g_hRifleChoiceCookieCT  = RegClientCookie("retakes_riflechoice_ct", "", CookieAccess_Private);
    g_hRifleChoiceCookieT  = RegClientCookie("retakes_riflechoice_t", "", CookieAccess_Private);
    g_hAwpChoiceCookieCT = RegClientCookie("retakes_awpchoice_ct", "", CookieAccess_Private);
    g_hAwpChoiceCookieT = RegClientCookie("retakes_awpchoice_t", "", CookieAccess_Private);

    g_h_sm_retakes_weapon_pistolrounds = CreateConVar("sm_retakes_weapon_pistolrounds", "5", "The number of gun rounds (0 = no gun round)");
    g_h_sm_retakes_weapon_mimic_competitive_pistol_rounds = CreateConVar("sm_retakes_weapon_mimic_competitive_pistol_rounds", "1", "Whether pistol rounds are like 800$ rounds");
    g_h_sm_retakes_weapon_primary_enabled = CreateConVar("sm_retakes_weapon_primary_enabled", "1", "Whether the players can have primary weapon");
    
    g_h_sm_retakes_weapon_nades_enabled = CreateConVar("sm_retakes_weapon_nades_enabled", "1", "Whether the players can have nades");
    g_h_sm_retakes_weapon_allow_nades_on_pistol_rounds = CreateConVar("sm_retakes_weapon_allow_nades_on_pistol_rounds", "1", "Whether the players can have nades on pistol rounds");
    g_h_sm_retakes_weapon_nades_hegrenade_ct_max = CreateConVar("sm_retakes_weapon_nades_hegrenade_ct_max", "1", "Number of hegrenade CT team can have");
    g_h_sm_retakes_weapon_nades_hegrenade_t_max = CreateConVar("sm_retakes_weapon_nades_hegrenade_t_max", "1", "Number of hegrenade T team can have");
    g_h_sm_retakes_weapon_nades_flashbang_ct_max = CreateConVar("sm_retakes_weapon_nades_flashbang_ct_max", "1", "Number of flashbang CT team can have");
    g_h_sm_retakes_weapon_nades_flashbang_t_max = CreateConVar("sm_retakes_weapon_nades_flashbang_t_max", "1", "Number of flashbang T team can have");
    g_h_sm_retakes_weapon_nades_smokegrenade_ct_max = CreateConVar("sm_retakes_weapon_nades_smokegrenade_ct_max", "1", "Number of smokegrenade CT team can have");
    g_h_sm_retakes_weapon_nades_smokegrenade_t_max = CreateConVar("sm_retakes_weapon_nades_smokegrenade_t_max", "1", "Number of smokegrenade T team can have");
    g_h_sm_retakes_weapon_nades_molotov_ct_max = CreateConVar("sm_retakes_weapon_nades_molotov_ct_max", "1", "Number of molotov CT team can have");
    g_h_sm_retakes_weapon_nades_molotov_t_max = CreateConVar("sm_retakes_weapon_nades_molotov_t_max", "1", "Number of molotov T team can have");
    
    g_h_sm_retakes_weapon_helmet_enabled = CreateConVar("sm_retakes_weapon_helmet_enabled", "1", "Whether the players have helmet");
    g_h_sm_retakes_weapon_kevlar_enabled = CreateConVar("sm_retakes_weapon_kevlar_enabled", "1", "Whether the players have kevlar");
    g_h_sm_retakes_weapon_awp_team_max = CreateConVar("sm_retakes_weapon_awp_team_max", "1", "The max number of AWP per team (0 = no awp)");
    
    g_h_sm_retakes_weapon_deagle_enabled = CreateConVar("sm_retakes_weapon_deagle_enabled", "1", "Whether the players can choose deagle");
    g_h_sm_retakes_weapon_r8_enabled = CreateConVar("sm_retakes_weapon_r8_enabled", "1", "Whether the players can choose revolver");
    g_h_sm_retakes_weapon_cz_enabled = CreateConVar("sm_retakes_weapon_cz_enabled", "1", "Whether the playres can choose CZ");
    g_h_sm_retakes_weapon_p250_enabled = CreateConVar("sm_retakes_weapon_p250_enabled", "1", "Whether the players can choose P250");
    g_h_sm_retakes_weapon_tec9_fiveseven_enabled = CreateConVar("sm_retakes_weapon_tec9_fiveseven_enabled", "1", "Whether the players can choose Tec9/Five seven");
    
    g_h_sm_retakes_kevlar_probability_on_comp_pistol_rounds = CreateConVar("sm_retakes_kevlar_probability_on_competitive_pistol_rounds", "6", "The probability to get kevlar for each player on competitive pistol rounds. Between 0 to 10. 0 = never, 10 = always");
    g_h_sm_retakes_defusekit_probability_on_comp_pistol_rounds = CreateConVar("sm_retakes_defusekit_probability_on_competitive_pistol_rounds", "6", "The probability to get defusal kit for each player on competitive pistol rounds. Between 0 to 10. 0 = never, 10 = always");
    
    g_h_sm_retakes_kev_kit_nad_priority_on_comp_pistol_rounds_kev = CreateConVar("sm_retakes_kev_kit_nad_priority_on_comp_pistol_rounds_kev", "1", "The relative priority to have kevlar against kit/nade. Between 1 to 3. Default 1 (first).");
    g_h_sm_retakes_kev_kit_nad_priority_on_comp_pistol_rounds_kit = CreateConVar("sm_retakes_kev_kit_nad_priority_on_comp_pistol_rounds_kit", "2", "The relative priority to have kit against kevlar/nade. Between 1 to 3. Default 2 (second).");
    g_h_sm_retakes_kev_kit_nad_priority_on_comp_pistol_rounds_nad = CreateConVar("sm_retakes_kev_kit_nad_priority_on_comp_pistol_rounds_nad", "3", "The relative priority to have nade against kevlar/kit. Between 1 to 3. Default 3 (third).");
}

public void OnClientConnected(int client) {
    g_PistolchoiceCT[client] = pistol_choice_ct_hkp2000;
    g_PistolchoiceT[client] = pistol_choice_t_glock;
    g_RifleChoiceCT[client] = rifle_choice_ct_m4a4;
    g_RifleChoiceT[client] = rifle_choice_t_ak47;
    g_side[client] = 0;
    g_AwpChoiceT[client] = false;
    g_AwpChoiceCT[client] = false;
}

public Action OnClientSayCommand(int client, const char[] command, const char[] args) {
    char gunsChatCommands[][] = { "/gun", "/guns", "gun", "guns", ".gun", ".guns", ".setup", "!gun", "!guns", "gnus" };
    for (int i = 0; i < sizeof(gunsChatCommands); i++) {
        if (strcmp(args[0], gunsChatCommands[i], false) == 0) {
            if (GetConVarInt(g_h_sm_retakes_weapon_p250_enabled) != 1 && 
                GetConVarInt(g_h_sm_retakes_weapon_tec9_fiveseven_enabled) != 1 &&
                GetConVarInt(g_h_sm_retakes_weapon_cz_enabled) != 1 && 
                GetConVarInt(g_h_sm_retakes_weapon_deagle_enabled) != 1 && 
                GetConVarInt(g_h_sm_retakes_weapon_r8_enabled) != 1)
            {
                // on est pas T only
                if (g_side[client] != 1)
                    GiveWeaponMenuCT(client);
                else
                    GiveWeaponMenuT(client);
            }
            else
            {
                // on est pas T only
                if (g_side[client] != 1)
                    GivePistolRMenuCT(client);
                else
                    GivePistolRMenuT(client);
            }
            break;
        }
    }

    return Plugin_Continue;
}

public void Retakes_OnWeaponsAllocated(ArrayList tPlayers, ArrayList ctPlayers, Bombsite bombsite) {
    WeaponAllocator(tPlayers, ctPlayers, bombsite);
}

/**
 * Updates client weapon settings according to their cookies.
 */
public void OnClientCookiesCached(int client) {
    if (IsFakeClient(client))
        return;

    g_PistolRchoiceCT[client]  = GetCookieInt(client, g_hPISTOLRChoiceCookieCT);
    g_PistolRchoiceT[client]  = GetCookieInt(client, g_hPISTOLRChoiceCookieT);
    g_PistolchoiceCT[client]  = GetCookieInt(client, g_hGUNChoiceCookieCT);
    g_PistolchoiceT[client]  = GetCookieInt(client, g_hGUNChoiceCookieT);
    g_RifleChoiceCT[client] = GetCookieInt(client, g_hRifleChoiceCookieCT);
    g_RifleChoiceT[client] = GetCookieInt(client, g_hRifleChoiceCookieT);
    g_AwpChoiceCT[client]  = GetCookieBool(client, g_hAwpChoiceCookieCT);
    g_AwpChoiceT[client]  = GetCookieBool(client, g_hAwpChoiceCookieT);
}

static void SetNades(char nades[NADE_STRING_LENGTH], bool terrorist, bool competitivePistolRound) {
    nades = "";
    if (competitivePistolRound && GetConVarInt(g_h_sm_retakes_weapon_allow_nades_on_pistol_rounds)  != 1)
        return;
    if (GetConVarInt(g_h_sm_retakes_weapon_nades_enabled) == 1)
    {
        int max_hegrenade_allow = terrorist ? GetConVarInt(g_h_sm_retakes_weapon_nades_hegrenade_t_max) : GetConVarInt(g_h_sm_retakes_weapon_nades_hegrenade_ct_max);
        int max_flashbang_allow = terrorist ? GetConVarInt(g_h_sm_retakes_weapon_nades_flashbang_t_max) : GetConVarInt(g_h_sm_retakes_weapon_nades_flashbang_ct_max);
        int max_smokegrenade_allow = terrorist ? GetConVarInt(g_h_sm_retakes_weapon_nades_smokegrenade_t_max) : GetConVarInt(g_h_sm_retakes_weapon_nades_smokegrenade_ct_max);
        int max_molotov_allow = terrorist ? GetConVarInt(g_h_sm_retakes_weapon_nades_molotov_t_max) : GetConVarInt(g_h_sm_retakes_weapon_nades_molotov_ct_max);

        int he_number = 0;
        int smoke_number = 0;
        int flashbang_number = 0;
        int molotov_number = 0;

        int maxgrenades = GetConVarInt(FindConVar("ammo_grenade_limit_total"));
        int maxflashbang = GetConVarInt(FindConVar("ammo_grenade_limit_flashbang"));

        int rand;
        int indice = 0;
        // be sure to spend all the money on pistol rounds
        for(int i=0; i < 10; i++)
        {
            rand = GetRandomInt(1, 4);

            if (competitivePistolRound)
            {
                // no money for molotov
                if ( rand == 4 && (
                     (terrorist && dollars_for_mimic_competitive_pistol_rounds < nade_price_for_molotov) ||
                     (!terrorist && dollars_for_mimic_competitive_pistol_rounds < nade_price_for_incgrenade) ) )
                     rand = GetRandomInt(1, 3);
                // no money for smoke or hegrenade
                if (rand != 3 && dollars_for_mimic_competitive_pistol_rounds < nade_price_for_hegrenade)
                    rand = 3;
                // no money for flashbang
                if (dollars_for_mimic_competitive_pistol_rounds < nade_price_for_flashbang)
                    break;
            }

            if (maxgrenades <= indice)
                break;

            if (!competitivePistolRound && indice >= 2)
                break;

            switch(rand) {
                case 1: 
                    if ((terrorist ? nades_hegrenade_t_max : nades_hegrenade_ct_max) < max_hegrenade_allow && he_number == 0)
                    {
                        nades[indice] = 'h';
                        dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - nade_price_for_hegrenade;
                        indice++;
                        he_number++;
                        if (terrorist)
                            nades_hegrenade_t_max++;
                        else
                            nades_hegrenade_ct_max++;
                    }
                case 2: 
                    if ((terrorist ? nades_smokegrenade_t_max : nades_smokegrenade_ct_max) < max_smokegrenade_allow && smoke_number == 0)
                    {
                        nades[indice] = 's';
                        dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - nade_price_for_smokegrenade;
                        indice++;
                        smoke_number++;
                        if (terrorist)
                            nades_smokegrenade_t_max++;
                        else
                            nades_smokegrenade_ct_max++;
                    }
                case 3: 
                    if ((terrorist ? nades_flashbang_t_max : nades_flashbang_ct_max) < max_flashbang_allow && flashbang_number < maxflashbang)
                    {
                        nades[indice] = 'f';
                        dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - nade_price_for_flashbang;
                        indice++;
                        flashbang_number++;
                        if (terrorist)
                            nades_flashbang_t_max++;
                        else
                            nades_flashbang_ct_max++;
                    }
                case 4: 
                    if ((terrorist ? nades_molotov_t_max : nades_molotov_ct_max) < max_molotov_allow && molotov_number == 0)
                    {
                        nades[indice] = terrorist ? 'm' : 'i';
                        if (terrorist)
                            dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - nade_price_for_molotov;
                        else
                            dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - nade_price_for_incgrenade;
                        indice++;
                        molotov_number++;
                        if (terrorist)
                            nades_molotov_t_max++;
                        else
                            nades_molotov_ct_max++;
                    }
            }
        }
    }
}

public void WeaponAllocator(ArrayList tPlayers, ArrayList ctPlayers, Bombsite bombsite) {
    int tCount = GetArraySize(tPlayers);
    int ctCount = GetArraySize(ctPlayers);

    bool isPistolRound = GetConVarInt(g_h_sm_retakes_weapon_primary_enabled) == 0 || Retakes_GetRetakeRoundsPlayed() < GetConVarInt(g_h_sm_retakes_weapon_pistolrounds);
    bool mimicCompetitivePistolRounds = GetConVarInt(g_h_sm_retakes_weapon_mimic_competitive_pistol_rounds) == 1;

    char primary[WEAPON_STRING_LENGTH];
    char secondary[WEAPON_STRING_LENGTH];
    char nades[NADE_STRING_LENGTH];

    int health = 100;
    int kevlar = 100;
    bool helmet = true;
    bool kit = true;

    nades_hegrenade_ct_max = 0;
    nades_hegrenade_t_max = 0;
    nades_smokegrenade_ct_max = 0;
    nades_smokegrenade_t_max = 0;
    nades_flashbang_ct_max = 0;
    nades_flashbang_t_max = 0;
    nades_molotov_ct_max = 0;
    nades_molotov_t_max = 0;

    bool giveTAwp = true;
    bool giveCTAwp = true;
    if (GetConVarInt(g_h_sm_retakes_weapon_awp_team_max) < 1)
    {
        giveTAwp = false;
        giveCTAwp = false;
    }

    int awp_given = 0;
    int[] treatedT = new int[tCount];
    for (int i = 0; i < tCount; i++) {

        // dynamic array which contains all the players'number for whom we don't already give weapons, take a random new one
        // we don't treat players in the same order for each round. More equity to have AWP and nades
        int[] NotTreatedT = new int[tCount - i];
        for(int iNotTreated=0; iNotTreated < (tCount - i); iNotTreated++)
        {
            for (int candidate = 0; candidate < tCount; candidate++)
            {
                bool alreadyTreated = false;
                for (int iTreated = 0; iTreated < i; iTreated++)
                {
                    if (treatedT[iTreated] == candidate)
                    {
                        alreadyTreated = true;
                        break;
                    }
                }
                if (!alreadyTreated)
                    NotTreatedT[iNotTreated] = candidate;
            }
        }
        int pick = GetRandomInt(0, tCount - i - 1);
        int playerPick = NotTreatedT[pick];
        treatedT[i] = playerPick;

        int client = GetArrayCell(tPlayers, playerPick);

        g_side[client] = 1;
        
        dollars_for_mimic_competitive_pistol_rounds = money_for_competitive_pistol_round;

        primary = "";
        if (!isPistolRound)
        {
            int randGiveAwp = GetRandomInt(0, 1);

            if (giveTAwp && g_AwpChoiceT[client] && randGiveAwp == 1 && awp_given < GetConVarInt(g_h_sm_retakes_weapon_awp_team_max)) {
                primary = "weapon_awp";
                giveTAwp = false;
                awp_given = awp_given + 1;
            } else {
                int rifle_choice_t = g_RifleChoiceT[client];
                primary = "weapon_ak47";
                switch(rifle_choice_t)
                {
                    case rifle_choice_t_galil:
                        primary = "weapon_galilar";
                    case rifle_choice_t_sg553:
                        primary = "weapon_sg556";
                }
            }
        }
        if (isPistolRound)
        {
            if (g_PistolRchoiceT[client] == pistol_choice_t_p250 && GetConVarInt(g_h_sm_retakes_weapon_p250_enabled) == 1)
            {
                secondary = "weapon_p250";
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_p250;
            }
            else if (g_PistolRchoiceT[client] == pistol_choice_t_tec9 && GetConVarInt(g_h_sm_retakes_weapon_tec9_fiveseven_enabled) == 1)
            {
                secondary = "weapon_tec9";
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_tec9;
            }
            else if (g_PistolRchoiceT[client] == pistol_choice_t_cz && GetConVarInt(g_h_sm_retakes_weapon_cz_enabled) == 1)
            {
                secondary = "weapon_cz75a";
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_cz;
            }
            else if (g_PistolRchoiceT[client] == pistol_choice_t_deagle && GetConVarInt(g_h_sm_retakes_weapon_deagle_enabled) == 1)
            {
                secondary = "weapon_deagle";
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_deagle;
            }
            else if (g_PistolRchoiceT[client] == pistol_choice_t_r8 && GetConVarInt(g_h_sm_retakes_weapon_r8_enabled) == 1)
            {
                secondary = "weapon_revolver";
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_r8;
            }
            else
            {
                secondary = "weapon_glock";
            }
        }
        else
        {
            if (g_PistolchoiceT[client] == pistol_choice_t_p250 && GetConVarInt(g_h_sm_retakes_weapon_p250_enabled) == 1)
            {
                secondary = "weapon_p250";
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_p250;
            }
            else if (g_PistolchoiceT[client] == pistol_choice_t_tec9 && GetConVarInt(g_h_sm_retakes_weapon_tec9_fiveseven_enabled) == 1)
            {
                secondary = "weapon_tec9";
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_tec9;
            }
            else if (g_PistolchoiceT[client] == pistol_choice_t_cz && GetConVarInt(g_h_sm_retakes_weapon_cz_enabled) == 1)
            {
                secondary = "weapon_cz75a";
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_cz;
            }
            else if (g_PistolchoiceT[client] == pistol_choice_t_deagle && GetConVarInt(g_h_sm_retakes_weapon_deagle_enabled) == 1)
            {
                secondary = "weapon_deagle";
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_deagle;
            }
            else if (g_PistolchoiceT[client] == pistol_choice_t_r8 && GetConVarInt(g_h_sm_retakes_weapon_r8_enabled) == 1)
            {
                secondary = "weapon_revolver";
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_r8;
            }
            else
            {
                secondary = "weapon_glock";
            }
        }

        health = 100;

        if (GetConVarInt(g_h_sm_retakes_kev_kit_nad_priority_on_comp_pistol_rounds_kev) <= GetConVarInt(g_h_sm_retakes_kev_kit_nad_priority_on_comp_pistol_rounds_nad))
        {
            kevlar = getkevlar(mimicCompetitivePistolRounds, isPistolRound);
            SetNades(nades, true, mimicCompetitivePistolRounds && isPistolRound);
        }
        else
        {
            SetNades(nades, true, mimicCompetitivePistolRounds && isPistolRound);
            kevlar = getkevlar(mimicCompetitivePistolRounds, isPistolRound);
        }

        helmet = true;
        if (GetConVarInt(g_h_sm_retakes_weapon_helmet_enabled) != 1 || kevlar == 0 || (isPistolRound && mimicCompetitivePistolRounds))
            helmet = false;

        kit = false;
        
        Retakes_SetPlayerInfo(client, primary, secondary, nades, health, kevlar, helmet, kit);
    }
    
    awp_given = 0;
    int[] treatedCT = new int[ctCount];
    for (int i = 0; i < ctCount; i++) {

        // dynamic array which contains all the players'number for whom we don't already give weapons, take a random new one
        // we don't treat players in the same order for each round. More equity to have AWP and nades
        int[] NotTreatedCT = new int[ctCount - i];
        for(int iNotTreated=0; iNotTreated < (ctCount - i); iNotTreated++)
        {
            for (int candidate = 0; candidate < ctCount; candidate++)
            {
                bool alreadyTreated = false;
                for (int iTreated = 0; iTreated < i; iTreated++)
                {
                    if (treatedCT[iTreated] == candidate)
                    {
                        alreadyTreated = true;
                        break;
                    }
                }
                if (!alreadyTreated)
                    NotTreatedCT[iNotTreated] = candidate;
            }
        }
        int pick = GetRandomInt(0, ctCount - i - 1);
        int playerPick = NotTreatedCT[pick];
        treatedCT[i] = playerPick;

        int client = GetArrayCell(ctPlayers, playerPick);

        g_side[client] = 2;

        dollars_for_mimic_competitive_pistol_rounds = money_for_competitive_pistol_round;

        primary = "";
        if (!isPistolRound)
        {
            int randGiveAwp = GetRandomInt(0, 1);

            if (giveCTAwp && g_AwpChoiceCT[client] && randGiveAwp == 1 && awp_given < GetConVarInt(g_h_sm_retakes_weapon_awp_team_max)) {
                primary = "weapon_awp";
                giveCTAwp = false;
                awp_given = awp_given + 1;
            } else {
                int rifle_choice_ct = g_RifleChoiceCT[client];
                primary = "weapon_m4a1";
                switch(rifle_choice_ct)
                {
                    case rifle_choice_ct_famas:
                        primary = "weapon_famas";
                    case rifle_choice_ct_m4a1_s:
                        primary = "weapon_m4a1_silencer";
                    case rifle_choice_ct_aug:
                        primary = "weapon_aug";
                }
            }
        }

        if (isPistolRound)
        {
            if (g_PistolRchoiceCT[client] == pistol_choice_ct_p250 && GetConVarInt(g_h_sm_retakes_weapon_p250_enabled) == 1)
            {
                secondary = "weapon_p250";
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_p250;
            }
            else if (g_PistolRchoiceCT[client] == pistol_choice_ct_fiveseven && GetConVarInt(g_h_sm_retakes_weapon_tec9_fiveseven_enabled) == 1)
            {
                secondary = "weapon_fiveseven";
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_fiveseven;
            }
            else if (g_PistolRchoiceCT[client] == pistol_choice_ct_cz && GetConVarInt(g_h_sm_retakes_weapon_cz_enabled) == 1)
            {
                secondary = "weapon_cz75a";
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_cz;
            }
            else if (g_PistolRchoiceCT[client] == pistol_choice_ct_deagle && GetConVarInt(g_h_sm_retakes_weapon_deagle_enabled) == 1)
            {
                secondary = "weapon_deagle";
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_deagle;
            }
            else if (g_PistolRchoiceCT[client] == pistol_choice_ct_r8 && GetConVarInt(g_h_sm_retakes_weapon_r8_enabled) == 1)
            {
                secondary = "weapon_revolver";
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_r8;
            }
            else if (g_PistolRchoiceCT[client] == pistol_choice_ct_usp)
            {
                secondary = "weapon_usp_silencer";
            }
            else
            {
                secondary = "weapon_hkp2000";
            }
        }
        else
        {
            if (g_PistolchoiceCT[client] == pistol_choice_ct_p250 && GetConVarInt(g_h_sm_retakes_weapon_p250_enabled) == 1)
            {
                secondary = "weapon_p250";
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_p250;
            }
            else if (g_PistolchoiceCT[client] == pistol_choice_ct_fiveseven && GetConVarInt(g_h_sm_retakes_weapon_tec9_fiveseven_enabled) == 1)
            {
                secondary = "weapon_fiveseven";
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_fiveseven;
            }
            else if (g_PistolchoiceCT[client] == pistol_choice_ct_cz && GetConVarInt(g_h_sm_retakes_weapon_cz_enabled) == 1)
            {
                secondary = "weapon_cz75a";
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_cz;
            }
            else if (g_PistolchoiceCT[client] == pistol_choice_ct_deagle && GetConVarInt(g_h_sm_retakes_weapon_deagle_enabled) == 1)
            {
                secondary = "weapon_deagle";
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_deagle;
            }
            else if (g_PistolchoiceCT[client] == pistol_choice_ct_r8 && GetConVarInt(g_h_sm_retakes_weapon_r8_enabled) == 1)
            {
                secondary = "weapon_revolver";
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - gun_price_for_r8;
            }
            else if (g_PistolchoiceCT[client] == pistol_choice_ct_usp)
            {
                secondary = "weapon_usp_silencer";
            }
            else
            {
                secondary = "weapon_hkp2000";
            }
        }

        health = 100;
        int kit_priority = GetConVarInt(g_h_sm_retakes_kev_kit_nad_priority_on_comp_pistol_rounds_kit);
        int kev_priority = GetConVarInt(g_h_sm_retakes_kev_kit_nad_priority_on_comp_pistol_rounds_kev);
        int nad_priority = GetConVarInt(g_h_sm_retakes_kev_kit_nad_priority_on_comp_pistol_rounds_nad);
        bool call_kit = false;
        bool call_kev = false;
        bool call_nad = false;
        if (kev_priority == 1 && !call_kev)
        {
            kevlar = getkevlar(mimicCompetitivePistolRounds, isPistolRound);
            call_kev = true;
        }
        else if (kit_priority == 1 && !call_kit)
        {
            kit = getkit(mimicCompetitivePistolRounds, isPistolRound);
            call_kit = true;
        }
        else if (nad_priority == 1 && !call_nad)
        {
            SetNades(nades, false, mimicCompetitivePistolRounds && isPistolRound);
            call_nad = true;
        }

        if (kev_priority == 2 && !call_kev)
        {
            kevlar = getkevlar(mimicCompetitivePistolRounds, isPistolRound);
            call_kev = true;
        }
        else if (kit_priority == 2 && !call_kit)
        {
            kit = getkit(mimicCompetitivePistolRounds, isPistolRound);
            call_kit = true;
        }
        else if (nad_priority == 2 && !call_nad)
        {
            SetNades(nades, false, mimicCompetitivePistolRounds && isPistolRound);
            call_nad = true;
        }

        if (kev_priority == 3 && !call_kev)
        {
            kevlar = getkevlar(mimicCompetitivePistolRounds, isPistolRound);
            call_kev = true;
        }
        else if (kit_priority == 3 && !call_kit)
        {
            kit = getkit(mimicCompetitivePistolRounds, isPistolRound);
            call_kit = true;
        }
        else if (nad_priority == 3 && !call_nad)
        {
            SetNades(nades, false, mimicCompetitivePistolRounds && isPistolRound);
            call_nad = true;
        }

        // if server does not set exactly 1, 2, 3 on priority vars, we have to call them in default order
        if (!call_kev)
            kevlar = getkevlar(mimicCompetitivePistolRounds, isPistolRound);
        if (!call_kit)
            kit = getkit(mimicCompetitivePistolRounds, isPistolRound);
        if (!call_nad)
            SetNades(nades, false, mimicCompetitivePistolRounds && isPistolRound);

        helmet = true;
        if (GetConVarInt(g_h_sm_retakes_weapon_helmet_enabled) != 1 || kevlar == 0 || (isPistolRound && mimicCompetitivePistolRounds))
            helmet = false;

        if (!isPistolRound || (isPistolRound && !mimicCompetitivePistolRounds))
            kit = true;

        Retakes_SetPlayerInfo(client, primary, secondary, nades, health, kevlar, helmet, kit);
    }
}

public int getkevlar(bool mimicCompetitivePistolRounds, bool isPistolRound)
{
    int odds;
    int kevlar = 100;
    if (GetConVarInt(g_h_sm_retakes_weapon_kevlar_enabled) != 1)
    {
        kevlar = 0;
    }
    else if (mimicCompetitivePistolRounds && isPistolRound)
    {
        kevlar = 0;
        if (dollars_for_mimic_competitive_pistol_rounds >= kevlar_price)
        {
            odds = GetRandomInt(0,10);
            // pourcentage between 0% to 100% to have kevlar if money
            if (odds <= GetConVarInt(g_h_sm_retakes_kevlar_probability_on_comp_pistol_rounds))
            {
                kevlar = 100;
                dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - kevlar_price;
            }
        }
    }
    return kevlar;
}

public bool getkit(bool mimicCompetitivePistolRounds, bool isPistolRound)
{
    int odds;
    bool kit = false;
    if(dollars_for_mimic_competitive_pistol_rounds >= kit_price && isPistolRound && mimicCompetitivePistolRounds)
    {
        odds = GetRandomInt(0,10);
        // percentage between 0% to 100% to get kit if money before nades
        if (odds <= GetConVarInt(g_h_sm_retakes_defusekit_probability_on_comp_pistol_rounds))
        {
            kit = true;
            dollars_for_mimic_competitive_pistol_rounds = dollars_for_mimic_competitive_pistol_rounds - kit_price;
        }
    }
    return kit;
}

public void GivePistolRMenuCT(int client) {
    Handle menu = CreateMenu(MenuHandler_PISTOLR_CT);
    SetMenuTitle(menu, "Select a CT PR pistol:");
    AddMenuInt(menu, pistol_choice_ct_hkp2000, "P2000");
    AddMenuInt(menu, pistol_choice_ct_usp, "USP-S");
    if (GetConVarInt(g_h_sm_retakes_weapon_p250_enabled) == 1)
        AddMenuInt(menu, pistol_choice_ct_p250, "P250");
    if (GetConVarInt(g_h_sm_retakes_weapon_tec9_fiveseven_enabled) == 1)
        AddMenuInt(menu, pistol_choice_ct_fiveseven, "Fiveseven");
    if (GetConVarInt(g_h_sm_retakes_weapon_cz_enabled) == 1)
        AddMenuInt(menu, pistol_choice_ct_cz, "CZ75");
    if (GetConVarInt(g_h_sm_retakes_weapon_deagle_enabled) == 1)
        AddMenuInt(menu, pistol_choice_ct_deagle, "Deagle");
    if (GetConVarInt(g_h_sm_retakes_weapon_r8_enabled) == 1)
        AddMenuInt(menu, pistol_choice_ct_r8, "Revolver");
    DisplayMenu(menu, client, MENU_TIME_LENGTH);
}

public void GivePistolRMenuT(int client) {
    Handle menu = CreateMenu(MenuHandler_PISTOLR_T);
    SetMenuTitle(menu, "Select a T PR pistol:");
    AddMenuInt(menu, pistol_choice_t_glock, "Glock");
    if (GetConVarInt(g_h_sm_retakes_weapon_p250_enabled) == 1)
        AddMenuInt(menu, pistol_choice_t_p250, "P250");
    if (GetConVarInt(g_h_sm_retakes_weapon_tec9_fiveseven_enabled) == 1)
        AddMenuInt(menu, pistol_choice_t_tec9, "Tec-9");
    if (GetConVarInt(g_h_sm_retakes_weapon_cz_enabled) == 1)
        AddMenuInt(menu, pistol_choice_t_cz, "CZ75");
    if (GetConVarInt(g_h_sm_retakes_weapon_deagle_enabled) == 1)
        AddMenuInt(menu, pistol_choice_t_deagle, "Deagle");
    if (GetConVarInt(g_h_sm_retakes_weapon_r8_enabled) == 1)
        AddMenuInt(menu, pistol_choice_t_r8, "Revolver");
    DisplayMenu(menu, client, MENU_TIME_LENGTH);
}

public int MenuHandler_PISTOLR_CT(Handle menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        int client = param1;
        int gunchoice = GetMenuInt(menu, param2);
        g_PistolRchoiceCT[client] = gunchoice;
        SetCookieInt(client, g_hPISTOLRChoiceCookieCT, gunchoice);
        // on est pas CT only
        if (g_side[client] != 2)
            GivePistolRMenuT(client);
        else
            GivePistolMenuCT(client);
    } else if (action == MenuAction_End) {
        CloseHandle(menu);
    }
}

public int MenuHandler_PISTOLR_T(Handle menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        int client = param1;
        int gunchoice = GetMenuInt(menu, param2);
        g_PistolRchoiceT[client] = gunchoice;
        SetCookieInt(client, g_hPISTOLRChoiceCookieT, gunchoice);
        // on est pas T only
        if (g_side[client] != 1)
            GivePistolMenuCT(client);
        else
            GivePistolMenuT(client);
    } else if (action == MenuAction_End) {
        CloseHandle(menu);
    }
}

public void GivePistolMenuCT(int client) {
    Handle menu = CreateMenu(MenuHandler_PISTOL_CT);
    SetMenuTitle(menu, "Select a CT GR pistol:");
    AddMenuInt(menu, pistol_choice_ct_hkp2000, "P2000");
    AddMenuInt(menu, pistol_choice_ct_usp, "USP-S");
    if (GetConVarInt(g_h_sm_retakes_weapon_p250_enabled) == 1)
        AddMenuInt(menu, pistol_choice_ct_p250, "P250");
    if (GetConVarInt(g_h_sm_retakes_weapon_tec9_fiveseven_enabled) == 1)
        AddMenuInt(menu, pistol_choice_ct_fiveseven, "Fiveseven");
    if (GetConVarInt(g_h_sm_retakes_weapon_cz_enabled) == 1)
        AddMenuInt(menu, pistol_choice_ct_cz, "CZ75");
    if (GetConVarInt(g_h_sm_retakes_weapon_deagle_enabled) == 1)
        AddMenuInt(menu, pistol_choice_ct_deagle, "Deagle");
    if (GetConVarInt(g_h_sm_retakes_weapon_r8_enabled) == 1)
        AddMenuInt(menu, pistol_choice_ct_r8, "Revolver");
    DisplayMenu(menu, client, MENU_TIME_LENGTH);
}

public void GivePistolMenuT(int client) {
    Handle menu = CreateMenu(MenuHandler_PISTOL_T);
    SetMenuTitle(menu, "Select a T GR pistol:");
    AddMenuInt(menu, pistol_choice_t_glock, "Glock");
    if (GetConVarInt(g_h_sm_retakes_weapon_p250_enabled) == 1)
        AddMenuInt(menu, pistol_choice_t_p250, "P250");
    if (GetConVarInt(g_h_sm_retakes_weapon_tec9_fiveseven_enabled) == 1)
        AddMenuInt(menu, pistol_choice_t_tec9, "Tec-9");
    if (GetConVarInt(g_h_sm_retakes_weapon_cz_enabled) == 1)
        AddMenuInt(menu, pistol_choice_t_cz, "CZ75");
    if (GetConVarInt(g_h_sm_retakes_weapon_deagle_enabled) == 1)
        AddMenuInt(menu, pistol_choice_t_deagle, "Deagle");
    if (GetConVarInt(g_h_sm_retakes_weapon_r8_enabled) == 1)
        AddMenuInt(menu, pistol_choice_t_r8, "Revolver");
    DisplayMenu(menu, client, MENU_TIME_LENGTH);
}

public int MenuHandler_PISTOL_CT(Handle menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        int client = param1;
        int gunchoice = GetMenuInt(menu, param2);
        g_PistolchoiceCT[client] = gunchoice;
        SetCookieInt(client, g_hGUNChoiceCookieCT, gunchoice);
        // on est pas CT only
        if (g_side[client] != 2)
            GivePistolMenuT(client);
        else
            GiveWeaponMenuCT(client);
    } else if (action == MenuAction_End) {
        CloseHandle(menu);
    }
}

public int MenuHandler_PISTOL_T(Handle menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        int client = param1;
        int gunchoice = GetMenuInt(menu, param2);
        g_PistolchoiceT[client] = gunchoice;
        SetCookieInt(client, g_hGUNChoiceCookieT, gunchoice);
        // on est pas T only
        if (g_side[client] != 1)
            GiveWeaponMenuCT(client);
        else
            GiveWeaponMenuT(client);
    } else if (action == MenuAction_End) {
        CloseHandle(menu);
    }
}

public void GiveWeaponMenuCT(int client) {
    Handle menu = CreateMenu(MenuHandler_RIFLE_CT);
    SetMenuTitle(menu, "Select a CT rifle:");
    AddMenuInt(menu, rifle_choice_ct_famas, "Famas");
    AddMenuInt(menu, rifle_choice_ct_m4a4, "M4A4");
    AddMenuInt(menu, rifle_choice_ct_m4a1_s, "M4A1-S");
    AddMenuInt(menu, rifle_choice_ct_aug, "Aug");
    DisplayMenu(menu, client, MENU_TIME_LENGTH);
}

public void GiveWeaponMenuT(int client) {
    Handle menu = CreateMenu(MenuHandler_RIFLE_T);
    SetMenuTitle(menu, "Select a T rifle:");
    AddMenuInt(menu, rifle_choice_t_galil, "Galil");
    AddMenuInt(menu, rifle_choice_t_ak47, "AK47");
    AddMenuInt(menu, rifle_choice_t_sg553, "SG553");
    DisplayMenu(menu, client, MENU_TIME_LENGTH);
}

public int MenuHandler_RIFLE_CT(Handle menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        int client = param1;
        int riflechoice = GetMenuInt(menu, param2);
        g_RifleChoiceCT[client] = riflechoice;
        SetCookieInt(client, g_hRifleChoiceCookieCT, riflechoice);
        // on est pas CT only
        if (g_side[client] != 2)
            GiveWeaponMenuT(client);
        else if (GetConVarInt(g_h_sm_retakes_weapon_awp_team_max) > 0)
            GiveAwpMenuCT(client);
        else
            CloseHandle(menu);
    } else if (action == MenuAction_End) {
        CloseHandle(menu);
    }
}

public int MenuHandler_RIFLE_T(Handle menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        int client = param1;
        int riflechoice = GetMenuInt(menu, param2);
        g_RifleChoiceT[client] = riflechoice;
        SetCookieInt(client, g_hRifleChoiceCookieT, riflechoice);
        if (g_side[client] != 1 && GetConVarInt(g_h_sm_retakes_weapon_awp_team_max) > 0)
            GiveAwpMenuCT(client);
        else if (GetConVarInt(g_h_sm_retakes_weapon_awp_team_max) > 0)
            GiveAwpMenuT(client);
        else
            CloseHandle(menu);
    } else if (action == MenuAction_End) {
        CloseHandle(menu);
    }
}

public void GiveAwpMenuCT(int client) {
    Handle menu = CreateMenu(MenuHandler_AWP_CT);
    SetMenuTitle(menu, "Allow yourself to receive AWPs on CT side?");
    AddMenuBool(menu, true, "Yes");
    AddMenuBool(menu, false, "No");
    DisplayMenu(menu, client, MENU_TIME_LENGTH);
}

public void GiveAwpMenuT(int client) {
    Handle menu = CreateMenu(MenuHandler_AWP_T);
    SetMenuTitle(menu, "Allow yourself to receive AWPs on T side?");
    AddMenuBool(menu, true, "Yes");
    AddMenuBool(menu, false, "No");
    DisplayMenu(menu, client, MENU_TIME_LENGTH);
}

public int MenuHandler_AWP_CT(Handle menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        int client = param1;
        bool allowAwps = GetMenuBool(menu, param2);
        g_AwpChoiceCT[client] = allowAwps;
        SetCookieBool(client, g_hAwpChoiceCookieCT, allowAwps);
        if (g_side[client] != 2)
            GiveAwpMenuT(client);
        else
            CloseHandle(menu);
    } else if (action == MenuAction_End) {
        CloseHandle(menu);
    }
}

public int MenuHandler_AWP_T(Handle menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        int client = param1;
        bool allowAwps = GetMenuBool(menu, param2);
        g_AwpChoiceT[client] = allowAwps;
        SetCookieBool(client, g_hAwpChoiceCookieT, allowAwps);
        CloseHandle(menu);
    } else if (action == MenuAction_End) {
        CloseHandle(menu);
    }
}
