#!/bin/bash

function git_clone() (
  git clone --depth 1 $1 $2 || true
)
function git_sparse_clone() (
  branch="$1" rurl="$2" localdir="$3" && shift 3
  git clone -b $branch --depth 1 --filter=blob:none --sparse $rurl $localdir
  cd $localdir
  git sparse-checkout init --cone
  git sparse-checkout set $@
  mv -n $@ ../
  cd ..
  rm -rf $localdir
)
function mvdir() {
  mv -n $(find $1/* -maxdepth 0 -type d) ./
  rm -rf $1
}
function clrdir() {
  rm -rf $(find $1/ -name ".*")
}

git rm -r --cache * >/dev/null 2>&1 &
rm -rf $(find ./* -maxdepth 0 -type d ! -name "diy") >/dev/null 2>&1

svn export https://github.com/vernesong/OpenClash/trunk/luci-app-openclash

git_clone https://github.com/rufengsuixing/luci-app-adguardhome && clrdir luci-app-adguardhome
