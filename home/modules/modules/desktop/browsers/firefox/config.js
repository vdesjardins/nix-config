// Good references from github.com/leotaku/comprehensive-firefox
//
// [Surfingkeys](https://github.com/brookhong/Surfingkeys)
// [default Firefox shortcuts](https://support.mozilla.org/en-US/kb/keyboard-shortcuts-perform-firefox-tasks-quickly)
// [browser toolbox](https://firefox-source-docs.mozilla.org/devtools-user/browser_toolbox/index.html)
// [remappable keybindings](https://searchfox.org/mozilla-release/source/browser/base/content/browser-sets.inc)
// [this Stackoverflow question](https://superuser.com/questions/1271147/change-key-bindings-keyboard-shortcuts-in-firefox-quantum)
// [official autoconf.js docs](https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig)
// [reddit post](https://www.reddit.com/r/firefox/comments/yyxlw7/change_keyboard_shortcuts/)
// [better prefs location?](https://bugzilla.mozilla.org/show_bug.cgi?id=1170092)
try {
  let { classes: _Cc, interfaces: _Ci, manager: _Cm } = Components;
  const Services = globalThis.Services;
  const { SessionStore: _SessionStore } = Components.utils.import(
    "resource:///modules/sessionstore/SessionStore.jsm"
  );
  function ConfigJS() {
    Services.obs.addObserver(this, "chrome-document-global-created", false);
  }
  ConfigJS.prototype = {
    observe: function (aSubject) {
      aSubject.addEventListener("DOMContentLoaded", this, { once: true });
    },
    handleEvent: function (aEvent) {
      let document = aEvent.originalTarget;
      let window = document.defaultView;
      let location = window.location;
      if (
        /^(chrome:(?!\/\/(global\/content\/commonDialog|browser\/content\/webext-panels)\.x?html)|about:(?!blank))/i.test(
          location.href
        )
      ) {
        if (window._gBrowser) {
          // remap Ctrl-n to Ctrl-N to let tridactyl have it
          let newNav = window.document.getElementById("key_newNavigator");
          newNav.remove();
          let openDownloads = window.document.getElementById("key_newNavigator");
          openDownloads.setAttribute("modifiers", "accel,shift");
          openDownloads.setAttribute("key", "N");
        }
      }
    },
  };
  if (!Services.appinfo.inSafeMode) {
    new ConfigJS();
  }
} catch (_ex) {}
