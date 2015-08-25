#ifndef ApplicationUI_HPP_
#define ApplicationUI_HPP_

#include <QObject>
#include <bb/system/InvokeRequest.hpp>
#include <bb/system/InvokeManager>
#include <bb/platform/bbm/Context>
#include <bb/platform/bbm/MessageService>
#include <bb/platform/bbm/UserProfile>

using bb::system::InvokeRequest;
using bb::system::InvokeManager;
using namespace bb::system;

namespace bb
{
    namespace cascades
    {
        class Application;
        class LocaleHandler;
    }
}

class QTranslator;


class ApplicationUI : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool purchasedAds READ getPurchasedAds WRITE setPurchasedAds NOTIFY purchasedAdsChanged)

public:

    ApplicationUI(bb::cascades::Application *app);
    virtual ~ApplicationUI() { }

    bool getPurchasedAds();
    Q_INVOKABLE void setPurchasedAds(bool value);

    Q_INVOKABLE int getDeviceHeight();
    Q_INVOKABLE int getDeviceWidth();

    Q_INVOKABLE void inviteUserToDownloadViaBBM();
    Q_INVOKABLE void updatePersonalMessage(const QString &message);

    Q_INVOKABLE void flurrySetUserID(QString value);
    Q_INVOKABLE void flurryLogError(QString value);
    Q_INVOKABLE void flurryLogEvent(QString value);

    Q_INVOKABLE void notify(QString title, QString body);

    Q_INVOKABLE QString getSetting(const QString &objectName, const QString &defaultValue);
    Q_INVOKABLE void setSetting(const QString &objectName, const QString &inputValue);

signals:
    void purchasedAdsChanged(bool);

private slots:

    void onSystemLanguageChanged();

private:

    bool purchasedAds;

    QTranslator* m_pTranslator;
    bb::cascades::LocaleHandler* m_pLocaleHandler;

    InvokeManager* _invokeManager;

    bb::platform::bbm::UserProfile * m_userProfile;
    bb::platform::bbm::Context *m_context;
    bb::platform::bbm::MessageService *m_messageService;
    Q_SLOT void registrationStateUpdated(bb::platform::bbm::RegistrationState::Type state);

};

#endif /* ApplicationUI_HPP_ */
