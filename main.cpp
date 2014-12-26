#include <QApplication>
#include <QQmlApplicationEngine>
#include <QSystemTrayIcon>
#include <QMessageBox>
#include <QAction>
#include <QMenu>
#include <QDebug>
#include <QQmlContext>

#include "include/extensionmanager.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    ExtensionManager extMng;
    engine.rootContext()->setContextProperty("extMng", &extMng);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
