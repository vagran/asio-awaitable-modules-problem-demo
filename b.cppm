export module B;

import A;

export int
BFunc()
{
    return TestFunc() + 1;
}

export int
main()
{
    return BFunc();
}
