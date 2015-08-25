#ifndef UTILITIES_H_
#define UTILITIES_H_

#include <QtCore/QObject>
#include <QtCore/QFile>
#include <QtCore/QtCore>
#include <stdint.h>

class Utilities : public QObject
{
    Q_OBJECT

public:
    Utilities(QObject* parent = 0);

    Q_INVOKABLE static int64_t headlessMemory();
    Q_INVOKABLE static bool contains(QString text, QString find);
    Q_INVOKABLE static void notifyRegular(QString title, QString message);
    Q_INVOKABLE static void writeLogToFile(QString log, QString fileName);
    Q_INVOKABLE static QString getStringFromFile(QString fileName);
    Q_INVOKABLE static QString getSetting(const QString &objectName, const QString &defaultValue);
	Q_INVOKABLE static void setSetting(const QString &objectName, const QString &inputValue);

	Q_INVOKABLE static QString getAPIKey();
	Q_INVOKABLE static QString getAPISecret();

	static bool user0connected;
	static bool user1connected;
	static bool user2connected;
	static bool user3connected;
	static bool user4connected;

};

#endif /* UTILITIES_H_ */

