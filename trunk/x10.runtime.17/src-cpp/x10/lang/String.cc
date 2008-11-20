#include <x10aux/alloc.h>

#include <x10/lang/String.h>
#include <x10/lang/Rail.h>

using namespace x10::lang;
using namespace x10aux;

x10_int String::hashCode() {
    //FIXME:
    //presumably this needs a general hashcode implementation
    //that is centralised and used everywhere
    return 0;
}

ref<String> String::toString() {
    return this;
}

x10_boolean String::equals(const ref<Object>& other) {
    if (!CONCRETE_INSTANCEOF(other,String)) return false;
    // now we can downcast the Object to String
    String &other_str = static_cast<String&>(*other);
    // defer to std::string::compare to check string contents
    return !compare(other_str);
}
    


String String::operator+(const String& s) {
    return String(static_cast<const std::string&>(*this)
         + static_cast<const std::string&>(s));
}

x10_int String::indexOf(const ref<String>& str, x10_int i) {
    size_type res = find(static_cast<const std::string&>(*str), (size_type)i);
    if (res == std::string::npos)
        return (x10_int) -1;
    return (x10_int) res;
}

x10_int String::indexOf(x10_char c, x10_int i) {
    size_type res = find((char)c, (size_type)i);
    if (res == std::string::npos)
        return (x10_int) -1;
    return (x10_int) res;
}

x10_int String::lastIndexOf(const ref<String>& str, x10_int i) {
    size_type res = rfind(static_cast<const std::string&>(*str), (size_type)i);
    if (res == std::string::npos)
        return (x10_int) -1;
    return (x10_int) res;
}

x10_int String::lastIndexOf(x10_char c, x10_int i) {
    size_type res = rfind((char)c, (size_type)i);
    if (res == std::string::npos)
        return (x10_int) -1;
    return (x10_int) res;
}

String String::substring(x10_int start, x10_int end) {
    return String(static_cast<const std::string&>(*this).substr(start, end-start));
}

x10_char String::charAt(x10_int i) {
    return (x10_char) at(i);
}


ref<Rail<x10_char> > String::toCharRail() {
    x10_int sz = size();
    Rail<x10_char> *rail = alloc_rail<x10_char,Rail<x10_char> > (sz);
    for (int i=0 ; i<sz ; i++)
        (*rail)[i] = (x10_char)at(i);
    return rail;
}

std::ostream &operator << (std::ostream &o, x10aux::ref<x10::lang::String> s)
{
    if (s.isNull()) {
        o << "null";
    } else {
        o <<*s;
    }

    return o;
}


DEFINE_RTT(String);
// vim:tabstop=4:shiftwidth=4:expandtab
