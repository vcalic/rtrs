class WebKit {
  constructor() {
    this._base64 = new Base64();
    this.promises = []
    this.contentHeight = 0;
  }

  parseXml(xmlStr) {
    return (new window.DOMParser()).parseFromString(xmlStr, "text/xml");
  }

  get(url) {
    let self = this;
    const promise = new Promise(
      function (resolve, reject) {
        try {
          const promiseId = self.generateUUID();
          self.promises[promiseId] = {resolve, reject};
          window.webkit.messageHandlers.getURL.postMessage({promiseId: promiseId, url: url});
        } catch (exception) {
          console.error("Error in get: ", exception);
        }
      });
    return promise;
  }

  post(url, data) {
    let self = this;

    const promise = new Promise(
      function (resolve, reject) {
        var promiseId = self.generateUUID();
        self.promises[promiseId] = {resolve, reject};
        try {
          window.webkit.messageHandlers.postURL.postMessage({promiseId: promiseId, url: url, params: data});
        } catch (exception) {
          console.error("Error in postiOS", exception);
        }
      });
    return promise;
  }

  generateUUID() {
    let d = new Date().getTime();
    let mask = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx';

    return mask.replace(/[xy]/g, function (c) {
      let r = (d + Math.random() * 16) % 16 | 0;
      d = Math.floor(d / 16);
      return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16);
    });
  }

  resolvePromise(promiseId, data, error) {
    let result = "";
    if (data !== undefined && data !== null) {
      result = this._base64.decode(data);
    }
    if (error) {
      const decodedError = this._base64.decode(error);
      this.promises[promiseId].reject(decodedError);
    } else {
      this.promises[promiseId].resolve(result);
    }
    // remove reference to stored promise
    delete this.promises[promiseId];
  }

  setContentHeight() {
    window.webkit.messageHandlers.height.postMessage(document.body.offsetHeight); // jshint ignore:line
  }

  debugPrint(text) {
    window.webkit.messageHandlers.debugPrint.postMessage(text);
  }

  didFinishNavigation() {
    document.documentElement.style.webkitUserSelect='none';
    document.documentElement.style.webkitTouchCallout='none';
  }

  startLoop() {
    const func = _ =>  {
      if (document.body.offsetHeight !== this.contentHeight) {
        this.contentHeight = document.body.offsetHeight;
        this.setContentHeight();
      }
    };
    setInterval(func , 200);
  }
}

class Base64 {
  constructor() {
    this._keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
  }
  decode(input) {
    let output = "";
    let chr1, chr2, chr3;
    let enc1, enc2, enc3, enc4;
    let i = 0;
    input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

    while (i < input.length) {
      enc1 = this._keyStr.indexOf(input.charAt(i++));
      enc2 = this._keyStr.indexOf(input.charAt(i++));
      enc3 = this._keyStr.indexOf(input.charAt(i++));
      enc4 = this._keyStr.indexOf(input.charAt(i++));

      chr1 = (enc1 << 2) | (enc2 >> 4);
      chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
      chr3 = ((enc3 & 3) << 6) | enc4;

      output = output + String.fromCharCode(chr1);

      if (enc3 !== 64) {
        output = output + String.fromCharCode(chr2);
      }

      if (enc4 !== 64) {
        output = output + String.fromCharCode(chr3);
      }
    }


    output = this._utf8_decode(output);
    return output;

  };
  // private method for UTF-8 decoding
  _utf8_decode(utftext) {
    let string = "";
    let i = 0;
    let c = 0;
    let c1 = 0;
    let c2 = 0;
    let c3 = 0;
    while (i < utftext.length) {
      c = utftext.charCodeAt(i);
      if (c < 128) {
        string += String.fromCharCode(c);
        i++;
      } else if ((c > 191) && (c < 224)) {
        c2 = utftext.charCodeAt(i + 1);
        string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
        i += 2;
      } else {
        c2 = utftext.charCodeAt(i + 1);
        c3 = utftext.charCodeAt(i + 2);
        string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
        i += 3;
      }
    }
    return string;
  }
}
