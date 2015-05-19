#ifndef PRECISIONTIMER_H
#define PRECISIONTIMER_H

#include <QObject>
#include <QTimer>

class PrecisionTimer : public QTimer
{
    Q_OBJECT
public:
    explicit PrecisionTimer(QObject *parent = 0);
    ~PrecisionTimer();

signals:
    void triggered();

public slots:
    void handleTimeOut();
};

#endif // PRECISIONTIMER_H
