#pragma once

#include <QObject>
#include <QTimer>

#include "src/Mission/MissionService.h"

#include "AgricultureInfo.h"
#include "PhotographyInfo.h"


class PatternRenderWorker : public QObject
{
	Q_OBJECT

public:
	explicit PatternRenderWorker(QObject * = nullptr);
	~PatternRenderWorker();

	void render(const QList<QPair<QGeoCoordinate, QGeoCoordinate>> &, const AgricultureInfo *, const bool &);
	void render(const QList<QPair<QGeoCoordinate, QGeoCoordinate>> &, const PhotographyInfo *, const bool &);

	void cancel();

signals:
	void renderStarted();
	void renderCanceled();
	void renderCompleted();
	void renderProgress(const double &);

private slots:
	void agricultureWorker();
	void photographyWorker();

private:
	const quint16 kTimeout {20};

	QTimer *agriculture_timer {nullptr};
	QTimer *photography_timer {nullptr};

	AgricultureInfo *agriculture_info {nullptr};
	PhotographyInfo *photography_info {nullptr};

	bool notification {true};
	quint16 sequence {0};

	QList<QPair<QGeoCoordinate, QGeoCoordinate>> waypoint_pair_list;

	quint16 size() const;
	bool inProgress() const;
	void reset();
};
