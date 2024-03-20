#pragma once

#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTimer>
#include <QDebug>

#include "libs/QObjectListModel/qobjectlistmodel.h"
#include "libs/QObjectListModel/qgadgetlistmodel.h"
#include "libs/QObjectListModel/qobjectproxymodel.h"

#include "src/System/Geographical.h"
#include "src/Mission/MissionService.h"

#include "PatternSingleItem.h"
#include "PatternGroupItem.h"
#include "AgricultureInfo.h"
#include "PhotographyInfo.h"
#include "PatternPathWorker.h"
#include "PatternRenderWorker.h"


class PatternService : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QVariantList         polygonPath     READ getPolygonPath     NOTIFY polygonPathChanged)
	Q_PROPERTY(QVariantList         polylinePath    READ getPolylinePath    NOTIFY polylinePathChanged)
	Q_PROPERTY(PatternSingleItem   *polygonCenter   READ getPolygonCenter   CONSTANT)
	Q_PROPERTY(PatternSingleItem   *startPoint      READ getStartPoint      CONSTANT)
	Q_PROPERTY(PatternSingleItem   *endPoint        READ getEndPoint        CONSTANT)

public:
	explicit PatternService(QObject *, QQmlApplicationEngine *);
	~PatternService();

	static PatternService *instance(QObject * = nullptr, QQmlApplicationEngine * = nullptr);

signals:
	void polygonPathChanged();
	void polylinePathChanged();
	void cornerSelected(const quint16 &sequence);
	void renderStarted();
	void renderCanceled();
	void renderCompleted();
	void renderProgress(const double &progress);

public slots:
	int cornerSize() const;
	QModelIndex indexOfCorner(const quint16 &);
	void appendCorner(const QGeoCoordinate &);
	void insertCorner(const quint16 &, const QGeoCoordinate &);
	void updateCorner(const quint16 &, const QGeoCoordinate &);
	void selectCorner(const quint16 &);
	void removeCorner(const quint16 &);
	void clear();

	PatternGroupItem *getCornerItem(const quint16 &);
	PatternSingleItem *getPolygonCenter() const;
	PatternSingleItem *getStartPoint() const;
	PatternSingleItem *getEndPoint() const;
	AgricultureInfo *getAgricultureInfo() const;
	PhotographyInfo *getPhotographyInfo() const;

	QVariantList getPolygonPath();
	QVariantList getPolylinePath();

	void moveTo(const QGeoCoordinate &);

	void updateAgricultureInfo();
	void renderAgriculturePattern();

	double photographyCalculation(const double &, const double &, const double &, const double &) const;
	void updatePhotographyInfo();
	void renderPhotographyPattern();

	void cancelRenderProcess() const;

private:
	QGenericListModel<PatternGroupItem> *corner_model {nullptr};
	QGenericListModel<PatternGroupItem> *insert_point_model {nullptr};
	PatternSingleItem *polygon_center {nullptr};
	PatternSingleItem *start_point {nullptr};
	PatternSingleItem *end_point {nullptr};
	AgricultureInfo *agriculture_info {nullptr};
	PhotographyInfo *photography_info {nullptr};
	PatternPathWorker *path_worker {nullptr};
	PatternRenderWorker *render_worker {nullptr};

	double grid_spacing {qQNaN()};
	double grid_angle {qQNaN()};

	QList<QPair<QGeoCoordinate, QGeoCoordinate>> waypoint_pair_list;

	QList<QPair<QGeoCoordinate, QGeoCoordinate>> worker_waypoint;

	int insertPointSize() const;
	QModelIndex indexOfInsertPoint(const quint16 &);
	void insertInsertPoint(const PatternGroupItem &);

	void clearCorner();
	void clearInsertPoint();

	void notifyAndUpdate();

	void setGridSpacing(const double &);
	void setGridAngle(const double &);
	void buildPath();
};
