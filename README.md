# fat-chr

*Builder for a UEFI-enabled RouterOS CHR image using GitHub Action.*

## Use Case
Mikrotik's virtual machine version of RouterOS ("CHR") is downloadable as a RAW image.  However, this image is incompatible with UEFI-based bootloaders.  Specifically, Apple's Virtualization Framework for [Intel-based MacOS to run RouterOS CHR](https://forum.mikrotik.com/viewtopic.php?t%253D204805#p1057569)

## Implementation Notes
Non-EUFI raw images for "stable" and "testing" for latest version are downloaded.  CI will convert the paritioning scheme from EXT2 to FAT16 using `gdisk` & publish as a release.
* **CI builder** https://github.com/tikoci/fat-chr/blob/main/.github/workflows/build.yaml
* **Raw Image Converter Script** https://github.com/tikoci/fat-chr/blob/main/build.bash

#### TODOs
#1 #2 

## Credits 
[@kriszos's posting](https://forum.mikrotik.com/viewtopic.php?p=1025068&hilit=UEFI#p933799) on the Mikrotik forum which had a bash script to convert the CHR raw image from EXT2 to FAT16 script.

## Use at your own risk...
[See GitHub statement on open source](https://opensource.guide/notices/)