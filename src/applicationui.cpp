#include "applicationui.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/cascades/LocaleHandler>
#include <bb/PackageInfo>
#include <bb/platform/Notification>
#include <Flurry.h>
#include <bb/system/SystemDialog>
#include <bb/device/DisplayInfo>

using bb::PackageInfo;
using namespace bb::cascades;
using bb::platform::Notification;
using namespace bb::system;
using bb::device::DisplayInfo;

const QString AUTHOR     = "NEMORY";
const QString APPNAME    = "OBER";

ApplicationUI::ApplicationUI(bb::cascades::Application *app) :
        QObject(app)
{
    m_pTranslator = new QTranslator(this);
    m_pLocaleHandler = new LocaleHandler(this);

    bool res = QObject::connect(m_pLocaleHandler, SIGNAL(systemLanguageChanged()), this, SLOT(onSystemLanguageChanged()));
    Q_ASSERT(res);
    Q_UNUSED(res);
    onSystemLanguageChanged();

    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);
    qml->setContextProperty("_app", this);

    PackageInfo packageInfo;
    QDeclarativePropertyMap* map = new QDeclarativePropertyMap(this);
    map->setProperty("version", packageInfo.version());
    map->setProperty("author", packageInfo.author());
    qml->setContextProperty("_packageInfo", map);

    AbstractPane *root = qml->createRootObject<AbstractPane>();
    app->setScene(root);

    m_context = new bb::platform::bbm::Context(QUuid("30ed1c79-3c7f-4671-8a15-14721bb2077f"));

    if (m_context->registrationState() != bb::platform::bbm::RegistrationState::Allowed)
    {
        connect(m_context, SIGNAL(registrationStateUpdated (bb::platform::bbm::RegistrationState::Type)), this, SLOT(registrationStateUpdated (bb::platform::bbm::RegistrationState::Type)));
        m_context->requestRegisterApplication();
    }

    purchasedAds        = getSetting("purchasedAds", "false") == "true";
    setPurchasedAds(purchasedAds);
}

QString ApplicationUI::getSetting(const QString &objectName, const QString &defaultValue)
{
    QSettings settings(AUTHOR, APPNAME);

    if (settings.value(objectName).isNull() || settings.value(objectName) == "")
    {
        return defaultValue;
    }

    return settings.value(objectName).toString();
}

void ApplicationUI::setSetting(const QString &objectName, const QString &inputValue)
{
    QSettings settings(AUTHOR, APPNAME);
    settings.setValue(objectName, QVariant(inputValue));
}

bool ApplicationUI::getPurchasedAds()
{
    return purchasedAds;
}

void ApplicationUI::setPurchasedAds(bool value)
{
    purchasedAds = value;
    emit purchasedAdsChanged(value);
}

int ApplicationUI::getDeviceHeight()
{
    DisplayInfo display;
    return display.pixelSize().height();
}

int ApplicationUI::getDeviceWidth()
{
    DisplayInfo display;
    return display.pixelSize().width();
}

void ApplicationUI::onSystemLanguageChanged()
{
    QCoreApplication::instance()->removeTranslator(m_pTranslator);
    QString locale_string = QLocale().name();
    QString file_name = QString("Tinder_%1").arg(locale_string);

    if (m_pTranslator->load(file_name, "app/native/qm"))
    {
        QCoreApplication::instance()->installTranslator(m_pTranslator);
    }
}


void ApplicationUI::inviteUserToDownloadViaBBM()
{
    if (m_context->registrationState() == bb::platform::bbm::RegistrationState::Allowed)
    {
        m_messageService->sendDownloadInvitation();
    }
    else
    {
        SystemDialog *bbmDialog = new SystemDialog("OK");
        bbmDialog->setTitle("BBM Connection Error");
        bbmDialog->setBody("BBM is not currently connected. Please setup / sign-in to BBM to remove this message.");
        connect(bbmDialog, SIGNAL(finished(bb::system::SystemUiResult::Type)), this, SLOT(dialogFinished(bb::system::SystemUiResult::Type)));
        bbmDialog->show();
        return;
    }
}

void ApplicationUI::updatePersonalMessage(const QString &message)
{
    if (m_context->registrationState() == bb::platform::bbm::RegistrationState::Allowed)
    {
        m_userProfile->requestUpdatePersonalMessage(message);
    }
    else
    {
        SystemDialog *bbmDialog = new SystemDialog("OK");
        bbmDialog->setTitle("BBM Connection Error");
        bbmDialog->setBody("BBM is not currently connected. Please setup / sign-in to BBM to remove this message.");
        connect(bbmDialog, SIGNAL(finished(bb::system::SystemUiResult::Type)), this, SLOT(dialogFinished(bb::system::SystemUiResult::Type)));
        bbmDialog->show();
        return;
    }
}

void ApplicationUI::registrationStateUpdated(bb::platform::bbm::RegistrationState::Type state)
{
    if (state == bb::platform::bbm::RegistrationState::Allowed)
    {
        m_messageService = new bb::platform::bbm::MessageService(m_context,this);
        m_userProfile = new bb::platform::bbm::UserProfile(m_context, this);
    }
    else if (state == bb::platform::bbm::RegistrationState::Unregistered)
    {
        m_context->requestRegisterApplication();
    }
}

void ApplicationUI::flurrySetUserID(QString value)
{
    Flurry::Analytics::SetUserID(value);
}

void ApplicationUI::flurryLogError(QString value)
{
    Flurry::Analytics::LogError(value);
}

void ApplicationUI::flurryLogEvent(QString value)
{
    Flurry::Analytics::LogEvent(value);
}

void ApplicationUI::notify(QString title, QString body)
{
    Notification* notification = new Notification();
    notification->setTitle(title);
    notification->setBody(body);

    // 10.2
    notification->setIconUrl(QUrl("app/native/assets/notificationIcon.png")) ;

    InvokeRequest invokeRequest;
    invokeRequest.setTarget("com.nemory.timber.hub.invoke.open");
    invokeRequest.setAction("bb.action.OPEN");
    invokeRequest.setMimeType("text/plain");
    notification->setInvokeRequest(invokeRequest);

    notification->notify();
}
