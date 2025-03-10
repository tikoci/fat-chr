# fat-chr

*Builder for a UEFI-enabled RouterOS CHR image using GitHub Action.*

> [!TIP]
> If these images are required on some virtualized platform/cloud, and Mikrotik's official downloads DO NOT WORK on same platform - please let me know either as [issue](https://github.com/tikoci/fat-chr/issues) here or on [Mikrotik's forum](https://forum.mikrotik.com/viewtopic.php?t=184254) – as I've been collecting data.  The current summary is:
> * **Apple Virtualization Framework**  On Intel, all images should work - see [chr-utm](https://github.com/tikoci/chr-utm), which use Apple-based virtualization to run CHR.  On ARM-based M1/M2/M3, **No** have been reported to work using Apple Virtualization, but do work without re-packaging with QEMU on ARM64.
> * **Vultr** - Mikrotik images only work because the [instructions suggest SystemRescueCD and `dd`](https://help.mikrotik.com/docs/display/ROS/CHR+Vultr+installation), reported that the "@jaclaz method" (used in all post-7.15 [releases](https://github.com/tikoci/fat-chr/releases) work _without_  Mikrotik's "`dd` approach", see [this post](https://forum.mikrotik.com/viewtopic.php?t=184254&hilit=EUFI#p1100169)
> * **Oracle Cloud using ARM64/Amprere**  Reported that _experimental_ ARM64 7.17beta2 image worked (all other packages are Intel-only).  See @BetaQuasi comment in https://github.com/tikoci/fat-chr/issues/5#issuecomment-2394976574

## <mark>NEW</mark> "ready-to-run" CHR virtual machines for macOS UTM 
Please see [tikoci/mikropkl](https://github.com/tikoci/mikropkl) for details.  This project support **both** Apple and QEMU virtual machines for Mac.   The QEMU images are which uses the images build here to support Apple Virtualization in it's UTM RouterOS CHR packages. But with [UTM](https://mac.getutm.app) installed, adding CHR as a virtual machine is now one command.  For example, for 7.19beta4 on ARM-based Mac, it's just:
```
open 'utm://downloadVM?url=https://github.com/tikoci/mikropkl/releases/download/chr-7.19beta4/rose.chr.aarch64.qemu.7.19beta4.utm.zip'
```
See [Releases](https://github.com/tikoci/mikropkl/releases) in the `tikoci/mikropkl` projects for more details and `utm` URLs for specific versions/configuration/architecture.

> Another project [tikoci/chr-utm](https://github.com/tikoci/chr-utm) built only Apple virtualization images, but this repo was combined into newer [tikoci/mikropkl](https://github.com/tikoci/mikropkl) UTM packaging project.


## Use Case
Mikrotik's virtual machine version of RouterOS ("CHR") is downloadable as a RAW image.  However, this image is incompatible with UEFI-based bootloaders.  Specifically, Apple's Virtualization Framework for [Intel-based MacOS to run RouterOS CHR](https://forum.mikrotik.com/viewtopic.php?t%253D204805#p1057569)
which has now evolved in the [tikoci/mikropkl](https://github.com/tikoci/mikropkl) to build both Apple and QEMU CHR images.

## Implementation Notes
Non-EUFI raw images for "stable" and "testing" for latest version are downloaded.  CI will convert the partitioning scheme from EXT2 to FAT16 using `gdisk` & publish as a release.
Various workflow scripts have been across versions, see [.github/workflows](https://github.com/tikoci/fat-chr/blob/main/.github/workflows) in repo.

Most use "workflow_dispatch" on the "Build and Release" to manual trigger a specific build to fetch older/specific versions & select a script to run.  All builds marked as "pre-release" in Releases and must be manually changed to remove the flag. No check is done if a version was already build, so duplicates can be deleted manually.  

The newest build script [auto.yaml](https://github.com/tikoci/fat-chr/blob/main/.github/workflows) essentially does a RouterOS "check-for-upgrade", and only builds an image if an RouterOS version is not in GitHub [Releases].  This allows it to be as a "cron" (currently daily) to check for new version and build if needed.  Previous build script were all manually triggered by maintainer. 

## Variants and Credits 
* [@kriszos's posting](https://forum.mikrotik.com/viewtopic.php?p=1025068&hilit=UEFI#p933799) on the Mikrotik forum "QG" bash script to convert the CHR raw image from EXT2 to FAT16 script, and do some modifications of the partition tables.  All images prior to 7.15, are built using this script.  CHR Version 7.15 introduced overlapping partitions, so @kriszos's script no longer worked.  
* [@jaclaz's hybrid diatribes](https://forum.mikrotik.com/viewtopic.php?p=1100753&hilit=uefi#p1098260) create a newer version that processed the overlap in `gdisk`.  This script is used in CHR 7.15 and above images.
* [@Amm0]() added the "no-gdisk variant script, which does not change the partition table, instead it only does a conversion from `ext2` to `fat` of the EFI partition.  One use case for the CHR images here is Apple Virtualization support, which just need EFI partition to be `fat` (_i.e._ MacOS has no support for mounting ext2, and per UEFI specs it should be `fat`).  
* [alecthw/mikrotik-routeros-chr-efi](https://github.com/alecthw/mikrotik-routeros-chr-efi) version use a GitHub Action based modification in 7.18.1, and perhaps future.  The disk modification is similar to the "no-gdisk" bash script used in 7.18.0.  But instead of invoking `bash`, GitHub workflow runs each command as a step.  For a CI prospective, this a better approach.  The script was enhanced to support "check-for-update" and only build if a release is not found.



> #### Disclaimers
> **Not affiliated, associated, authorized, endorsed by, or in any way officially connected with MikroTik, Apple, UTM from Turing Software, LLC, nor Ubuntu.**
> While the code in this project is released to public domain (see LICENSE),  CHR image contains software subject to MikroTik's Terms and Conditions, see [MIKROTIKLS MIKROTIK SOFTWARE END-USER LICENCE AGREEMENT](https://mikrotik.com/downloadterms.html).
> **Any trademarks and/or copyrights remain the property of their respective holders** unless specifically noted otherwise.
> Use of a term in this document should not be regarded as affecting the validity of any trademark or service mark. Naming of particular products or brands should not be seen as endorsements.
> MikroTik is a trademark of Mikrotikls SIA.
> Apple and macOS are trademarks of Apple Inc., registered in the U.S. and other countries and regions. UNIX is a registered trademark of The Open Group. 
> **No liability can be accepted.** No representation or warranty of any kind, express or implied, regarding the accuracy, adequacy, validity, reliability, availability, or completeness of any information is offered.  Use the concepts, code, examples, and other content at your own risk. There may be errors and inaccuracies, that may of course be damaging to your system. Although this is highly unlikely, you should proceed with caution. The author(s) do not accept any responsibility for any damage incurred. 