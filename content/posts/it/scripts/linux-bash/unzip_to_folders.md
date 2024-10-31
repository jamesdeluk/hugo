---
title: unzip_to_folders
tags: ['Bash']
date: 2021-01-08
---
The Linux `unzip` command unzips files to the same directory as the .zip file, or to a defined one. You can't batch unzip.

This script unzips all .zip files within a directory in a single command.

If the .zip contains a single file, it is unzipped to the base directory.

If the .zip contains multiple files, it is unzipped to a directory of the same name as the .zip. 

The .zips files are then all moved to a "zips" folder.

{{< gist jamesdeluk 65a5342059ee4d2724d5fb268b86f880 >}}