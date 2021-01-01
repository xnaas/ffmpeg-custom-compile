#!/bin/bash
#########################
## This script is used ##
## to install and/or   ##
## update ffmpeg using ##
## custom settings for ##
## non-free stuffs.    ##
##                     ##
##      Author: xnaas  ##
##      Version: v9.23 ##
#########################
## For troubleshooting ##
## just remove all     ##
## instances of:       ##
##                     ##
##    &> /dev/null     ##
##                     ##
## from this file.     ##
#########################

## Cleanup Old Junk
cleanupOld(){
rm -rf ffmpeg_build
rm -rf ffmpeg_sources
yes | sudo apt-get remove -qq \
  nasm \
  libx264-dev \
  libx265-dev \
  libvpx-dev \
  libfdk-aac-dev \
  libopus-dev
}

## Install Prerequisites
installLibs(){
yes | sudo apt-get update -qq && sudo apt-get upgrade -qq && sudo apt-get install -qq \
  autoconf \
  automake \
  build-essential \
  cmake \
  git \
  libass-dev \
  libfreetype6-dev \
  libtool \
  libvorbis-dev \
  pkg-config \
  texinfo \
  wget \
  zlib1g-dev \
  yasm \
  mercurial \
  libnuma-dev \
  openssl \
  libmp3lame-dev \
  libnuma-dev \
  libunistring-dev \
  libgnutls28-dev
}

## Compile nasm
compileNasm(){
cd ~/ffmpeg_sources && \
wget https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.bz2 && \
tar xjvf nasm-2.15.05.tar.bz2 && \
cd nasm-2.15.05 && \
./autogen.sh && \
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && \
make -j$(nproc) && \
make -j$(nproc) install
}

## Compile libx264
compileLibx264(){
cd ~/ffmpeg_sources && \
git -C x264 pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/x264 && \
cd x264 && \
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --enable-pic && \
PATH="$HOME/bin:$PATH" make -j$(nproc) && \
make -j$(nproc) install
}

## Compile libx265
compileLibx265(){
cd ~/ffmpeg_sources && \
git -C x265_git pull 2> /dev/null || git clone https://bitbucket.org/multicoreware/x265_git && \
cd x265_git/build/linux && \
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off ../../source && \
PATH="$HOME/bin:$PATH" make -j$(nproc) && \
make -j$(nproc) install
}

## Compile libvpx
compileLibvpx(){
cd ~/ffmpeg_sources && \
git -C libvpx pull 2> /dev/null || git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git && \
cd libvpx && \
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm && \
PATH="$HOME/bin:$PATH" make -j$(nproc) && \
make -j$(nproc) install
}

## Compile libfdk-aac
compileLibfdkaac(){
cd ~/ffmpeg_sources && \
git -C fdk-aac pull 2> /dev/null || git clone --depth 1 https://github.com/mstorsjo/fdk-aac && \
cd fdk-aac && \
autoreconf -fiv && \
./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
make -j$(nproc) && \
make -j$(nproc) install
}

## Compile libopus
compileLibOpus(){
cd ~/ffmpeg_sources && \
git -C opus pull 2> /dev/null || git clone --depth 1 https://github.com/xiph/opus.git && \
cd opus && \
./autogen.sh && \
./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
make -j$(nproc) && \
make -j$(nproc) install
}

## Compile ffmpeg
compileFfmpeg(){
cd ~/ffmpeg_sources && \
wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
tar xjvf ffmpeg-snapshot.tar.bz2 && \
cd ffmpeg && \
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --extra-libs="-lpthread -lm" \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-gnutls \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree && \
PATH="$HOME/bin:$PATH" make -j$(nproc) && \
make -j$(nproc) install && \
hash -r
}

## Cleanup
cleanupNew(){
echo "Cleaning up files..."
rm -rf ~/ffmpeg_sources
rm -rf ~/ffmpeg_build
}

## Add ffmpeg to Profile
profileAdd(){
echo "Adding ffmpeg to profile path..."
echo "If this doesn't work, re-source your profile."
. ~/.profile
}

## The Process
cd ~
echo -e "\e[91mNote: This script requires sudo access. Ctrl+C now if you do not have sudo access.\033[0m"
echo -e "\e[91mNote: Some of these steps can take a very long time. Please be patient.\033[0m"
echo "Removing old shit..."
cleanupOld &> /dev/null
mkdir ffmpeg_sources
echo "Installing prerequisites..."
installLibs &> /dev/null
echo "Installing nasm..."
compileNasm &> /dev/null
echo "Installing libx264..."
compileLibx264 &> /dev/null
echo "Installing libx265..."
compileLibx265 &> /dev/null
echo "Installing libvpx..."
compileLibvpx &> /dev/null
echo "Installing libfdk-aac..."
compileLibfdkaac &> /dev/null
echo "Installing libopus..."
compileLibOpus &> /dev/null
echo "Compiling ffmpeg...buckle up!"
compileFfmpeg &> /dev/null
cleanupNew
profileAdd
echo "Completed! Type 'ffmpeg' to verify."
