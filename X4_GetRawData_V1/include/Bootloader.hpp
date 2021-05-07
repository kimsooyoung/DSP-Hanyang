#ifndef BOOTLOADERINTERFACE_HPP
#define BOOTLOADERINTERFACE_HPP

#include "Bytes.hpp"
#include <memory>

struct Logger;

namespace XeThru {
class AbstractLoggerIo;
class BootloaderImpl;

class Bootloader
{
public:
    Bootloader(
        const std::string & device_name,
        bool log_to_stdout,
        bool log_to_file,
        unsigned int log_level);
    Bootloader(
        const std::string & device_name,
        unsigned int log_level);
    Bootloader(
        const std::string & device_name,
        unsigned int log_level,
        AbstractLoggerIo * logger_io);
    Bootloader(
        const std::string & device_name,
        Logger * logger);
    ~Bootloader();

    int write_page(
        unsigned int page_address,
        const Bytes & page_data);
    int start_application();
    int start_application(unsigned int timeout);
    std::string get_bootloader_info();

private:
    std::unique_ptr<BootloaderImpl> pimpl;
};

}

#endif
