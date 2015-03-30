#define RANDOM_MAP_VOTE "-1" // must be in invalid index for array indexing

/**
 * Map voting functions
 */
public void CreateMapVote() {
    if (GetConVarInt(g_RandomizeMapOrderCvar) != 0)
        RandomizeArray(GetCurrentMapList());

    ShowMapVote();
}

static void ShowMapVote() {
    ArrayList mapList = GetCurrentMapList();

    Menu menu = new Menu(MapVoteHandler);
    SetMenuTitle(menu, "%T", "VoteMenuTitle", LANG_SERVER);
    SetMenuExitButton(menu, false);

    if (g_RandomOptionInMapVoteCvar.IntValue != 0) {
        char buffer[255];
        Format(buffer, sizeof(buffer), "%T", "Random", LANG_SERVER);
        AddMenuItem(menu, RANDOM_MAP_VOTE, buffer);
    }

    for (int i = 0; i < GetArraySize(mapList); i++) {
        AddMapIndexToMenu(menu, mapList, i);
    }

    VoteMenuToAll(menu, GetConVarInt(g_MapVoteTimeCvar));
}

public int MapVoteHandler(Menu menu, MenuAction action, int param1, int param2) {
    ArrayList mapList = GetCurrentMapList();

    if (action == MenuAction_Display) {
        char buffer[255];
        Format(buffer, sizeof(buffer), "%T", "VoteMenuTitle", param1);
        SetPanelTitle(view_as<Handle>(param2), buffer);

    } else if (action == MenuAction_DisplayItem) {
        char info[32];
        GetMenuItem(menu, param2, info, sizeof(info));
        char display[64];
        if (StrEqual(info, RANDOM_MAP_VOTE)) {
            Format(display, sizeof(display), "%T", "Random", param1);
            return RedrawMenuItem(display);
        }

    } else if (action == MenuAction_VoteEnd) {
        int winner = GetMenuInt(menu, param1);
        if (winner == StringToInt(RANDOM_MAP_VOTE)) {
            ChangeMap(g_MapList,  GetArrayRandomIndex(mapList));
        } else {
            ChangeMap(g_MapList, GetMenuInt(menu, param1));
        }

    } else if (action == MenuAction_End) {
        CloseHandle(menu);
    }

    return 0;
}
