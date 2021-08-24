export module callback;

import <functional>;

export class Callback {
public:
    template <typename F>
    Callback(F f):
        f(f)
    {}

    void
    operator()()
    {
        f();
    }

    std::function<void()> f;
};
