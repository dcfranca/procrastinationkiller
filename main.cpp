#include <QApplication>
#include <QQmlApplicationEngine>
#include <QSystemTrayIcon>
#include <QMessageBox>
#include <QAction>
#include <QMenu>
#include <QDebug>
#include <QQmlContext>
#include <QQmlEngine>
#include <QtQml>
#include "include/precisiontimer.h"

#include "include/extensionmanager.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    ExtensionManager extMng;
    engine.rootContext()->setContextProperty("extMng", &extMng);
    qmlRegisterType<PrecisionTimer>("com.dfranca.tools", 1, 0, "PrecisionTimer");
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
