// https://superuser.com/questions/1271147/change-key-bindings-keyboard-shortcuts-in-firefox-57
try {
  let { classes: Cc, interfaces: Ci, manager: Cm  } = Components;
  const Services = globalThis.Services;
  const {SessionStore} = Components.utils.import('resource:///modules/sessionstore/SessionStore.jsm');
  function ConfigJS() { Services.obs.addObserver(this, 'chrome-document-global-created', false); }
  ConfigJS.prototype = {
    observe: function (aSubject) { aSubject.addEventListener('DOMContentLoaded', this, {once: true}); },
    handleEvent: function (aEvent) {
      let document = aEvent.originalTarget; let window = document.defaultView; let location = window.location;
      if (/^(chrome:(?!\/\/(global\/content\/commonDialog|browser\/content\/webext-panels)\.x?html)|about:(?!blank))/i.test(location.href)) {
        if (window._gBrowser) {

          // remap Ctrl-n to Ctrl-N to let tridactyl have it
          let newNav = window.document.getElementById('key_newNavigator')
          newNav.remove();
          let openDownloads = window.document.getElementById('key_newNavigator')
          openDownloads.setAttribute("modifiers", "accel,shift");
          openDownloads.setAttribute("key", "N");

        }
      }
    }
  };
  if (!Services.appinfo.inSafeMode) { new ConfigJS(); }
} catch(ex) {};
