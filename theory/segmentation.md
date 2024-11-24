# Segmentation
Segmentation is the division of the memory in chunchs of bits/bytes. Depending on the mode, software version etc. there are different types of segmentations and the way they behave differs. 

## Real mode
Real mode is a simple mode that has 16 bit of addressing (which are 64kiB of total addressable memory), that is not a lot. This has therfore some limitations. Anyway, for compatibility reasons, x86 always start in Real more. 

## Segmentation as a solution
For this, we decided to segment the memory. Segments are therefore set of memory of up to 64kiB. The most important segments are: 
- Data
    - Register `ds`
- Code
    - Register `cs`
- Stack
    - Register `ss`
- Extra:
    - Register `es`

To represent access to any of these, we use the notation `<segment>:<offset>` (IE: `ds:62400` -> `800:62400` = `16 * 800 + 62400`, that gives us the absolute address). 

So, to make an example, the operation `[org 0x7c00]` is the same as doing `mov ds, 0x7c0` since that value times 16 is the value that we expect. Every time that we access data, code or the stack, we apply the offset. 

## Tiny model
The tiny model is just a model in which we set all `ds` = `cs` = `ss` = `0`