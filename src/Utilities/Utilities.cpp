#include "Utilities.hpp"

#include <bb/platform/Notification>
#include <bb/system/InvokeManager>
#include <sys/procfs.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <stdint.h>

using namespace bb::platform;

const QString AUTHOR                    = "NEMORY";
const QString APPNAME                   = "TWITTLY";

//const QString API_KEY    = "ovh2OJuh3UtBN3xyQkl0JPq2y"; //TWITTLY
//const QString API_SECRET = "yQo81PCL71jRw3jiDMXTrLAytfxZ7RGwjUVKckyc7kuRJ3tpoL";

//const QString API_KEY    = "IQKbtAYlXLripLGPWd0HUA"; //IPHONE
//const QString API_SECRET = "GgDYlkSvaPxGxC4X8liwpUoqKwwr3lCADbz8A7ADU";

//const QString API_KEY    = "yN3DUNVO0Me63IAQdhTfCA"; //WINDOWS PHONE
//const QString API_SECRET = "c768oTKdzAjIYCmpSNIdZbGaG0t6rOhSFQP0S5uC79g";

//const QString API_KEY    = "3rJOl1ODzm9yZy63FACdg"; //MAC
//const QString API_SECRET = "5jPoQ5kQvMJFDYRNE8bQ4rHuds4xJqhvgNJM4awaE8";

//const QString API_KEY    = "CjulERsDeqhhjSme66ECg"; //IPAD
//const QString API_SECRET = "IQWdVyqFxghAtURHGeGiWAsmCAGmdW3WmbEx6Hck";

//const QString API_KEY    = "3nVuSoBZnx6U4vzUxf5w"; //ANDROID
//const QString API_SECRET = "Bcs59EFbbsdF6Sl9Ng71smgStWEGwXXKSjYvPVt7qys";

//const QString API_KEY    = "iAtYJ4HpUVfIUoNnif1DA"; //GOOGLE TV
//const QString API_SECRET = "172fOpzuZoYzNYaU3mMYvE8m8MEyLbztOdbrUolU";

const QString API_KEY    = "yT577ApRtZw51q4NPMPPOQ"; //TWEETDECK
const QString API_SECRET = "3neq3XqN5fO3obqwZoajavGFCUrC42ZfbrLXy5sCv8";

//const QString API_KEY    = "xFjeV2TSkMlfSojBuNig"; //WHERES MY PHONE
//const QString API_SECRET = "Pli1hDpXAPYW2vzk2cMNgZicIooX8OxO5yhdcCdOA";

Utilities::Utilities(QObject* parent) : QObject(parent)
{

}

void Utilities::notifyRegular(QString title, QString message)
{
    QString purchasedAdsString = getStringFromFile("data/purchasedAds.json");
    QString notificationsString = getStringFromFile("data/notifications.json");

    qDebug() << "#### Service::notifyRegular purchasedAdsString: " + purchasedAdsString+ ", notificationsString: " + notificationsString + ", title: " + title + ", message: " + message;

    if(purchasedAdsString == "true" && notificationsString == "true")
    {
        Notification* notification = new Notification();
        notification->setTitle(title);
        notification->setBody(message);
        notification->setIconUrl(QUrl("app/native/assets/media/images/icons/114.png")) ;

        bb::system::InvokeRequest invokeRequest;
        invokeRequest.setTarget("com.nemory.twittly.blackberry.invoke.open");
        invokeRequest.setAction("bb.action.OPEN");
        invokeRequest.setMimeType("text/plain");

        notification->setInvokeRequest(invokeRequest);
        notification->notify();

        delete notification;
    }
}

void Utilities::writeLogToFile(QString log, QString fileName)
{
    QFile file("data/" + fileName);
    file.open(QIODevice::WriteOnly | QIODevice::Text);
    QTextStream out(&file);
    out << log;
    file.close();
    file.deleteLater();
    fileName.clear();
    log.clear();
    out.flush();
}

QString Utilities::getAPIKey()
{
    return API_KEY;
}

QString Utilities::getAPISecret()
{
    return API_SECRET;
}

QString Utilities::getStringFromFile(QString fileName)
{
    QString fileString = "";

    QFile theFile(fileName);

    if(theFile.open(QIODevice::ReadOnly))
    {
        QTextStream fileBytes(&theFile);
        fileString = fileBytes.readAll();
        fileBytes.flush();
    }

    theFile.close();
    theFile.deleteLater();
    fileName.clear();

    return fileString;
}

QString Utilities::getSetting(const QString &objectName, const QString &defaultValue)
{
	QSettings settings(AUTHOR, APPNAME);

	if (settings.value(objectName).isNull() || settings.value(objectName) == "")
	{
		return defaultValue;
	}

	QString value = settings.value(objectName).toString();

	settings.deleteLater();

	return value;
}

void Utilities::setSetting(const QString &objectName, const QString &inputValue)
{
	QSettings settings(AUTHOR, APPNAME);
	settings.setValue(objectName, QVariant(inputValue));
	settings.deleteLater();
}

bool Utilities::contains(QString text, QString find)
{
    return text.contains(find, Qt::CaseInsensitive);
}

int64_t Utilities::headlessMemory()
{
    int rc, n, i, num;
    int64_t memsize = -1ll;
    procfs_mapinfo *maps = NULL;
    int fd = open("/proc/self/as", O_RDONLY);

    if (fd == -1)
          return -1ll;
    do
    {
          rc = devctl(fd, DCMD_PROC_PAGEDATA, NULL, 0, &num);
          if (rc)
                 goto cleanup;
          maps = (procfs_mapinfo*) realloc(maps, num * sizeof(*maps));
          if (!maps)
                 goto cleanup;

          // pre-subtract the allocation we just made, rounded up to page size
          memsize = 0ll - ((num * sizeof(*maps) + __PAGESIZE - 1) & ~(__PAGESIZE - 1));
          rc = devctl(fd, DCMD_PROC_PAGEDATA, maps, num * sizeof(*maps), &n);

          if (rc)
          {
             memsize = -1ll;
             goto cleanup;
          }
    }
    while (n > num);

    for (i = 0; i < n; i++)
    {
          if ((maps[i].flags & (MAP_ANON | MAP_STACK | MAP_ELF | MAP_TYPE)) == (MAP_ANON | MAP_PRIVATE))
          {
             memsize += maps[i].size;
          }
    }

    cleanup: close(fd);
    free(maps);

    //qDebug() << "#### Service::headlessMemory(): " << memsize;

    return memsize;
}
