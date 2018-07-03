<h1>[CS:GO] Jailbreak Days</h1>

<p>A plugins with specific days for jailbreak!</p>
<p>This plugin was made in 2016, and keep updated privately in 2017 for my ex-community, and haven't touched it since 25-06-2018</p>
<p>It only activates days through an warden and it has multiple plugins support, to make the days more enjoyable!</p>

<h2>Requirements: </h2>

- [Sourcemod](https://www.sourcemod.net/);
- [Hosties](https://forums.alliedmods.net/showthread.php?p=2592797);
- [Warden (By Ecca](https://forums.alliedmods.net/showthread.php?p=1476638);

<p> Optionals: </p>

- [Weapon Restrict](https://forums.alliedmods.net/showthread.php?t=105219);
- [Parachute](https://forums.alliedmods.net/showpost.php?p=1878698&postcount=555?p=1878698&postcount=555);

<p> For Developers:</p>

- [EmitSoundAny](https://forums.alliedmods.net/showthread.php?t=237045);

<h3>Commands</h3>

- <b>sm_days</b> - It shows the Days Menu;
- <b>sm_royal</b> - It shows the Royal Day Menu;
- <b>sm_warday</b> - It Shows the War Day Menu;
- <b>sm_hns</b> - It Shows the Hide and Seek Menu;
- <b>sm_catchduck</b> - It Shows the Catch the Duck Menu;
- <b>sm_nazi</b> - It Shows the Nazi Day Menu;
- <b>sm_zombie</b> - It Shows the Zombie Day Menu;
- <b>sm_dhelp</b> - It Shows the Help Menu for this plugin;
- <b>sm_fd</b> - It repeat the actual day in the next round;
- <b>sm_tp</b> - It Toggles the Camera view (Third or First Person) to a player;
- <b>sm_zskins</b> - It Shows the Zombie Skins Menu;
- <b>sm_dmusic</b> - It Toggles the Day's Music in a Player;

<h3>ConVars</h3>

- <b>jailbreak_days_royalday</b> (Default: 1) - Enables the Day named Royal Day;
- <b>jailbreak_days_royalday_afterlr</b> (Default: 1) - It let's continue Royal Day after Last Request being activated;
- <b>jailbreak_days_warday</b> (Default: 1) - Enables the Day named War Day;
- <b>jailbreak_days_warday_afterlr</b> (Default: 1) - It let's continue War Day after Last Request being activated;
- <b>jailbreak_days_hideandseek</b> (Default: 1) - Enables the Day named Hide and Seek;
- <b>jailbreak_days_hideandseek_afterlr</b> (Default: 1) - It let's continue Hide and Seek Day after Last Request being activated;
- <b>jailbreak_days_catchtheduck</b> (Default: 1) - Enables the Day named Catch of the Duck;
- <b>jailbreak_days_catchtheduck_afterlr</b> (Default: 1) - It let's continue Catch The Duck Day after Last Request being activated;
- <b>jailbreak_days_catchtheduck_gravity</b> (Default: 0.3) - Gravity of every player when Catch The Duck Day is enabled (0.0 doesn't change, 1.0 change to default gravity)
- <b>jailbreak_days_catchtheduck_speed</b> (Default: 1.0) - Speed of every player when Catch The Duck is enabled (0.0 doesn't change, 1.0 change to default speed);
- <b>jailbreak_days_zombieday</b> (Default: 1) - Enables the Day named Zombie Day;
- <b>jailbreak_days_zombieday_afterlr</b> (Default: 1) - It let's continue Zombie Day after Last Request being activated;
- <b>jailbreak_days_zombieday_skins</b> (Default: 1) - Enables Skins for Zombie Day;
- <b>jailbreak_days_naziday</b> (Default: 1) - Enables the Day named Nazi Day;
- <b>jailbreak_days_naziday_skins</b> (Default: 1) - Enables Skins for Nazi Day;
- <b>jailbreak_days_sounds</b> (Default: 1) - Enables Skins for every Days;
- <b>jailbreak_days_time</b> (Default: 2) - How many rounds between Days (Except Zombie Day);
- <b>jailbreak_days_fdcommand</b> (Default: 1) - It enables the <b>sm_fd</b> command, to repeat the actual day in the next round;
- <b>jailbreak_days_thirperson</b> (Default: 1) - It enables the ThirdPerson Toggle Command (<b>sm_tp</b>) implemented in the plugin (by enabling you have a better experience for certain days)
- <b>jailbreak_days_weaponmenu</b> (Default: 3) - Type of menus with weapons for the days (0 = No menu, Knife only, 1 = Only Primary guns, 2 = Only Pistol Guns, 3 = Both Primary and Pistol Guns)

```SourcePawn
/*
 * DAYS INDEXES
 * @ Royal Day		1
 * @ War Day		2
 * @ Hide and Seek	3
 * @ Catch The Duck	4
 * @ Zombie Day		5
 * @ Nazi Day		6
*/

/*********************************************************
 * Checks if any Jailbreak day is enabled
 *
 * @true on match , false if not
 *********************************************************/
native bool JailBreakDays_Enabled();

/*********************************************************
 * Checks which Jailbreak Day is enabled
 *
 * @ > 0 if any day is enabled, 0 if it isn't
 *********************************************************/
native int JailBreakDays_GetDay();

/*********************************************************
 * Activates a day
 * @ client			Client's Index
 * @ day			Day's Index
 *********************************************************/
native void JailBreakDays_Activate(int client, int day);

/*********************************************************
 * Activates a day
 * @ day			Day's Index
 *********************************************************/
native void JailBreakDays_Deactivate(int day);

/*********************************************************
 * Called when a day has been activated
 *
 * @param client		Jailbreak Day's Index
 * @NoReturn	
 *********************************************************/
forward void JailBreakDays_OnDayActivate(int day);
```

<h1> I'll continue to give support to this plugin after 10th of July</h1>

I hope you enjoyed, and I'll keep this repository updated as soon as I update the plugin!

My Steam Profile if you have any questions -> http://steamcommunity.com/id/HallucinogenicTroll/

My Website -> http://HallucinogenicTrollConfigs.com/
