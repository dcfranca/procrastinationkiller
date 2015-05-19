#include "include/alarm.h"

Alarm::Alarm(QObject *parent) : QObject(parent)
{
    m_timerAlarm.setTimerType(Qt::PreciseTimer);
    connect(&m_timerInterval, &QTimer::timeout, this, &Alarm::handleTriggered);
    connect(&m_timerAlarm, &QTimer::timeout, this, &Alarm::handleTimeout);
}

Alarm::~Alarm()
{

}

void Alarm::handleTimeout()
{
    qDebug() << "Emiting timeout...";
    emit timeout();
}

void Alarm::handleTriggered()
{
    emit triggered();
}

