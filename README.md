# ffmpeg-custom-compile

This is my custom ffmpeg compilation script. Imported from [GitLab Snippet](https://gitlab.com/snippets/1732779).

Below is an imported changelog from the GitLab Snippet.

## Update 2019-02-17

* Updated NASM version
* Added AV1 support
* Fixed some flags

## Update 2019-02-20

Minor overhaul of script.
* Decided to compile everything that's still updated.
* Script makes sure to remove any currently installed versions of anything we install with the script to prevent any weird version conflicts or having multiple versions of the same shit installed at once, in general.
* Colored the `echo` messages so they stand out amongst the current console spam.
* As a "sub-task" of the above, I need to master `&> /dev/null` for silencing all of the console spam.
* Updated the script to warn that `sudo` access is required right off the bat.
* Silenced some of the console spam with `-qq` for all of the `apt-get` parts.
* Added `libx265` to the script at all (was not in at all previously).

-----

Part 2: Silenced all of the spammy console output. Note included to troubleshoot issues.

## Update 2019-04-03

* Minor overhaul of script to get it working again. Not 100% what all actually changed, but it should be working on Ubuntu 18+ again.
* Simplified the suppressing of output into console

## Update 2020-03-05
### V7.1

Fixed x264 URL:
* Old: https://git.videolan.org/git/x264
* New: https://code.videolan.org/videolan/x264

# Update 2020-07-05

**v7.2**: Updated NASM version from `2.14.02` to `2.15.02`.

# Update 2020-07-31

**v7.5**:
* Updated NASM version from `2.15.02` to `2.15.03`.
* Now installs `libgnutls28-dev`
* Added `--enable-gnutls` and `--enable-openssl` to the ffmpeg compile.

# Update 2020-08-17

**v7.6**:
* Removed `libgnutls28-dev` package installation
* Removed `--enable-gnutls` compile flag for ffmpeg

**v7.7**:
* Fixed nasm section.

# Update 2020-09-04

**v7.9**:
* Fixed x265 compilation
* Shifted around some pieces

# Update 2020-09-12

**v8.0**:
* Updated nasm from `2.15.03` to `2.15.05`

# Update 2020-12-07

**v9.0**:
Script had actually been broken for some time...this fixes everything that was wrong.
* add installation of `libunistring-dev` and `libgnutls28-dev` packages
* fixed `compileLibx265()` section by removing depth from `git clone`
* changed `--enable-openssl` to `--enable-gnutls` as the former didn't actually work with `--enable-gpl`...
* added `--enable-libwebp` **which only works if the host has previously compiled `libwebp` for their system**...will work later to add this to script — consider removing this line if it's not needed
