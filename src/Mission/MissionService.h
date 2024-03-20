#pragma once

#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>

#include "libs/QObjectListModel/qobjectlistmodel.h"
#include "libs/QObjectListModel/qgadgetlistmodel.h"
#include "libs/QObjectListModel/qobjectproxymodel.h"

#include "libs/mavlink/v2.0/ardupilotmega/mavlink.h"
#include "src/Aircraft/protocol/mavlink/MAVLinkProtocolHelpers.h"

#include "src/Mission/MissionItem.h"
#include "src/Mission/TakeoffItem.h"
#include "src/Mission/WaypointItem.h"
#include "src/Mission/LandItem.h"

#include "src/System/Toast.h"


class MissionService : public QObject
{
	Q_OBJECT
	Q_PROPERTY(bool         takeoffExist    READ isTakeoffExist     NOTIFY takeoffExistChanged)
	Q_PROPERTY(bool         landExist       READ isLandExist        NOTIFY landExistChanged)
	Q_PROPERTY(bool         rtlExist        READ isRTLExist         NOTIFY rtlExistChanged)
	Q_PROPERTY(QVariantList path            READ getPath            NOTIFY pathChanged)

public:
	explicit MissionService(QObject *, QQmlApplicationEngine *);
	~MissionService();

	static MissionService *instance(QObject * = nullptr, QQmlApplicationEngine * = nullptr);

	void clear();

signals:
	void notifyClear();
	void notifyDownload();
	void notifyDownloadSize(const quint16 &size);
	void notifyDownloadFailed();
	void notifyDownloadComplete();
	void notifyUpload();
	void notifyUploadSize(const quint16 &size);
	void notifyUploadFailed();
	void notifyUploadComplete();
	void notifyMissionStart();
	void notifyMissionComplete();
	void notifyProgress(const double &progress);

	void takeoffExistChanged();
	void landExistChanged();
	void rtlExistChanged();
	void pathChanged();

	void takeoffSelected();
	void waypointSelected(const quint16 &sequence);
	void landSelected();

public slots:
	int size() const;
	QModelIndex indexOf(const quint16 &);
	QModelIndex indexOf(const MAV_CMD &);
	bool isExist(const quint16 &);
	void insert(MissionItem *);
	MissionItem *get(const quint16 &);
	MissionItem *getLastVisualItem();

	TakeoffItem *getRawTakeoff();
	TakeoffItem *getTakeoff();
	void appendTakeoff(TakeoffItem *);
	void updateTakeoff(TakeoffItem *);
	bool isTakeoffExist();

	WaypointItem *getRawWaypoint();
	WaypointItem *getWaypoint(const quint16 &);
	void appendWaypoint(WaypointItem *);
	void updateWaypoint(WaypointItem *, const quint16 &);
	bool removeWaypoint(const quint16 &);

	LandItem *getRawLand();
	void appendLand(LandItem *);
	bool isLandExist();
	bool removeLand();

	void appendRTL();
	bool isRTLExist();
	bool removeRTL();

	void select(const quint16 &);

	QVariantList getPath();

	void print();

private:
	QGenericListModel<MissionItem> *mission_item_model {nullptr};
	TakeoffItem *takeoff_item {nullptr};
	WaypointItem *waypoint_item {nullptr};
	LandItem *land_item {nullptr};

	const QList<MAV_CMD> kVisibleCommands {
		MAV_CMD::MAV_CMD_NAV_WAYPOINT,
		MAV_CMD::MAV_CMD_NAV_LAND,
	};

	static constexpr double kDefaultSpeed {5.0};

	bool remove(const quint16 &, const quint16 & = 1);

	void appendTakeoffPrivate(const TakeoffItem *);
	void updateTakeoffPrivate(const TakeoffItem *);
	void appendWaypointPrivate(const WaypointItem *);
	void updateWaypointPrivate(const WaypointItem *, const quint16 &);
	void appendLandPrivate(const LandItem *);
	void appendRTLPrivate();

	void updateSpeedItem(const WaypointItem *, MissionItem *, const quint16 &);
	void updateRelayItem(const WaypointItem *, MissionItem *, const quint16 &);
	void updateServoItem(const WaypointItem *, MissionItem *, const quint16 &);
	void updateGimbalItem(const WaypointItem *, MissionItem *, const quint16 &);
	void updateCameraTriggerItem(const WaypointItem *, MissionItem *, const quint16 &);

	void updateLabel(MissionItem *);

	void notifyChanges();

	void validationTakeoffCoordinate();
};
