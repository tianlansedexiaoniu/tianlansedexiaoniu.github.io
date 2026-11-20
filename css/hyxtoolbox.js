(function (w) {
  var BRIDGE = 'http://127.0.0.1:17890';
  function req(cmd) {
    var url = BRIDGE + '/?cmd=' + encodeURIComponent(cmd);
    if (w.fetch) { w.fetch(url, { method: 'GET' }).catch(function () {}); return; }
    var x = new XMLHttpRequest();
    x.open('GET', url, true);
    x.send();
  }
  w.hyxtoolbox = { run: function (cmd) { req(cmd); return false; } };
})(window);
