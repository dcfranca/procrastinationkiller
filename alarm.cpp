#include "include/precisiontimer.h"

PrecisionTimer::PrecisionTimer(QObject *parent) : QTimer(parent)
{
    this->setTimerType(Qt::PreciseTimer);
    connect(this, &PrecisionTimer::timeout, this, &PrecisionTimer::handleTimeOut);
}

PrecisionTimer::~PrecisionTimer()
{

}

void PrecisionTimer::handleTimeOut()
{
    emit triggered();
}

