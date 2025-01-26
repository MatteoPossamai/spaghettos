unsigned char port_byte_in (unsigned short port) {
    unsigned char result;
    // in instruction: reads from a port
    // dx: takes the port from which to read
    // al: register with results
    __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
    return result;
}

void port_byte_out (unsigned short port, unsigned char data) {
    // out instruction: put to port
    // al: data to put
    // dx: port to query
    __asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}

unsigned short port_word_in (unsigned short port) {
    // same as port_byte_in but with more data (ax instead of al)
    unsigned short result;
    __asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));
    return result;
}

void port_word_out (unsigned short port, unsigned short data) {
    // same as port_byte_out but with more data (ax instead of al)
    __asm__("out %%ax, %%dx" : : "a" (data), "d" (port));
}

/*

*/