#ifndef EXTENSIONMANAGER_H
#define EXTENSIONMANAGER_H

#include <QObject>
#include <QStringList>
#include <QString>
#include <QResource>
#include <QDir>
#include <QDebug>
#include <QResource>

class ExtensionManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QStringList extensions READ extensions)
public:
    explicit ExtensionManager(QObject *parent = 0);
    ~ExtensionManager();

    QStringList extensions() {
        QStringList list = QStringList();

        foreach( const QString &entry, QDir(":extensions").entryList() )
        {
            if (QDir(":extensions/" + entry).exists()) {
                list << entry;
            }
        }

        return list;
    }


signals:

public slots:
};

#endif // EXTENSIONMANAGER_H
