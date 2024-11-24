# Disk
We cannot rely entirely on the boot sector, since it is limited. We will therefore use this location to point to the disk and start out kernel from there. 

## CHS addressing
If we are trying to read an hard drive, we need to know how this is constructed. There are multiple platter, that are different disks, in different cylinders. There are multiple head to read from each of them. The platter is divided in sectors of 512 bytes, and to know from where to grab the data from, we need to know all of these information. 

More formally, we need to know what Cylinder (C), Head (H) and Sector (S) we want to access. Therefore, we have out CHS addressing. Note that C and H start form 0, while S starts from 1. 

## Read from the disk
To read from the disk, we need to set the following: 
- `ah` to be the starting sector (IE: `2` as the sector right after boot sector)
- `al` to be the number of sector we want to read (IE" `1`)
- `ch` to be the cylinder number (IE: `0`)
- `cl` to be the sector number (IE: `2`)
- `dh` to be the head number (IE: `0`)
- `dl` to be the disk/drive number (IE: usually in a variable. In `dl` there is the boot drive)
- `es` to be extra sector (IE: `0`)
- `bx` to be the base (IE: `0x7e00`)
Then call the interrupt `0x13` 