# SpaghettOS

SpaghettOS is a simple toy operating system developed for didactic purposes. It is 32bit OS that runs on x86 architecture. It is written in C and Assembly. 

## Features
- [X] Bootloader
- [X] GDT
- [X] 32 bit mode (protected mode)
- [X] IDT
- [X] IRQ
- [X] Keyboard driver
- [X] VGA driver
- [X] Timer
- [ ] Shell
- [ ] Memory management
- [ ] File system
- [ ] User mode
- [ ] Multithreading
- [ ] ...

## How to run

### Make
It can be run by using Make, assuming that you are on a x86 machine, and have all the necessary tools installed. 

```bash
make run
```
### Docker
For simpler setup, you can use Docker. There is a script that allows you to download in the container all the required tools and then run it. You will just need to have Docker installed and run the script that was created for this purpose.

```bash
chmod +x ./scripts/build_n_run_docker.sh
./scripts/build_n_run_docker.sh
```

## Sources
- [OS Wiki](https://wiki.osdev.org/Expanded_Main_Page)
- [os-tutorial Repository](https://wiki.osdev.org/Expanded_Main_Page)