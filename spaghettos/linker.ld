ENTRY(_start)
SECTIONS
{
    . = 0x1000;
    .text : {
        *(.text)
    } :text

    .rodata : {
        *(.rodata)
    } :rodata

    .data : {
        *(.data)
    } :data

    .bss : {
        *(COMMON)
        *(.bss)
    } :data
}

PHDRS {
    text PT_LOAD FLAGS(5);   /* Read + Execute */
    rodata PT_LOAD FLAGS(4); /* Read-only */
    data PT_LOAD FLAGS(6);   /* Read + Write */
}