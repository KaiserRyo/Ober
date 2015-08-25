/****************************************************************************
** Meta object code from reading C++ file 'Utilities.hpp'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.5)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/Utilities/Utilities.hpp"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'Utilities.hpp' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.5. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_Utilities[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       9,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // methods: signature, parameters, type, tag, flags
      19,   10,   11,   10, 0x02,
      51,   41,   36,   10, 0x02,
      91,   77,   10,   10, 0x02,
     135,  122,   10,   10, 0x02,
     184,  175,  167,   10, 0x02,
     235,  211,  167,   10, 0x02,
     285,  263,   10,   10, 0x02,
     313,   10,  167,   10, 0x02,
     325,   10,  167,   10, 0x02,

       0        // eod
};

static const char qt_meta_stringdata_Utilities[] = {
    "Utilities\0\0int64_t\0headlessMemory()\0"
    "bool\0text,find\0contains(QString,QString)\0"
    "title,message\0notifyRegular(QString,QString)\0"
    "log,fileName\0writeLogToFile(QString,QString)\0"
    "QString\0fileName\0getStringFromFile(QString)\0"
    "objectName,defaultValue\0"
    "getSetting(QString,QString)\0"
    "objectName,inputValue\0setSetting(QString,QString)\0"
    "getAPIKey()\0getAPISecret()\0"
};

void Utilities::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        Utilities *_t = static_cast<Utilities *>(_o);
        switch (_id) {
        case 0: { int64_t _r = _t->headlessMemory();
            if (_a[0]) *reinterpret_cast< int64_t*>(_a[0]) = _r; }  break;
        case 1: { bool _r = _t->contains((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 2: _t->notifyRegular((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 3: _t->writeLogToFile((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 4: { QString _r = _t->getStringFromFile((*reinterpret_cast< QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        case 5: { QString _r = _t->getSetting((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        case 6: _t->setSetting((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2]))); break;
        case 7: { QString _r = _t->getAPIKey();
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        case 8: { QString _r = _t->getAPISecret();
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        default: ;
        }
    }
}

const QMetaObjectExtraData Utilities::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject Utilities::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_Utilities,
      qt_meta_data_Utilities, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &Utilities::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *Utilities::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *Utilities::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_Utilities))
        return static_cast<void*>(const_cast< Utilities*>(this));
    return QObject::qt_metacast(_clname);
}

int Utilities::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 9)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 9;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
