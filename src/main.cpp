#include "applicationui.hpp"
#include <bb/cascades/Application>
#include <Flurry.h>
#include <src/ParseAPI/ParseAPI.hpp>
#include <src/WebImageView/WebImageView.hpp>
#include <bb/ApplicationInfo>

using namespace bb::cascades;

Q_DECL_EXPORT int main(int argc, char **argv)
{
    #if !defined(QT_NO_DEBUG)
        Flurry::Analytics::SetDebugLogEnabled(false);
    #endif

    Flurry::Analytics::SetAppVersion(bb::ApplicationInfo().version());
    Flurry::Analytics::SetSecureTransportEnabled(true);
    Flurry::Analytics::StartSession("Z2D92RP8NBKSQKJGCM9N");

    qmlRegisterType<ParseAPI>("nemory.ParseAPI", 1, 0, "ParseAPI");
    qmlRegisterType<WebImageView>("nemory.WebImageView", 1, 0, "WebImageView");

    Application app(argc, argv);
    new ApplicationUI(&app);
    return Application::exec();
}
