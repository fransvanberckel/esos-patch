# esos-patch
ESOS (Enterprise Storage OS) hardware patch

## About why?

Why did you choose to patch the Linux kernel? It's because ESOS does not support my server mainboard. And was looking for something easy to use.

## About how?

What I did is installing and running # lspci -k to show kernel drivers handling each device. Adjust the ESOS kernel configuration. Created a patchset next. Build the kernel. Copy the build to thumb drive. And update the Grub bootloader configuration for my kernel.

```
$ ls -l misc/

total 8
-rw-r--r-- 1 frans frans 1802 Dec 10 06:55 linux-5.4.229.mcp55.config_patch
-rw-r--r-- 1 frans frans  959 Dec 10 06:55 linux-5.4.229.p5k.config_patch
```
Wanna know more about ESOS (Enterprise Storage OS), you should checkout there [website](https://www.esos-project.com/)

## Usage

To build the ESOS kernel with my linux-5.4.229.mcp55.config_patch do.

```
$ wget https://raw.githubusercontent.com/fransvanberckel/esos-patch/master/linux-builder.sh
$ nano ./linux-builder.sh
$ chmod +x linux-builder.sh
$ ./linux-builder.sh
```

## How to Contribute by Forking and Submitting a Pull Request

For creating your own ESOS Linux kernel you should fork and then submit a pull request. This is useful if you are proposing multiple repo changes

 1. Fork on GitHub.
 1. Clone the fork locally.
 1. Work on your Linux kernel patch
 1. Test the build
 1. Push the code to GitHub.
 1. Send a Pull Request on GitHub.

## Author

The repository was created in 2023 by [Frans van Berckel](https://www.fransvanberckel.nl)
