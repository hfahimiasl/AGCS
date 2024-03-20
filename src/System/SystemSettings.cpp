#include "SystemSettings.h"


const QMap<SystemSettings::SystemSettingsEnum, QVariantList> SystemSettings::SystemSettingsMap {
	//app
	{AppPreviousInstalledVersion, {"AppPreviousInstalledVersion", ""}},

	// quit clock
	{QuitClock, {"QuitClock", 0}},

	// map
	{MapProvider,                       {"MapProvider",                     "Google"}},
	{MapType,                           {"MapType",                         "Hybrid"}},
	{MapZoomLevel,                      {"MapZoomLevel",                    6.0}},
	{MapCenterLatitude,                 {"MapCenterLatitude",               32.11095690093547}},
	{MapCenterLongitude,                {"MapCenterLongitude",              54.45612667436535}},
	{MapAirspacePageMainEnabled,        {"MapAirspacePageMainEnabled",      false}},
	{MapAirspacePageMissionEnabled,     {"MapAirspacePageMissionEnabled",   false}},
	{MapAirTrafficPageMainEnabled,      {"MapAirTrafficPageMainEnabled",    false}},
	{MapAirTrafficPageMissionEnabled,   {"MapAirTrafficPageMissionEnabled", false}},

	// link
	{LinkLastConnectionType,    {"LinkLastConnectionType",  0}},
	{LinkLastSerialPort,        {"LinkLastSerialPort",      ""}},
	{LinkLastSerialBaudRate,    {"LinkLastSerialBaudRate",  5}},
	{LinkLastTCPPort,           {"LinkLastTCPPort",         ""}},
	{LinkLastTCPHost,           {"LinkLastTCPHost",         ""}},
	{LinkLastUDPPort,           {"LinkLastUDPPort",         ""}},
	{LinkLastUDPHost,           {"LinkLastUDPHost",         ""}},

	// gui
	{GUITheme, {"GUITheme", "LIGHT"}},

	// units
	{UnitsDistance, {"UnitsDistance",   2}},
	{UnitsSpeed,    {"UnitsSpeed",      0}},
	{UnitsVoltage,  {"UnitsVoltage",    1}},

	// user authentication
	{UserTTL,               {"UserTTL",                 0}},
	{UserAccessToken,       {"UserAccessToken",         ""}},
	{UserRefreshToken,      {"UserRefreshToken",        ""}},
	{UserAuthAccesses,      {"UserAuthAccesses",        ""}},
	{UserAuthActive,        {"UserAuthActive",          false}},
	{UserAuthAddress,       {"UserAuthAddress",         ""}},
	{UserAuthAvatar,        {"UserAuthAvatar",          ""}},
	{UserAuthBalance,       {"UserAuthBalance",         0}},
	{UserAuthBio,           {"UserAuthBio",             ""}},
	{UserAuthBirthday,      {"UserAuthBirthday",        ""}},
	{UserAuthCreatedAt,     {"UserAuthCreatedAt",       ""}},
	{UserAuthEmail,         {"UserAuthEmail",           ""}},
	{UserAuthEmailVerify,   {"UserAuthEmailVerify",     false}},
	{UserAuthEXP,           {"UserAuthEXP",             0}},
	{UserAuthFatherName,    {"UserAuthFatherName",      ""}},
	{UserAuthFirstName,     {"UserAuthFirstName",       ""}},
	{UserAuthIAT,           {"UserAuthIAT",             0}},
	{UserAuthID,            {"UserAuthID",              ""}},
	{UserAuthLastName,      {"UserAuthLastName",        ""}},
	{UserAuthLastSignIn,    {"UserAuthLastSignIn",      ""}},
	{UserAuthNationalCode,  {"UserAuthNationalCode",    ""}},
	{UserAuthPhone,         {"UserAuthPhone",           ""}},
	{UserAuthPhoneVerify,   {"UserAuthPhoneVerify",     false}},
	{UserAuthUpdatedAt,     {"UserAuthUpdatedAt",       ""}},

	// user scheduling
	{UserUpTime,                    {"UserUpTime",                  0}},
	{UserAircraftConnectionTime,    {"UserAircraftConnectionTime",  0}},
	{UserAircraftArmTime,           {"UserAircraftArmTime",         0}},

	// security
	{ServerLatestVersion,   {"ServerLatestVersion",     "0.0.0"}},
	{ServerMandatoryUpdate, {"ServerMandatoryUpdate",   false}},
	{ServerDownloadLink,    {"ServerDownloadLink",      ""}}
};
