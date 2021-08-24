#ifdef MODULES

module;

#include <signal.h>

export module main;

import asio;
import <iostream>;

#else

#include <signal.h>
#include <iostream>
#include <asio/awaitable.hpp>
#include <asio/signal_set.hpp>
#include <asio/use_awaitable.hpp>
#include <asio/co_spawn.hpp>

#endif

asio::awaitable<void>
MainTask()
{
    std::cout << "In main task\n";
    co_return;
}

asio::io_context mainCtx;

void
OnSignalComplete(std::exception_ptr error)
{
    if (error) {
        std::cout << "signal error\n";
    }
    std::cout << "signal completed\n";
}

void
OnMainComplete(std::exception_ptr error)
{
    if (error) {
        std::cout << "main error\n";
    }
    std::cout << "main complete\n";
    mainCtx.stop();
}

#ifdef MODULES
export
#endif
int
main()
{

    int exitCode = 0;

    asio::signal_set signals(mainCtx, SIGINT, SIGTERM, SIGUSR1);
    asio::co_spawn(mainCtx, [&]() -> asio::awaitable<void> {
        while (true) {
            std::cout << "waiting signal\n";
            int sig = co_await signals.async_wait(asio::use_awaitable);
            if (sig == SIGINT || sig == SIGTERM) {
                std::cout << "Exiting on signal " << sig << "\n";
                mainCtx.stop();
                exitCode = 1;
                break;
            }
            std::cout << "Signal received: " << sig << "\n";
        }
    }, OnSignalComplete);

    asio::co_spawn(mainCtx, MainTask(), OnMainComplete);

    mainCtx.run();

    return exitCode;
}
