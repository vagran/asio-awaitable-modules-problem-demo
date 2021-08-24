#ifdef MODULES
export module main;

import <iostream>;

#else

#include <iostream>

#endif

#ifdef MODULES
export
#endif
int
main()
{
    ([](){ std::cout << "callback 1\n"; })();
    ([](){ std::cout << "callback 2\n"; })();
    return 0;
}
