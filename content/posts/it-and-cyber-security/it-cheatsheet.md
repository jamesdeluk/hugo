---
title: "IT Cheatsheet"
categories: ["IT and Cyber Security","+ Pinned"]
tags: ["IT","Computing","Regex","JavaScript","Scripting"]
date: 2023-07-02
---
_The scripts and code snippets I copy and paste most often_

## Regex

### Remove duplicate lines

First sort so duplicates are next to each other

**Option 1**

Replace:

`^(.*)(\n\1)+$`

with

`$1`

**Option 2**

Replace:

`^((^[^\S$]?(?=\S)(?:.)+$)[\S\s]*?)^\2$(?:\n)?`

with

`$1`

### Find lines excluding specific string

**Option 1**

`((?!STRING).)*$`

**Option 2**

`^(?:(?!STRING).)*$`

### Find Korean/한글 text

`[가-힣]`

## Javascript

### Select all text by class/ID etc

Also TagName, ID, ...

`a=document.getElementsByClassName('CLASS');b=[];Array.from(a).forEach((e)=>{b.push(e.innerText)});c=b.toString();copy(c);`