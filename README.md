# fat-chr

*Builder for a UEFI-enabled RouterOS CHR image using GitHub Action.*

## Use Case
Mikrotik's virtual machine version of RouterOS ("CHR") is downloadable as a RAW image.  However, this image is incompatible with UEFI-based bootloaders.  Specifically, Apple's Virtualization Framework for [Intel-based MacOS to run RouterOS CHR](https://forum.mikrotik.com/viewtopic.php?t%253D204805#p1057569)

## Implementation Notes
Non-EUFI raw images for "stable" and "testing" for latest version are downloaded.  CI will convert the partitioning scheme from EXT2 to FAT16 using `gdisk` & publish as a release.
* **CI builder** https://github.com/tikoci/fat-chr/blob/main/.github/workflows/build.yaml
* **Raw Image Converter Script** https://github.com/tikoci/fat-chr/blob/main/build.bash

There is "workflow_dispatch" on the "Build and Release" to manual trigger a specific build to fetch older/specific versions & select a script to run.  All builds marked as "pre-release" in Releases and must be manually changed to remove the flag. No check is done if a version was already build, so duplicates can be deleted manually.  

## Variants and Credits 
* [@kriszos's posting](https://forum.mikrotik.com/viewtopic.php?p=1025068&hilit=UEFI#p933799) on the Mikrotik forum "QG" bash script to convert the CHR raw image from EXT2 to FAT16 script, and do some modifications of the partition tables.  All images prior to 7.15, are built using this script.  CHR Version 7.15 introduced overlapping partitions, so @kriszos's script no longer worked.  
* [@jaclaz's hybrid diatribes](https://forum.mikrotik.com/viewtopic.php?p=1100753&hilit=uefi#p1098260) create a newer version that processed the overlap in `gdisk`.  This script is used in CHR 7.15 and above images.
* [@Amm0]() added the "no-gdisk variant script, which does not change the partition table, instead it only does a conversion from `ext2` to `fat` of the EFI partition.  One use case for the CHR images here is Apple Virtualization support, which just need EFI partition to be `fat` (_i.e._ MacOS has no support for mounting ext2, and per UEFI specs it should be `fat`).  

## Use at your own risk...
[See GitHub statement on open source](https://opensource.guide/notices/)
