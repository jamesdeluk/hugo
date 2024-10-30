---
title: Scroll Percentage Bar with Text
weight: 20
menu:
  notes:
    name: Scroll Percentage Bar with Text
    identifier: notes-userscripts-spbwt
    parent: notes-userscripts
    weight: 20
---

Available on Greasy Fork: [https://greasyfork.org/en/scripts/514878-scroll-percentage-bar-with-text](https://greasyfork.org/en/scripts/514878-scroll-percentage-bar-with-text)

```js
// ==UserScript==
// @name         Scroll Percentage Bar with Text
// @version      20240709
// @description  Adds a scroll percentage bar and text to the top of the page
// @author       jamesdeluk
// @match        *://*/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // Create the bar element
    var progressBar = document.createElement('div');
    progressBar.style.position = 'fixed';
    progressBar.style.top = '0';
    progressBar.style.left = '0';
    progressBar.style.width = '0%';
    progressBar.style.height = '5px';
    progressBar.style.backgroundColor = '#00aaff';
    progressBar.style.zIndex = '10000';
    progressBar.style.transition = 'width 0.25s ease-out';
    document.body.appendChild(progressBar);

    // Create the percentage text element
    var progressText = document.createElement('div');
    progressText.style.position = 'fixed';
    progressText.style.top = '5px';
    progressText.style.right = '0';
    progressText.style.padding = '5px';
    progressText.style.backgroundColor = 'rgba(0, 0, 0, 0.5)';
    progressText.style.color = 'white';
    progressText.style.zIndex = '10000';
    progressText.style.fontFamily = 'Arial, sans-serif';
    progressText.style.fontSize = '12px';
    document.body.appendChild(progressText);

    // Update the width of the bar and the text on scroll
    window.addEventListener('scroll', function() {
        var scrollTop = window.scrollY || document.documentElement.scrollTop;
        var scrollHeight = document.documentElement.scrollHeight - document.documentElement.clientHeight;
        var scrollPercent = (scrollTop / scrollHeight) * 100;
        progressBar.style.width = scrollPercent + '%';
        progressText.textContent = Math.round(scrollPercent) + '%';
    });
})();
```