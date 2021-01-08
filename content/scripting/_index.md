---
title: "scripting"
---

## Python

### australian specified work postcode checker

In Australia on a working holiday visa? Want to know if the place offering you work is in a regional area? Put in the postcode and find out here. And yes, it's ugly - it's a 5 minute GUI built with Flask.

[View on PythonAnywhere](https://jamesdeluk.pythonanywhere.com/) (external link)

### seek.com.au job scraper

Which terms are popular in job descriptions? Where are the jobs? Enter your search term and find out.

[Repl.it embedded iframe](seek)

---

## Bash

### unzip_to_folders

The Linux `unzip` command unzips to the same directory, or a defined one. This script unzips all zip files within a directory in a single go. If the zip contains a single file, it is unzipped to the base directory. If the zip contains multiple files, it is unzipped to a directory of the same name as the zip. Then the zips are all moved to a "zips" folder.

{{< gist jamesdeluk 65a5342059ee4d2724d5fb268b86f880 >}}