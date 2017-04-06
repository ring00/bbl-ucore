#include "bbl.h"
#include <string.h>
#include "atomic.h"
#include "bits.h"
#include "mtrap.h"
#include "vm.h"

extern void _entry(void);

void boot_loader() {
    // extern char _payload_start, _payload_end;
    // load_kernel_elf(&_payload_start, &_payload_end - &_payload_start, &info);
    // supervisor_vm_init();
    // #ifdef PK_ENABLE_LOGO
    print_logo();
    // sbi_set_timer(0x11111111111110ULL);
    // sbi_shutdown();
    // #endif
    mb();
    enter_supervisor_mode((void *)_entry, 0);
}

void boot_other_hart() {
    while (1)
        ;
    mb();
    enter_supervisor_mode((void *)_entry, 0);
}
