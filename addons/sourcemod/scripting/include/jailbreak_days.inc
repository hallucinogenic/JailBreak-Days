#if defined _jailbreak_included
  #endinput
#endif
#define _jailbreak_included

/*
 * DAYS INDEXES
 * @ Royal Day	1
 * @ War Day	2
 * @ Escondidas	3
 * @ Apanhadas	4
 * @ Zombie Day	5
 * @ Nazi Day	6
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