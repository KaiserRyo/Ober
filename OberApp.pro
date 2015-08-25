APP_NAME = OberApp

CONFIG += qt warn_on cascades10

QT 	+= network
QT 	+= declarative

LIBS += -lbb
LIBS += -lbbdata
LIBS += -lbbsystem
LIBS += -lbbplatformbbm 
LIBS += -lbbplatform
LIBS += -lQtLocationSubset

LIBS += -lbbdevice
LIBS += -lscreen
LIBS += -lcrypto
LIBS += -lcurl
LIBS += -lpackageinfo

include(config.pri)
