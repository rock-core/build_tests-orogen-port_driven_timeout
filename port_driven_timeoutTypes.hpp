#ifndef port_driven_timeout_TYPES_HPP
#define port_driven_timeout_TYPES_HPP

#include <base/Time.hpp>

namespace port_driven_timeout {
    struct InData {
        base::Time time;
    };

    struct OutData {
        base::Time last_received;
        base::Time time;
    };
}

#endif

