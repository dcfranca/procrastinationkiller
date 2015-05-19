#ifndef ALARM_H
#define ALARM_H

#include <QObject>
#include <QTimer>
#include <QDebug>

class Alarm : public QObject
{
    Q_OBJECT

    Q_PROPERTY(unsigned int time READ time WRITE setTime)
public:
    explicit Alarm(QObject *parent = 0);
    ~Alarm();

    unsigned int time() const
    {
        return m_time;
    }

    Q_INVOKABLE void stop() {
        m_timerAlarm.stop();
        m_timerInterval.stop();
    }

    Q_INVOKABLE void start() {
        if (!m_time)
            return;

        qDebug() << "Timer::Time: " << m_time * 1000;

        m_timerInterval.setInterval(500);
        m_timerAlarm.setInterval(m_time * 1000);

        m_timerInterval.start();
        m_timerAlarm.start();
    }

private:
    QTimer m_timerInterval;
    QTimer m_timerAlarm;

    unsigned int m_time;

signals:
    void triggered();
    void timeout();

    void timeChanged(unsigned int arg);

public slots:
    void handleTimeout();
    void handleTriggered();
    void setTime(unsigned int arg)
    {
        if (m_time == arg)
            return;

        m_time = arg;
    }
};

#endif // ALARM_H
