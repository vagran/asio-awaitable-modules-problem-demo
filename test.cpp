import callback;
import call;
import <iostream>;

int
main()
{
    Callback cbk1([&]() {
        std::cout << "callback 1\n";
    });

    Callback cbk2([&]() {
        std::cout << "callback 2\n";
    });

    cbk1();
    cbk2();

    TestCall();

    return 0;
}
