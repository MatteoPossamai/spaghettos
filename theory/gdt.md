# GDT

## Protected mode
This is a 32 bit (address up to 4GB of memory). In this mode you could implement paging and multitasking, in C/C++ probably. But we need now to switch from [Real Mode](https://wiki.osdev.org/Real_Mode). 

### How to switch
We need to set up segmentation. Do do so, we need to address a number of caracteristics of the memory, that are stored in the Global Desscriptor Table ([GDT](https://wiki.osdev.org/Global_Descriptor_Table)).

For each segment there is a given descriptor, which is a list of information about it, segmentation, paging and so on. It is using flat memory model (not multi level segmentation as in Real Mode). There are a number of different data that are saved in the GDT. For a easily digestible guide on them, look [this video](https://www.youtube.com/watch?v=Wh5nPn2U_1w&t=5s). 

