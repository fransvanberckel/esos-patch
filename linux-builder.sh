#!/usr/bin/env bash

target_dir="/usr/src"

yum_dependencies="lsscsi kpartx libxslt bc wget gettext dosfstools"
apt_dependencies="python3 git-core build-essential libncurses-dev bison flex libssl-dev libelf-dev fakeroot dwarves bc"

kernel_version="5.4.229"
kernel_name="linux-$kernel_version"

builder_home="https://github.com/osresearch"
builder_repo="linux-builder"
builder_branche="HEAD"

esos_home="https://github.com/quantum"
esos_repo="esos"
esos_branche="HEAD"

patch_home="https://github.com/fransvanberckel"
patch_repo="esos-patch"
patch_branche="HEAD"
patch_name="mcp55"

sudo_cmd=$(which sudo)
chmod_cmd=$(which chmod)
mkdir_cmd=$(which mkdir)
python3_cmd=$(which python3)
patch_cmd=$(which patch)
yum_cmd=$(which yum)
apt_cmd=$(which apt-get)
cpu_info=$(grep -c ^processor /proc/cpuinfo)

if [[ ! -z $yum_cmd ]]; then \
   $sudo_cmd $yum_cmd --yes groupinstall "Development tools" ; \
   $sudo_cmd $yum_cmd --yes install $yum_dependencies ; \
elif [[ ! -z $apt_cmd ]]; then \
   $sudo_cmd $apt_cmd -qq update 2>&1 ; \
   $sudo_cmd $apt_cmd --yes --quiet install $apt_dependencies ; \
else
   echo "Error can't install kernel dependencies, aborting."
   exit 1;
fi;

if cd $target_dir >/dev/null 2>&1; then \
   $sudo_cmd $chmod_cmd ugo+rwx $target_dir ; \
   echo "... Okay"; \
else \
   $sudo_cmd $mkdir_cmd -p $target_dir && $sudo_cmd $chmod_cmd ugo+rwx $target_dir && cd $target_dir ; \
fi;

if cd $builder_repo >/dev/null 2>&1; then \
   echo "... Okay" && cd ..; \
else \
   git clone -n $builder_home/$builder_repo.git --depth=1; \
fi;

if cd $builder_repo ; then \
   git checkout $builder_branche $builder_repo && cd ..; \
else \
   echo "No $builder_repo checkout possible, aborting."; \
   exit 1;
fi;

if cd $esos_repo >/dev/null 2>&1; then \
   echo "... Okay" && cd ..; \
else \
   git clone -n $esos_home/$esos_repo.git --depth=1; \
fi;

if cd $esos_repo ; then \
   git checkout $esos_branche misc/$kernel_name.* && mv misc/$kernel_name.* ../$builder_repo && cd ..; \
else \
   echo "No $esos_repo checkout possible, aborting."; \
   exit 1;
fi;

if cd $patch_repo >/dev/null 2>&1; then \
   echo "... Okay" && cd ..; \
else \
   git clone -n $patch_home/$patch_repo.git --depth=1; \
fi;

if cd $patch_repo ; then \
   git checkout $patch_branche misc/$kernel_name.* && mv misc/$kernel_name.* ../$builder_repo && cd ..; \
else \
   echo "No $patch_repo checkout possible, aborting."; \
   exit 1;
fi;

if cd $builder_repo ; then \
   if [[ ! -f $kernel_name.$patch_name.config_patch ]] ; then
      echo "File $kernel_name.$patch_name.config_patch is not there, aborting."
      exit 1;
   else
      echo "found $kernel_name.$patch_name.config_patch"
      $patch_cmd $kernel_name.config < $kernel_name.$patch_name.config_patch
      $python3_cmd ./linux-builder --verbose --menuconfig --version $kernel_version --config $kernel_name.config
      echo -e "\nStart with ... \ncd $target_dir/$builder_repo \n./linux-builder --verbose --jobs $cpu_info --version $kernel_version --config $kernel_name.config --patch $kernel_name.patch --target bzImage"
   fi
else \
   echo "No $builder_repo directory exists, aborting."; \
   exit 1;
fi;
