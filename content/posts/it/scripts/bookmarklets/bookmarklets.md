---
title: "Bookmarklets"
tags: ["IT","Computing","Internet","Bookmarks","Boookmarklets","JavaScript","Scripting"]
date: 2023-10-04
lastmod: 2023-12-27
---
## Introduction

Bookmarklets are bookmarks with special powers. Effectively, they let you run JavaScript in a browser, which means you can inject JavaScript into a webpage.

The first code block is the bookmarklet itself; create a new bookmark and use this code as the URL. The second code block is the unencoded naked JavaScript; this can be edited then put through the bookmarklet creator found in Useful tools.

## Reload webpage on timer

Useful for stopping a webpage timing out, which may also log you out.

In the case of this bookmarklet, it reloads a fixed URL (i.e. it doesn’t reload the current URL). It has to be activated from a _different_ tab (a “control” tab), which must be kept open. The new tab (the “refresh” tab) it will create will refresh as per the timer, so if you intend to use the target website, I prefer to open _another_ tab (the “active” tab) and use that one, as that one won’t refresh. I pin the first two in the browser to keep them out of the way and avoid accidentally closing them.

This bookmarklet uses prompts. If you want a bookmarklet with a fixed URL and/or time, change the code below (e.g. `u="https://www.google.com"` or `m=5`) and recreate the bookmarklet using the bookmarklet creator in Useful tools below.

```js
javascript:(function()%7Bu%3Dprompt(%22URL%3A%20%22)%3B%0Am%3Dprompt(%22Minutes%3A%20%22)%3B%0Aw%3Dwindow.open(u)%3B%0Ai%3DsetInterval(function()%7Bw.location.href%3Du%3B%7D%2Cm*60*1000)%3B%7D)()%3B
```

```js
u=prompt("URL: ");
m=prompt("Minutes: ");
w=window.open(u);
i=setInterval(function(){w.location.href=u;},m*60*1000);
```

## Video playback speed

Useful for videos where controls are disabled.

### Speed via prompt

```js
javascript:(function()%7Bx%3Dprompt(%27Select%20Playback%20Rate:%27)%3Bdocument.querySelector(%27video%27).playbackRate%3Dx%3B%7D)()%3B
```

```js
x=prompt('Select Playback Rate:');
document.querySelector('video').playbackRate=x;
```

### Double / 2x

```js
javascript:(function()%7Bdocument.querySelector('video').playbackRate%3D2%7D)()
```

```js
document.querySelector('video').playbackRate=2
```

## Page title

### Copy

```js
javascript:(function()%7Bvar%20dummy%20%3D%20document.createElement(%22textarea%22)%3B%0Adocument.body.appendChild(dummy)%3B%0Adummy.value%20%3D%20document.title%3B%0Adummy.select()%3B%0Adocument.execCommand(%22copy%22)%3B%0Adocument.body.removeChild(dummy)%3B%7D)()%3B
```

```js
var dummy = document.createElement("textarea");
document.body.appendChild(dummy);
dummy.value = document.title;
dummy.select();
document.execCommand("copy");
document.body.removeChild(dummy);
```

### Rename via prompt

```js
javascript:(function()%7Bvar%20title%3Dprompt(%22Title%3A%20%22)%3B%0Adocument.title%3Dtitle%3B%7D)()%3B
```

```js
var title=prompt("Title: ");
document.title=title;
```

### Rename to element text

In this case, I used the `innerText` of the first `h1` tag.

```js
javascript:(function()%7Bdocument.title%3Ddocument.getElementsByTagName('h1')%5B0%5D.innerText%7D)()%3B
```

```js
document.title=document.getElementsByTagName('h1')[0].innerText
```

## Prefix tab title with word count

Word count gives you a rough indication of reading time. It's not perfect, just a quick hack.

### Add

This is also available as a userscript, available on [Greasy Fork](https://greasyfork.org/en/scripts/481785-prefix-title-with-word-count).

```js
javascript:(function()%7Bwc%3Ddocument.body.innerText.match(%2F%5B%5Cw%5Cd%5D%2B%2Fgi).length%3B%0Atitle%3Ddocument.title%3B%0Adocument.title%3D%22%5B%22%2Bwc%2B%22%5D%20%22%2Btitle%3B%7D)()%3B
```

```js
wc=document.body.innerText.match(/[\w\d]+/gi).length;
title=document.title;
document.title="["+wc+"] "+title;
```

### Remove

Simply removes the first "word" in the title.

```js
javascript:(function()%7Bdocument.title%3Ddocument.title.split('%20').slice(1).join('%20')%7D)()%3B
```

```js
document.title=document.title.split(' ').slice(1).join(' ')
```

## Prefix tab title with scroll percentage

I actually used an AI/LLM (Poe) to create this one:

> Create a bookmarklet that prefixes the tab title with the % of page scrolled that updates on scroll

```js
javascript:(function() {
  var originalTitle = document.title;
  
  function updateTitle() {
    var scrollTop = document.documentElement.scrollTop || document.body.scrollTop;
    var scrollHeight = document.documentElement.scrollHeight || document.body.scrollHeight;
    var percentScrolled = Math.round((scrollTop / scrollHeight) * 100);
    
    document.title = '[' + percentScrolled + '%] ' + originalTitle;
  }
  
  window.addEventListener('scroll', updateTitle);
})();
```

And instead of using CyberChef, I simply asked the LLM to minify and encode it:

```js
javascript:(function(){var%20e=document.title;function%20t(){var%20t=document.documentElement.scrollTop||document.body.scrollTop,n=document.documentElement.scrollHeight||document.body.scrollHeight,r=Math.round(t/n*100);document.title='['+r+'%] '+e}window.addEventListener('scroll',t)})();
```

Which actually does a better job, as it replaces the variable names etc too.

## Scroll to bottom of a page

```js
javascript:window.scrollTo(0,document.documentElement.scrollHeight)
```

```js
window.scrollTo(0,document.documentElement.scrollHeight)
```

## Summarise YouTube videos 

In a new tab. Don't always work.

### Summarize.tech

```js
javascript:(function()%7Bwindow.open('https%3A%2F%2Fwww.summarize.tech%2Fyoutu.be%2F'%2Bwindow.location.href.split('v%3D')%5B1%5D.split('%26')%5B0%5D)%7D)()%3B
```

```js
window.open('https://www.summarize.tech/youtu.be/'+window.location.href.split('v=')[1].split('&')[0])
```

### Tammy AI

```js
javascript:(function()%7Bwindow.open('https%3A%2F%2Ftammy.ai%2Fe%2F'%2Bwindow.location.href.split('v%3D')%5B1%5D.split('%26')%5B0%5D)%7D)()%3B
```

```js
window.open('https://www.summarize.tech/youtu.be/'+window.location.href.split('v=')[1].split('&')[0])
```

## Useful tools

### Bookmarklet maker

https://caiorss.github.io/bookmarklet-maker/

Enter your JavaScript, it creates a bookmarklet you can drag-and-drop to your bookmarks.

### CyberChef

https://gchq.github.io/CyberChef/

An incredibly powerful tool for a host of data manipulations. In this case, you can use it to encode or decode URLs i.e. change a space   ` ` to `%20` or change `{` to `%7B` as you can see in the bookmarklet code above.