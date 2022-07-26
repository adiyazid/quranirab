var QWCleaner = (function() {	
	var _publicFunc = {},
		_privateFunc = {},
		_quranSymbols = [
			'\uFBB2', '\uFBB3', '\uFBB4', '\uFBB5', '\uFBB6', '\uFBE8', '\uFBE9', '\uFC40',
			'\uFC41', '\uFC42', '\uFC43', '\uFC44', '\uFC45', '\uFC46', '\uFC47', '\uFC48',
			'\uFC4A', '\uFC4B', '\uFC4C', '\uFC4D', '\uFC4F', '\uFC51', '\uFC53', '\uFC54',
			'\uFC55', '\uFC56', '\uFC57', '\uFC58', '\uFC59', '\uFC5A', '\uFC5B', '\uFC5D',
			'\uFC5E', '\uFC5F', '\uFC60', '\uFC61', '\uFC62', '\uFC63', '\uFC65', '\uFC66',
			'\uFC67', '\uFC68', '\uFC69', '\uFC6A', '\uFC6B', '\uFC6C', '\uFC6D', '\uFC6E',
			'\uFC70', '\uFC71', '\uFC72', '\uFC73', '\uFC75', '\uFC76', '\uFC77', '\uFC78',
			'\uFC79', '\uFC7A', '\uFC7B', '\uFC7C', '\uFC7D', '\uFC7E', '\uFC7F', '\uFC80',
			'\uFC81', '\uFC83', '\uFC84', '\uFC85', '\uFC86', '\uFC87', '\uFC88', '\uFC89',
			'\uFC8A', '\uFC8B', '\uFC8C', '\uFC8D', '\uFC8E', '\uFC8F', '\uFC90', '\uFC92',
			'\uFC93', '\uFC94', '\uFC95', '\uFC96', '\uFC97', '\uFC98', '\uFC99', '\uFC9A',
			'\uFC9B', '\uFC9C', '\uFC9D', '\uFC9E', '\uFC9F', '\uFCA0', '\uFCA1', '\uFCA2',
			'\uFCA3', '\uFCA4', '\uFCA5', '\uFCA6', '\uFCA7', '\uFCA8', '\uFCA9', '\uFCAA',
			'\uFCAC', '\uFCAD', '\uFCAE', '\uFCAF', '\uFCB0', '\uFCB2', '\uFCB3', '\uFCB5',
			'\uFCB6', '\uFCB9', '\uFCBA', '\uFCBB', '\uFCBC', '\uFCBF', '\uFCC0', '\uFCC1',
			'\uFCC2', '\uFCC3', '\uFCC4', '\uFCC5', '\uFCC6', '\uFCC7', '\uFCC8', '\uFCC9',
			'\uFCCA', '\uFCCB', '\uFCCC', '\uFCCD', '\uFCCE', '\uFCCF', '\uFCD0', '\uFCD1',
			'\uFCD2', '\uFCD3', '\uFCD4', '\uFCD5', '\uFCD6', '\uFCD7', '\uFCD8', '\uFE7A'			
		];

	_publicFunc.cleanSymbol = function(text) {
		var processText = '';

		for (var i = 0; i < text.length; i++) {
			if ($.inArray(text.charAt(i), _quranSymbols) === -1) {
				processText += text.charAt(i);
			}
		}

		return processText;
	};

	_publicFunc.isSymbol = function(char) {
		if ($.inArray(char, _quranSymbols) > -1) {
			return true;
		} else {
			return false;
		}
	}
	
	return _publicFunc;
} ());