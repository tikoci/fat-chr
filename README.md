# RouterOS CHR for UTM 

### Ready-to-use Mikrotik RouterOS CHR for UTM*

If you have an Intel Mac, and UTM is already installed, you can install most release release here automatically.  __* Only Intel-based macOS with UTM installed is supported__, currently no support for Apple Silicon-based macOS.

## Install 
### Use <a href="utm://downloadVM?url=https://github.com/tikoci/chr-utm/releases/latest/RouterOS.utm.zip">Install RouterOS via URL</a> to download and install RouterOS automatically

#### Alternatively, you can download the `RouterOS.utm.zip` from GitHub Releases, which will also load automatically.

#### To instal UTM virtual machine manager... download from either https://mac.getutm.app/ or [Mac App Store](https://apps.apple.com/us/app/utm-virtual-machines/id1538878817?mt=12).  Once UTM is installed, then use [Install RouterOS via URL](utm://downloadVM?url=https://github.com/tikoci/chr-utm/releases/latest/RouterOS.utm.zip) or download the `.zip` from Releases.





> [!TIP]
>
> For problems, please report on [Mikrotik's forum](https://forum.mikrotik.com/viewtopic.php?t=184254), or file an [issue](https://github.dev/tikoci/chr-utm/issues) in GitHub.
>
>


## About UTM and RouterOS
[UTM](https://mac.getutm.app/) is open source virtual machine host for Apple macOS, which avaialble for download, or via Mac App Store.  CHR is a Mikrotik RouterOS disk image for virtual machines, which is full operational, but bandwidth limited.  See [Mikrotik's CHR](https://help.mikrotik.com/docs/spaces/ROS/pages/18350234/Cloud+Hosted+Router+CHR#CloudHostedRouter,CHR-CHRLicensing) page for details on RouterOS limits and licensing details.  

> While, RouterOS images for ARM _should_ work with UTM on ARM-based macOS, using QEMU mode.  Feel free to make a pull request, or issue with `.plist` and other details for ARM support.


## Technical Notes

* The package here use "Apple Virtualization" mode in UTM, as more direct path to OS services than QEMU.


* Turns out UTM virtual machines are just ZIP files. So, "build" here is really a `zip` of the CHR image with associated `.plist` (and logo for fun).  

* To work under Apple's Virtualization Framework, the Mikrotik's CHR RAW image must be converted to a  FAT partition to the required EUFI boot.  But this repo re-uses same re-partitioning scripts from [tikoci/fat-chr](https://github.dev/tikoci/chr-utm/issues).  And instead of posting the raw image files, the Release is a `.zip` which works with UTM's URL monikers to allow for "Click to Install" 

* The URL works because UTM implements Apple URL handlers, so `utm://downloadVM?url=` routes to the UTM app, with a URL to a `.zip` file.   
```
utm://downloadVM?url=https://example.com/.../vm.utm.zip
```
And, that's how the "Install via URL" works.