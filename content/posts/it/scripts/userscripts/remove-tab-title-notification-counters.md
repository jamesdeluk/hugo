---
title: Remove Tab Title Notification Counters
---
<!-- Available on Greasy Fork: [https://greasyfork.org/en/scripts/514878-scroll-percentage-bar-with-text](https://greasyfork.org/en/scripts/514878-scroll-percentage-bar-with-text) -->

```js
// ==UserScript==
// @name         Remove Tab Title Notification Counters
// @version      0.5
// @description  Removes webpage notification counters that appear at the begining of the tab title. Ex.) "(1) Example Title" becomes "Example Title"
// @author       nomadic
// @match        http://*/*
// @match        https://*/*
// ==/UserScript==

(function () {
  function cleanTitleText() {
    let title = document.title;
    const regex = /^\(.*\) /;
    const hasNotificationCounter = regex.test(title);

    if (hasNotificationCounter) {
      document.title = title.replace(regex, "");
    }
  }

  // observe changes in the webpage's title
  const targetElement = document.getElementsByTagName("title")[0];
  const configurationOptions = { childList: true };
  const observer = new MutationObserver(cleanTitleText);
  observer.observe(targetElement, configurationOptions);

  // perform an initial cleaning on load
  cleanTitleText();
})();
```