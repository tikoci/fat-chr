# fat-chr

*WIP - resulting Mikrtok CHR with FAt16 boot partion are under GitHub Actions as artifacts & more working on version is needed to fully automate*

Builder for a UEFI-enabled CHR image using GitHub Action's builder.  Non-EUFI raw images are downloaded from Mikrotik as part of a workflow & CI will convert the paritioning scheme from EXT2 to FAT16 using `gdisk`.  

**Credits** 
@kriszos's posting on the Mikrotik forum, https://forum.mikrotik.com/viewtopic.php?p=1025068&hilit=UEFI#p933799, which had a bash script to convert the CHR raw image.
