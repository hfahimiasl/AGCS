#pragma once

#include <QObject>
#include <QMap>
#include <QVariantList>
#include <QApplication>


class SystemSettings : public QObject
{
	Q_OBJECT

public:
	enum SystemSettingsEnum {
		//app
		AppPreviousInstalledVersion,

		// quit clock
		QuitClock,

		// map
		MapProvider,
		MapType,
		MapZoomLevel,
		MapCenterLatitude,
		MapCenterLongitude,
		MapAirspacePageMainEnabled,
		MapAirspacePageMissionEnabled,
		MapAirTrafficPageMainEnabled,
		MapAirTrafficPageMissionEnabled,

		// link
		LinkLastConnectionType,
		LinkLastSerialPort,
		LinkLastSerialBaudRate,
		LinkLastTCPPort,
		LinkLastTCPHost,
		LinkLastUDPPort,
		LinkLastUDPHost,

		// gui
		GUITheme,

		// units
		UnitsDistance,
		UnitsSpeed,
		UnitsVoltage,

		// user authentication
		UserTTL,
		UserAccessToken,
		UserRefreshToken,
		UserAuthAccesses,
		UserAuthActive,
		UserAuthAddress,
		UserAuthAvatar,
		UserAuthBalance,
		UserAuthBio,
		UserAuthBirthday,
		UserAuthCreatedAt,
		UserAuthEmail,
		UserAuthEmailVerify,
		UserAuthEXP,
		UserAuthFatherName,
		UserAuthFirstName,
		UserAuthIAT,
		UserAuthID,
		UserAuthLastName,
		UserAuthLastSignIn,
		UserAuthNationalCode,
		UserAuthPhone,
		UserAuthPhoneVerify,
		UserAuthUpdatedAt,

		// user scheduling
		UserUpTime,
		UserAircraftConnectionTime,
		UserAircraftArmTime,

		// server
		ServerLatestVersion,
		ServerMandatoryUpdate,
		ServerDownloadLink
	};

	Q_ENUM(SystemSettingsEnum)

	static const QMap<SystemSettingsEnum, QVariantList> SystemSettingsMap;
};

Q_DECLARE_METATYPE(SystemSettings::SystemSettingsEnum)
