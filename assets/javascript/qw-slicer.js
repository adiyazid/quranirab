var QWSlicer = (function() {
  //PRIVATE
  var ENABLE_EDIT = true;

  var _$container = "",
      _options = {},
      _defaultOptions = {
        mode: "edit",
        lineWrapWidth: 700,
        wrapAya: "<div style='font-size: inherit; text-align: center' />",
        loadingGif: "",
        //select sliced box
        slicedClick: function() {
          if (!_startSelecting) {
            var $curr = $(this);

            if($curr.length > 0) {
              if (!$curr.hasClass('textCursor')) {
                $(".textCursor").removeClass("textCursor");
                $curr.addClass("textCursor");
                $("div[id^='wci_']").hide();
              }
            }
          }
        },
        //show word categories input
        slicedDblClick: function(evt) {
          var curr = this,
              start = $(curr).attr("data-char-start"),
              end = $(curr).attr("data-char-end");

          async.waterfall([
            function(callback) {
              if ($(curr).parent().hasClass('versesContainer')) {
                _lineWrapProcessing(function() {
                  callback();
                });
              } else {
                callback();
              }
            }
          ], function(error) {
            if (window.getSelection) {
              if (window.getSelection().empty) {  // Chrome
                window.getSelection().empty();
              } else if (window.getSelection().removeAllRanges) {  // Firefox
                window.getSelection().removeAllRanges();
              }
            } else if (document.selection) {  // IE?
              document.selection.empty();
            }

            _wordCategoriesInput(curr, start, end, 1);
          });
        },
        slicedMouseEnter: function() {
          return false;
        },
        slicedMouseLeave: function() {
          return false;
        }
      },
      _startSelecting = false,
      _deleteList = [],
      _waitCount = 0,
      _loadQuestionTimeout = null;

  //Proprocess all the char by tagging it accordingly
  //to arabicChar, arabicSymbol, verseNumber and space.
  function _preprocess(callback) {
    var numberEncapsuleStart = "ﳀ",
        numberEncapsuleEnd = "ﳁ";

    var verses = $.trim(_$container.text()),
        splits = verses.split("");

    var completeAya = false,
        atVerseNumber = false,
        modVerses = "",
        verseIndex = 0;

    _$container.html("");

    var charIdx = 0;
    for(var i = 0; i < splits.length; i++) {
      if (i === 0 && splits[i] !== "﷽") {
        //append hidden sura header for the sura that continue from previous page.
        _$container.append(
            "<div class='row' style='display: none; margin-top: 5px; background-color: #ffffff'>"
          +  "<div"
          +  " class='col-md-12'"
          +  " style='background-image: url(/images/2.5/sura_header.svg); background-size: 100% 100%; text-align: center'"
          +  " lang='quran'"
          +  ">"
          +  " <div class='suraName' style='display: inline-block; margin: 20px; font-size: 30px; color: #E96A58'>&#65021;</div>"
          +  "</div>"
          + "</div>"
        );
      }

      if (splits[i] === "﷽") {
        //the bismillah is in the middle of page
        if (modVerses.length > 0) {
          _$container.append(
              "<div class='versesContainer' style='display: inline-block; width: " + _options.lineWrapWidth + "px; padding: 10px; text-align: right'>" + modVerses + "</div>"
          );

          modVerses = "";
        }

        _$container.append(
            "<div class='row' style='margin-top: 5px; background-color: #ffffff'>"
          +  "<div"
          +  " class='col-md-12'"
          +  " style='background-image: url(/images/2.5/sura_header.svg); background-size: 100% 100%; text-align: center'"
          +  " lang='quran'"
          +  ">"
          +  " <div class='suraName' style='display: inline-block; margin: 20px; font-size: 30px; color: #E96A58'>&#65021;</div>"
          +  "</div>"
          + "</div>"
        );

        //this special char manually written and somehow it sometime include extra unknown empty string. Skip that.
        if (splits[i + 1] === "﻿") {
          console.log("SKIP");
          i++;
        }
        continue;
      } else if (splits[i] === numberEncapsuleStart) {
        splits[i] = splits[i] + "</div>";
        atVerseNumber = false;
        completeAya = true;
      } else if(splits[i] === numberEncapsuleEnd) {
        splits[i] = "<div class='verseNumber wrapThis' data-verse-index='" + verseIndex + "'>" + splits[i];
        atVerseNumber = true;
        verseIndex++;
      } else if(!atVerseNumber) {
        charIdx++;
        splits[i] = "<span id='char_" + charIdx + "' class='wrapThis' data-verse-index='" + verseIndex + "'>" + splits[i] + "</span>";
      }

      modVerses += splits[i];
    }

    if (modVerses.length > 0) {
      if (modVerses.length > 0) {
        _$container.append(
            "<div class='versesContainer' style='display: inline-block; width: " + _options.lineWrapWidth + "px; padding: 10px; text-align: right'>" + modVerses + "</div>"
        );

        modVerses = "";
      }
    }

    if (_options.mode !== "edit") {
      _extraProprocess(callback);
    } else {
      if (callback !== undefined) {
        callback();
      }
    }
  }

  function _extraProprocess(callback) {
    var $chars = _$container.find("span[id^='char_']");
    for (var i = 0; i < $chars.length; i++) {
      if ($chars.eq(i).html() !== ' ') {
        $chars.eq(i).addClass('inWordBlock');
      } else {
        $('.inWordBlock').wrapAll('<div class="wordBlock wrapThis" />');
        $('.inWordBlock').removeClass('inWordBlock').removeClass('wrapThis');
      }
    }

    if (callback !== undefined) {
      callback();
    }
  }

  function _lineWrapProcessing(callback) {
    var $versesContainers = _$container.find('.versesContainer');

    /*
    for (var i = 0; i < $versesContainers.length; i++) {
      //note: width of _options.lineWrapWidth minus left right padding of 15px each
      if ($versesContainers.eq(i).width() !== (_options.lineWrapWidth - 30)) {
        setTimeout(function() {
          _lineWrapProcessing(callback);
        }, 100);

        return false;
      }
    }
    */

    for (var i = 0; i < $versesContainers.length; i++) {
      var $versesContainer = $versesContainers.eq(i),
          $verseWords = $versesContainer.find('.wrapThis'),
          lineArray = [],
          lineIndex = 0,
          lineStart = true,
          lineEnd = false;

      $verseWords.removeClass('wrapThis');

      for (var j = 0; j < $verseWords.length; j++) {
        var $curr = $verseWords.eq(j);

        if ($curr.hasClass('verseNumber')) {
          $curr.addClass('wrapThis');
        } else {
          var $parent = $curr.parent();

          if ($parent.hasClass('sliced')) {
            $parent.addClass('wrapThis');
          } else {
            $curr.addClass('wrapThis');
          }
        }
      }

      $verseWords = $versesContainer.find('.wrapThis');
      $verseWords.removeClass('wrapThis');

      for (var j = 0; j < $verseWords.length; j++) {
        var pos = $verseWords.eq(j).position(),
            top = pos.top;

        if (lineStart) {
          lineArray[lineIndex] = [j];
          lineStart = false;
        } else {
          var $next = $verseWords.eq(j).next();

          if ($next.length) {
            var nextTop = $next.position().top;

            if (nextTop > top && (nextTop - top > 5)) {
              lineArray[lineIndex].push(j);
              lineIndex++;
              lineStart = true;
            }
          } else {
            lineArray[lineIndex].push(j);
          }
        }
      }

      for (var j = 0; j < lineArray.length; j++) {
        var start = lineArray[j][0],
            end = lineArray[j][1] + 1;

        if (!end) {
          if (_options.wrapAya.length > 0) {
            $verseWords.eq(start).wrap(_options.wrapAya);
          }
        } else {
          if (_options.wrapAya.length > 0) {
            $verseWords.slice(start, end).wrapAll(_options.wrapAya);
          }
        }
      }
    }

    if (callback !== undefined) {
      callback();
    }
  }

  //Arabic char is clickable and show text cursor on click
  function _bindArabicCharEvent($chars) {
    if($chars === undefined) {
      $chars = $("span[id^='char_']");
    }

    $chars.unbind("click").bind("click", function() {
      if (!_startSelecting) {
        var $curr = $(this);

        while ($curr.length > 0 && skipThis($curr)) {
          $curr = $curr.next();
        }

        if($curr.length > 0) {
          $(".textCursor").removeClass("textCursor");
          $curr.addClass("textCursor");
          $("div[id^='wci_']").hide();
        }
      }
    });
  }

  function skipThis($curr) {
    if(
      $curr.width() <= 5 || $curr.height() <= 5 ||
      $.trim($curr.text()).length === 0 ||
      $curr.hasClass("verseNumber")
    ) {
      return true;
    } else {
      return false;
    }
  }

  //Bind keyboard event that handle up, down, left and right
  //keypress. This event will move the text cursor accordingly.
  function _bindTextCursorEvent() {
    $(document).unbind("keydown").bind("keydown", function(evt) {
      var $textCursor = $(".textCursor");

      if($textCursor.length > 0) {
        var $to = "";

        //A keypress
        if(evt.keyCode === 65 && evt.altKey) {
          evt.preventDefault();

          var $skips = new Array();

          //Move cursor to next char.
          $to = $textCursor.next();

          //Skip arabic symbol, verse number and space.
          //Text cursor will move to next available arabic char.
          while ($to.length > 0 && skipThis($to)) {
            if(_startSelecting) {
              if($to.hasClass("verseNumber")) {
                $to = "";
              } else {
                $skips.push($to);
                $to = $to.next();
              }
            } else {
              $to = $to.next();
            }
          }

          //On selecting event text cursor will not allowed
          //to select existing sliced chars.
          if(_startSelecting && $to.length > 0 && $to.hasClass("sliced")) {
            $to = "";
          }

          //Properly add selection mark on skip chars if applicable.
          if(_startSelecting && $to.length > 0 && $skips.length > 0) {
            for(var i = 0; i < $skips.length; i++) {
              $skips[i].addClass("selection");
            }
          }
        //D keypress
        } else if(evt.keyCode === 68 && evt.altKey) {
          evt.preventDefault();

          //Move cursor to previous char but on selecting event
          //it will not allowed to move beyond starting point.
          if(!$textCursor.hasClass("SELECT_START")) {
            $to = $textCursor.prev();
            if($textCursor.hasClass("selection")) {
              $textCursor.removeClass("selection");
            }
          }

          //Skip arabic symbol, verse number and space.
          //Text cursor will move to next available arabic char.
          //On selecting event do the unselect before moving.
          while($to.length > 0 && skipThis($to)) {
            if(_startSelecting) {
              if($to.hasClass("selection")) {
                $to.removeClass("selection");
              }
            }

            $to = $to.prev();
          }
        //W keypress
        } else if(evt.keyCode === 87 && evt.altKey) {
          evt.preventDefault();

          //Start or cancel selecting event.
          if(!$textCursor.hasClass("sliced")) {
            if(!_startSelecting) {
              _startSelecting = true;
              $textCursor.addClass("SELECT_START").addClass("selection");
            } else {
              _startSelecting = false;
              $(".SELECT_START").removeClass("SELECT_START");
              $(".selection").removeClass("selection")
            }
          }
        //S keypress
        } else if(evt.keyCode === 83 && evt.altKey) {
          evt.preventDefault();

          //Confirm selection if selecting event has been started.
          if(_startSelecting) {
            _startSelecting = false;

            //Wrap selection with sliced tag
            var $selection = $(".selection");
            $selection.wrapAll("<div class='sliced' />");
            $selection.removeClass("selection");

            $(".SELECT_START").removeClass("SELECT_START");

            //put some data into newly created slice
            var $currSliced = $textCursor.parent(),
                $chars = $currSliced.find("span");

            if($chars.length > 0) {
              var start = $chars.first().attr("id"),
                  end = $chars.last().attr("id");

              start = parseInt(start.replace("char_", ""));
              end = parseInt(end.replace("char_", ""));

              $currSliced.attr("data-char-start", start);
              $currSliced.attr("data-char-end", end);
              $currSliced.attr("data-word-id", "");
            }

            //Text cursor will move to next char if available.
            $to = $currSliced.next();

            while($to.length > 0 && skipThis($to)) {
              $to = $to.next();
            }

            //if $to is empty that mean there is no sibling next to it.
            //so select it self.
            if ($to.length === 0) {
              $to = $currSliced;
            }

            _bindSlicedBoxEvent();
          }
        //Delete keypress
        } else if(evt.keyCode === 46 && evt.altKey) {
          evt.preventDefault();

          if($textCursor.hasClass("sliced")) {
            var $curr = $textCursor,
                start = $curr.attr('data-char-start'),
                end = $curr.attr('data-char-end'),
                wordId = $curr.attr('data-word-id'),
                isContinue = true,
                $chars = $curr.find("span[id^='char_']");

            //ask for confirmation if this sliced already saved before
            if (wordId.length > 0) {
              var retInput = prompt("All data related to this word will be delete. Are you sure? Type 'yes' to confirm", "no");

              if (retInput !== null && retInput.toLowerCase() === 'yes') {
                isContinue = true;
              } else {
                isContinue = false;
              }
            }

            if (isContinue) {
              //need to remember which word need to be delete later
              //on saving if this sliced have data-word-id value
              if (wordId.length > 0) {
                _deleteList.push(parseInt(wordId));
              }

              //remove any word input that belong to this sliced
              $("#wci_" + start + "-" + end).remove();

              //unwrap, rebind and place text cursor accordingly
              $curr.contents().unwrap();
              _bindArabicCharEvent($chars);
              $chars.first().trigger("click");
            }
          }
        //E keypress
        } else if(evt.keyCode === 69 && evt.altKey) {
          evt.preventDefault();

          if($textCursor.hasClass("sliced")) {
            $textCursor.trigger("dblclick");
          }
        }


        if($to.length > 0) {
          $textCursor.removeClass("textCursor");
          $to.addClass("textCursor");
          $("div[id^='wci_']").hide();

          if(_startSelecting) {
            $to.addClass("selection");
          }
        }
      }
    });
  }

  //Bind all sliced tag to it's event.
  function _bindSlicedBoxEvent() {
    $(".sliced").unbind("click").bind(
      "click", _options.slicedClick
    ).unbind("dblclick").bind(
      "dblclick", _options.slicedDblClick
    ).unbind("mouseenter").bind(
      "mouseenter", _options.slicedMouseEnter
    ).unbind("mouseleave").bind(
      "mouseleave", _options.slicedMouseLeave
    ).each(function() {
      $(this).find("span[id^='char_']").unbind("click");
    });
  }

  //Get sliced char start and end position set. Return
  //it as objects array.
  function _extractSlicedPos() {
    var slices = new Array();

    $(".sliced").each(function() {
      var $curr = $(this),
          start = parseInt($curr.attr("data-char-start")),
          end = parseInt($curr.attr("data-char-end")),
          wordId = parseInt($curr.attr("data-word-id"));

      slices.push({
        "start": start,
        "end": end,
        "word_id": ((!isNaN(wordId)) ? wordId : "")
      });
    });

    return slices;
  }

  //Wrap sliced chars base on slices objects array.
  function _markSlicedChars(slices) {
    for(var i = 0; i < slices.length; i++) {
      var slice = slices[i],
          $curr = $("#char_" + slice.start);

      while(
        $curr.length > 0 &&
        $curr.attr("id") !== ("char_" + slice.end)
      ) {
        $curr.addClass("toSlice");
        $curr = $curr.next();
      }

      $curr.addClass("toSlice");

      $toSlices = $(".toSlice");
      if($toSlices.length > 0) {
        $toSlices.wrapAll(
          "<div class='sliced' data-char-start='" + slice.start + "' " +
          "data-char-end='" + slice.end + "' " +
          "data-word-id='" + ((slice.word_id !== undefined) ? slice.word_id : "") + "' " +
          "data-verse-index='" + $toSlices.eq(0).attr('data-verse-index') + "' />"
        );
        $toSlices.removeClass("toSlice");
        $toSlices.removeAttr('data-verse-index');
      }
    }

    _bindSlicedBoxEvent();
  }

  //displaying word categories input
  function _wordCategoriesInput(curr, start, end, languageId) {
    //if not define default language will be arabic
    // 1 - Arabic
    // 2 - English
    // 3 - Malay
    // 4 - French
    // 5 - Spanish
    // 6 - German
    // 7 - Indonesia
    // 8 - undefined
    // 9 - Japanese
    if (languageId === undefined) {
      languageId = 1;
    }

    var $curr = $(curr),
        $parent = $curr.parent(),
        wordId = $curr.attr('data-word-id'),
        currText = QWCleaner.cleanSymbol($curr.text()),
        inputId = "wci_" + start + "-" + end,
        html = "<div id='" + inputId + "' style='display:none; margin: 0; padding: 0; border: 1px solid #ccc; line-height: normal'>"
                + "<div class='questionContainer' style='width: 100%'></div>"
              + "</div>",
        $inputContainer = $("#" + inputId);

    //check if there is existing one before creating
    if ($inputContainer.length > 0) {
      if ($inputContainer.is(':hidden')) {
        //hide all other input container before proceed
        $("div[id^='wci_']").hide();
        $inputContainer.show();
      } else {
        $inputContainer.hide();
      }
    } else {
      //hide all other input container before proceed
      $("div[id^='wci_']").hide();
      $inputContainer = $(html).insertAfter($parent);

      $inputContainer.find('.questionContainer:eq(0)').prepend(
        "<div class='qLoadingTxt' style='display: inline-block; font-size: medium' lang='en'>&nbsp;"
        + ((_options.loadingGif.length > 0) ? "<img src='" + _options.loadingGif + "' style='width: 20px'>" : "[Loading. Please wait...]") +
        "&nbsp;</div>"
      );

      if (languageId === 1) {
        $inputContainer.css('text-align', 'right');
        $inputContainer.attr('lang', 'ar');
      } else {
        $inputContainer.css('text-align', 'left');
        $inputContainer.attr('lang', 'en');
      }

      html = "<div style='display: inline-block; margin: 5px;"
           + ((languageId === 1) ? "margin-right: 25px;" : "margin-left: 30px;")
           + "border-bottom: 1px solid #ccc; padding: 0; padding-bottom: 5px'>"
           + "</div>";

      var $wtContainer = $(html).prependTo($inputContainer),
          renderWtInput = function(languageId, wts, defaultArabicVal) {
            if (languageId === undefined) {
              languageId = 1;
            }

            if (wts === undefined) {
              wts = [false, false, false, false, false, false, false, false, false];
            }

            if (defaultArabicVal === undefined) {
              defaultArabicVal = '';
            }

            if (wts[0]) {
              if (wts[0].text.length === 0) {
                wts[0].text = defaultArabicVal;
              }
            }

            var retHtml = "<table class='table table-condensed' style='margin: 0; font-size: medium'>";

            retHtml += "<tr"
                     + " data-translation-id='" + ((wts[0]) ? wts[0].id : "") + "'"
                     + " data-language-id='1'"
                     + ">"
                     + "<td lang='quran' style='direction: rtl; vertical-align: middle'>العربية</td>"
                     + "<td>"
                     + "<input type='text' lang='quran' style='font-family: custom-quran-font; direction: rtl' value='" + ((wts[0]) ? wts[0].text : defaultArabicVal) + "'>"
                     + "</td>"
                     + "</tr>";

            retHtml += "<tr"
                     + " data-translation-id='" + ((wts[1]) ? wts[1].id : "") + "'"
                     + " data-language-id='2'"
                     + ">"
                     + "<td lang='en' style='direction: ltr; vertical-align: middle'>English</td>"
                     + "<td>"
                     + "<input type='text' lang='en' style='direction: ltr' value='" + ((wts[1]) ? wts[1].text : "") + "'>"
                     + "</td>"
                     + "</tr>";

            retHtml += "<tr"
                     + " data-translation-id='" + ((wts[2]) ? wts[2].id : "") + "'"
                     + " data-language-id='3'"
                     + ">"
                     + "<td lang='en' style='direction: ltr; vertical-align: middle'>Bahasa Melayu</td>"
                     + "<td>"
                     + "<input type='text' lang='en' style='direction: ltr' value='" + ((wts[2]) ? wts[2].text : "") + "'>"
                     + "</td>"
                     + "</tr>";

            retHtml += "<tr"
                     + " data-translation-id='" + ((wts[3]) ? wts[3].id : "") + "'"
                     + " data-language-id='4'"
                     + ">"
                     + "<td lang='en' style='direction: ltr; vertical-align: middle'>Français</td>"
                     + "<td>"
                     + "<input type='text' lang='fr' style='direction: ltr' value='" + ((wts[3]) ? wts[3].text : "") + "'>"
                     + "</td>"
                     + "</tr>";

            retHtml += "<tr"
                     + " data-translation-id='" + ((wts[4]) ? wts[4].id : "") + "'"
                     + " data-language-id='5'"
                     + ">"
                     + "<td lang='en' style='direction: ltr; vertical-align: middle'>Español</td>"
                     + "<td>"
                     + "<input type='text' lang='es' style='direction: ltr' value='" + ((wts[4]) ? wts[4].text : "") + "'>"
                     + "</td>"
                     + "</tr>";

            retHtml += "<tr"
                     + " data-translation-id='" + ((wts[5]) ? wts[5].id : "") + "'"
                     + " data-language-id='6'"
                     + ">"
                     + "<td lang='en' style='direction: ltr; vertical-align: middle'>Deutsch</td>"
                     + "<td>"
                     + "<input type='text' lang='de' style='direction: ltr' value='" + ((wts[5]) ? wts[5].text : "") + "'>"
                     + "</td>"
                     + "</tr>";

            retHtml += "<tr"
                     + " data-translation-id='" + ((wts[6]) ? wts[6].id : "") + "'"
                     + " data-language-id='7'"
                     + ">"
                     + "<td lang='en' style='direction: ltr; vertical-align: middle'>Indonesian</td>"
                     + "<td>"
                     + "<input type='text' lang='id' style='direction: ltr' value='" + ((wts[6]) ? wts[6].text : "") + "'>"
                     + "</td>"
                     + "</tr>";

            retHtml += "<tr"
                     + " data-translation-id='" + ((wts[8]) ? wts[8].id : "") + "'"
                     + " data-language-id='9'"
                     + ">"
                     + "<td lang='en' style='direction: ltr; vertical-align: middle'>Japanese</td>"
                     + "<td>"
                     + "<input type='text' lang='ja' style='direction: ltr' value='" + ((wts[8]) ? wts[8].text : "") + "'>"
                     + "</td>"
                     + "</tr>";

            retHtml += "</table>";

            return retHtml;
          };

      if (wordId.length > 0 && wordId !== 'null') {
        //there is exisitng data.
        html = "<div class='qLoadingTxt' style='display: inline-block; font-size: medium' lang='en'>&nbsp;"
             + ((_options.loadingGif.length > 0) ? "Loading existing data. Please wait&nbsp;&nbsp;<img src='" + _options.loadingGif + "' style='width: 20px'>" : "[Loading existing input. Please wait...]")
             + "&nbsp;</div>";

        var $loadingContainer = $(html).insertAfter($parent);

        $.ajax({
          url: '/words/' + wordId + '.json',
          type: 'get',
          dataType: 'json',
          success: function(data) {
            $inputContainer.find('.qLoadingTxt').remove();

            var wordTranslations = data.word_translations,
                wordRelationships = data.word_relationships,
                tempWt = [false, false, false, false, false, false, false, false, false];

            for (var i = 0; i < wordTranslations.length; i++) {
              var currIdx = wordTranslations[i].language_id - 1;
              tempWt[currIdx] = wordTranslations[i];
            }

            if (ENABLE_EDIT) {
              _onLoadQuestionCheck($inputContainer, wordRelationships.length, 10, function() {
                $loadingContainer.remove();
                $inputContainer.show();
              });  
            }

            $loadingContainer.remove();
            $inputContainer.show();

            $wtContainer.append(renderWtInput(languageId, tempWt, currText));

            if (ENABLE_EDIT) {
              if (wordRelationships.length > 0) {
                _loadNextQuestion(1, $inputContainer.find('.questionContainer:eq(0)'), languageId, wordRelationships);
              } else {
                _loadNextQuestion(1, $inputContainer.find('.questionContainer:eq(0)'), languageId);
              }  
            }
            
          }
        });
      } else {
        $inputContainer.show();

        $wtContainer.append(renderWtInput(languageId, undefined, currText));
        
        if (ENABLE_EDIT) {
          _loadNextQuestion(1, $inputContainer.find('.questionContainer:eq(0)'), languageId); 
        }
        
      }
    }
  }

  //load question from word_categories table and bind event
  function _loadNextQuestion(id, $container, languageId, existingRelationships) {
    if (languageId === undefined) {
      languageId = 1;
    }

    if (existingRelationships === undefined) {
      existingRelationships = [];
    }

    $container.append(
      "<div class='qLoadingTxt' style='display: inline-block; font-size: medium' lang='en'>&nbsp;"
      + ((_options.loadingGif.length > 0) ? "<img src='" + _options.loadingGif + "'>" : "[Loading. Please wait...]") +
      "&nbsp;</div>"
    );

    $.ajax({
      url: "/word_categories/" + id + ".json",
      type: "get",
      dataType: "json",
      success: function(data) {
        $container.find('.qLoadingTxt').remove();

        //continue render if selected question has childs.
        if (data.children.length > 0) {
          if ($.trim($container.html()).length > 0) {
            $container.append("<br/>");
          }

          //container for next question
          var html = "<div class='questionContainer' style='display: inline-block; margin: 5px;"
                   + ((languageId === 1) ? "margin-right: 25px;" : "margin-left: 30px;")
                   + "padding: 0'></div>",
              $currContainer = $(html).appendTo($container);

          //render as radio box (single selection)
          if (data.child_type === "unique") {
            var uniqueInputName = 'radio_' + (new Date()).getTime() + '_' + id;

            for (var i = 0; i < data.children.length; i++) {
              var currChild = data.children[i],
                  currTrans = currChild.tname;

              //get proper translation for question.
              for (var j = 0; j < currChild.category_translations.length; j++) {
                if (currChild.category_translations[j].language_id === languageId) {
                  currTrans = currChild.category_translations[j].name;
                  break;
                }
              }

              if (currChild.word_type === 'main-label') {
                currTrans = "<b style='color: red'>" + currTrans + "</b>";
              } else if (currChild.word_type === 'label') {
                currTrans = "<b style='color: #E9687C'>" + currTrans + "</b>";
              }

              html = "<div style='display: inline-block; margin: 0; padding: 0; font-size: 20px'>"
                   + "<input type='radio' name='" + uniqueInputName + "' value='" + currChild.id + "' style='vertical-align: middle'>"
                   + "&nbsp;" + currTrans
                   + ((currChild.child_type === 'special') ? "&nbsp;<span>(...)</span>" : "")
                   + "</div><br/>";

              $currContainer.append(html);
            }
          //render as checkbox (multiple selection)
          } else if (data.child_type === "multiple") {
            for (var i = 0; i < data.children.length; i++) {
              var currChild = data.children[i],
                  currTrans = currChild.tname;

              //get proper translation for question.
              for (var j = 0; j < currChild.category_translations.length; j++) {
                if (currChild.category_translations[j].language_id === languageId) {
                  currTrans = currChild.category_translations[j].name;
                  break;
                }
              }

              if (currChild.word_type === 'main-label') {
                currTrans = "<b style='color: red'>" + currTrans + "</b>";
              } else if (currChild.word_type === 'label') {
                currTrans = "<b style='color: #E9687C'>" + currTrans + "</b>";
              }

              html = "<div style='display: inline-block; margin: 0; padding: 0; font-size: 20px'>"
                   + "<input type='checkbox' value='" + currChild.id + "' style='vertical-align: middle'>"
                   + "&nbsp;" + currTrans
                   + ((currChild.child_type === 'special') ? "&nbsp;<span>(...)</span>" : "")
                   + "</div><br/>";

              $currContainer.append(html);
            }
          //render as text only and auto load next question (auto select)
          } else if (data.child_type === 'all') {
            for (var i = 0; i < data.children.length; i++) {
              var currChild = data.children[i],
                  currTrans = currChild.tname;

              //get proper translation for question.
              for (var j = 0; j < currChild.category_translations.length; j++) {
                if (currChild.category_translations[j].language_id === languageId) {
                  currTrans = currChild.category_translations[j].name;
                  break;
                }
              }

              if (currChild.word_type === 'main-label') {
                currTrans = "<b style='color: red'>" + currTrans + "</b>";
              } else if (currChild.word_type === 'label') {
                currTrans = "<b style='color: #E9687C'>" + currTrans + "</b>";
              }

              //if we currently load exisitng categories then render checkbox without auto select
              //because it will be done later
              //console.log('AUTO LOAD NEXT QUESTION');
              if (existingRelationships.length > 0) {
                html = "<div style='display: inline-block; margin: 0; padding: 0; font-size: 20px'>"
                     + "<input type='checkbox' value='" + currChild.id + "' style='vertical-align: middle' disabled='disabled'>"
                     + "&nbsp;" + currTrans
                     + ((currChild.child_type === 'special') ? "&nbsp;<span>(...)</span>" : "")
                     + "</div><br/>";

                $currContainer.append(html);
              } else {
                html = "<div style='display: inline-block; margin: 0; padding: 0; font-size: 20px'>"
                     + "<input type='checkbox' value='" + currChild.id + "' style='vertical-align: middle' checked='checked' disabled='disabled'>"
                     + "&nbsp;" + currTrans
                     + ((currChild.child_type === 'special') ? "&nbsp;<span>(...)</span>" : "")
                     + "</div><br/>";

                //it auto selection so load next question set.
                _loadNextQuestion(currChild.id, $(html).appendTo($currContainer), languageId);
              }
            }
          } else {
            for (var i = 0; i < data.children.length; i++) {
              var currChild = data.children[i],
                  currTrans = currChild.tname;

              //get proper translation for question.
              for (var j = 0; j < currChild.category_translations.length; j++) {
                if (currChild.category_translations[j].language_id === languageId) {
                  currTrans = currChild.category_translations[j].name;
                  break;
                }
              }

              if (currChild.word_type === 'main-label') {
                currTrans = "<b style='color: red'>" + currTrans + "</b>";
              } else if (currChild.word_type === 'label') {
                currTrans = "<b style='color: #E9687C'>" + currTrans + "</b>";
              }

              html = "<div style='display: inline-block; margin: 0; padding: 0; font-size: 20px'>"
                   + "<input type='checkbox' value='" + currChild.id + "' style='vertical-align: middle'>"
                   + "&nbsp;" + currTrans
                   + ((currChild.child_type === 'special') ? "&nbsp;<span>(...)</span>" : "")
                   + "</div><br/>";

              $currContainer.append(html);
            }
          }

          //bind event for newly rendered input.
          $currContainer.find("input").unbind("click").bind("click", function() {
            var $currInput = $(this),
                inputType = $currInput.attr("type"),
                inputVal = $currInput.val(),
                $currParent =  $currInput.parent();

            if (inputType === "checkbox") {
              var isSelected = $currInput.get(0).checked;

              if (isSelected) {
                _loadNextQuestion(inputVal, $currParent, languageId);
              } else {
                $currInput.siblings("div, br").remove();
              }
            } else if (inputType === "radio") {
              $currParent.siblings("div").children("input[name='" + $currInput.attr('name') + "']").siblings("div, br").remove();

              if ($currInput.siblings('div, br').length > 0) {
                //if the selection is already selected remove all it's content. (unselect)
                $currInput.get(0).checked = false;
                $currInput.siblings('div, br').remove();
              } else {
                _loadNextQuestion(inputVal, $currParent, languageId);
              }
            }

            //mark current input for words as dirty so that relationships can be rebuild on save
            $currInput.parents("div[id^='wci_']").addClass('dirty');
          });

          //properly select base on exisitng input if any.
          if (existingRelationships.length > 0) {
            //console.log('There is exisitng categories');
            var $inputs = $currContainer.find('input');

            for (var i = 0; i < $inputs.length; i++) {
              var $currInput = $($inputs.get(i)),
                  currInputType = $currInput.attr("type")
                  currInputVal = parseInt($currInput.val()),
                  $currParent = $currInput.parent();

              for (var j = 0; j < existingRelationships.length; j++) {
                // console.log(existingRelationships[j].word_category_id + ' === ' + currInputVal);
                if (existingRelationships[j].word_category_id === currInputVal) {
                  // console.log('SELECT THIS INPUT' + currInputVal);
                  $currInput.get(0).checked = true;
                  _loadNextQuestion(currInputVal, $currParent, languageId, existingRelationships);

                  break;
                }
              }
            }
          }
        } else {
          //for child_type = none, render empty div.
          var html = "<div class='questionContainer' style='display: inline-block; margin: 0; padding: 0'></div>",
              $currContainer = $(html).appendTo($container);
        }
      }
    });
  }

  function _save(callback) {
    var $sliceds = $('.sliced');
    /** old implimentation. Keep it until new implimentation was verified OK
    var reorderWordOrderFunc = function() {
      // console.log('REORDER WORDS ORDER...');
      _waitCount += $sliceds.length;
      _onWaitComplete(callback);

      // console.log('Travel through each sliced to check for word input.');
      $sliceds.each(function(currIdx) {
        var $curr = $(this),
            wordId = $curr.attr('data-word-id');

        // console.log('Updating word order...');
        $.ajax({
          url: '/words/' + wordId + '.json',
          type: 'PUT',
          dataType: 'json',
          data: {
            'word': {'word_order': (currIdx + 1)}
          },
          success: function(data) {
            // console.log('Updated word order, ID = ' + wordId);
          },
          complete: function() {
            _waitCount--;
          }
        });
      });
    };

    var addWordCategoriesFunc = function() {
      // console.log('ADD WORD CATEGORIES...');
      _waitCount += $sliceds.length;
      _onWaitComplete(reorderWordOrderFunc);

      // console.log('Travel through each sliced to check for word categories input.');
      $sliceds.each(function() {
        var $curr = $(this),
            start = $curr.attr('data-char-start'),
            end = $curr.attr('data-char-end'),
            wordId = $curr.attr('data-word-id'),
            $inputContainer = $("#wci_" + start + "-" + end);

        //only rebuild word relationships when dirty flag was found
        if ($inputContainer.length > 0 && $inputContainer.hasClass('dirty')) {
          // console.log('Found input for word, ID = ' + wordId);
          //2.2.1. delete all row in word_relationships that refer to it
          _waitCount += 1;

          // console.log('Deleting all exisitng word_relationships that refer to it');
          $.ajax({
            url: '/word_relationships/custom_destroy/' + wordId + '.json',
            type: 'DELETE',
            dataType: 'json',
            success: function(data) {
              // console.log('Deleted word_relationships for word, ID = ' + wordId);

              //2.2.2. insert the input into word_relationships table
              var $inputs = $inputContainer.find("input[type!='text']");

              _waitCount += $inputs.length;

              // console.log('Travel through each input...');
              $inputs.each(function() {
                var $currInput = $(this),
                    isChecked = $currInput.get(0).checked,
                    wordCategoryId = ((isChecked) ? parseInt($currInput.val()) : -1);

                if (isChecked) {
                  // console.log('Adding new categories...');
                  $.ajax({
                    url: '/word_relationships.json',
                    type: 'POST',
                    dataType: 'json',
                    data: {
                      'word_relationship': {
                        'word_id': wordId,
                        'word_category_id': wordCategoryId
                      }
                    },
                    success: function(data) {
                      // console.log('Added new categories for word, ID = ' + wordId);
                    },
                    complete: function() {
                      _waitCount--;
                    }
                  });
                } else {
                  _waitCount--;
                }
              });
            },
            complete: function() {
              _waitCount--;
            }
          });
        }

        _waitCount--;
      });
    };

    var addWordTranslationsFunc = function() {
      // console.log('ADD WORD TRANSLATION...');
      _waitCount += $sliceds.length;
      _onWaitComplete(addWordCategoriesFunc);

      // console.log('Travel through each sliced to check for word translation input.');
      $sliceds.each(function() {
        var $curr = $(this),
            start = $curr.attr('data-char-start'),
            end = $curr.attr('data-char-end'),
            wordId = $curr.attr('data-word-id'),
            $inputContainer = $("#wci_" + start + "-" + end);

        if ($inputContainer.length > 0) {
          // console.log('Found input for word, ID = ' + wordId);

          var $inputs = $inputContainer.find("input[type='text']");

          _waitCount += $inputs.length;
          $inputs.each(function() {
            var $currInput = $(this),
                $currParent = $currInput.parent().parent(),
                transId = $currParent.attr('data-translation-id'),
                transLangId = $currParent.attr('data-language-id'),
                transVal = $.trim($currInput.val());

            if (transId.length > 0) {
              //exisitng
              $.ajax({
                url: '/word_translations/' + transId + '.json',
                type: 'PUT',
                dataType: 'json',
                data: {
                  'word_translation': {
                    'text': transVal,
                    'word_id': wordId,
                    'language_id': transLangId
                  }
                },
                success: function(data) {
                  // console.log('Updated exisiting translations for word, ID = ' + wordId);
                },
                complete: function() {
                  _waitCount--;
                }
              });
            } else {
              //new
              $.ajax({
                url: '/word_translations.json',
                type: 'POST',
                dataType: 'json',
                data: {
                  'word_translation': {
                    'text': transVal,
                    'word_id': wordId,
                    'language_id': transLangId
                  }
                },
                success: function(data) {
                  // console.log('Added new translations for word, ID = ' + wordId);
                  transId = data.id;
                  $currParent.attr('data-translation-id', transId);
                },
                complete: function() {
                  _waitCount--;
                }
              });
            }
          });
        }

        _waitCount--;
      });
    };

    var addNewWordFunc = function() {
      // console.log('ADD NEW WORD...');

      _waitCount += $sliceds.length;
      _onWaitComplete(addWordTranslationsFunc);

      //2. travel through each sliced
      // console.log('Travel through each sliced to check for new word.');
      $sliceds.each(function(currIdx) {
        var $curr = $(this),
            start = $curr.attr('data-char-start'),
            end = $curr.attr('data-char-end'),
            wordId = $curr.attr('data-word-id');

        if (wordId.length === 0) {
          // console.log('New word found...');

          var slicedData = {
                'medina_mushaf_page_id': parseInt($('#medina_mushaf_page_id').val()),
                'quran_text_id': parseInt($('#quran_text_id').val()),
                'word_order': (currIdx + 1000),
                'total_words': -1,
                'start': start,
                'finish': end,
                'text': $(this).text()
              };

          //2.1. if it is new sliced insert it into words table
          // console.log('Adding new word...');
          $.ajax({
            url: '/words.json',
            type: 'POST',
            dataType: 'json',
            data: {
              'word': slicedData
            },
            success: function(data) {
              // console.log('Added word, ID = ' + wordId);
              wordId = data.id;
              $curr.attr('data-word-id', wordId);
            },
            complete: function() {
              _waitCount--;
            }
          });
        } else {
          //2.2. if it is existing sliced
          // console.log('Exisitng word found...');
          // console.log('Updating word with temp order...');
          $.ajax({
            url: '/words/' + wordId + '.json',
            type: 'PUT',
            dataType: 'json',
            data: {
              'word': {'word_order': (currIdx + 1000)}
            },
            success: function(data) {
              // console.log('Updated word, ID = ' + wordId);
            },
            complete: function() {
              _waitCount--;
            }
          });
        }
      });
    };

    var delExistingWordFunc = function() {
      // console.log("DELETE EXISTING WORD...");
      _waitCount += _deleteList.length;
      _onWaitComplete(addNewWordFunc);

      for (var i = 0; i < _deleteList.length; i++) {
        var wordId = _deleteList[i];

        // console.log('Deleting word, ID = ' + wordId);
        $.ajax({
          url: '/words/' + wordId + '.json',
          type: 'DELETE',
          dataType: 'json',
          success: function(data) {
            // console.log('Deleted word, ID = ' + wordId);
          },
          complete: function() {
            _waitCount--;
          }
        });
      }

      _deleteList = [];
    };

    // console.log('START SAVING SEQUENCE...');
    delExistingWordFunc();
    **/

    //async implimentation
    async.waterfall([
      //1. Delete existing words if any
      function(callback) {
        console.log('STEP 1: Delete existing words if any');
        
        if (ENABLE_EDIT) {
          //iterate each item and perform delete request
          async.eachSeries(_deleteList, function(wordId, callback) {
            if (wordId.length > 0 && wordId !== null && wordId !== 'null') {
              console.log('Deleting word, ID = ' + wordId);
              $.ajax({
                url: '/words/' + wordId + '.json',
                type: 'DELETE',
                dataType: 'json',
                success: function(data) {
                  console.log('Deleted word, ID = ' + wordId);
                },
                complete: function() {
                  callback();//continue next item (eachSeries)
                }
              });
            } else {
              callback();//continue next item (eachSeries)
            }
          }, function() {
            _deleteList = [];
            callback();//continue next step (waterfall)
          });
        } else {
          console.log('SKIP...');
          callback(); 
        }
      },

      //2. Add new words if any
      function(callback) {
        console.log('STEP 2: Add new words if any');
        
        if (ENABLE_EDIT) {
          //interate each sliced words and perform create or update request
          var sliceIdx = -1;

          async.eachSeries($sliceds, function(slice, callback) {
            var currIdx = ++sliceIdx;

            var $curr = $(slice),
                start = $curr.attr('data-char-start'),
                end = $curr.attr('data-char-end'),
                wordId = $curr.attr('data-word-id');

            if (wordId.length === 0 || wordId === 'null' || wordId === null) {
              console.log('New word found...');
              var slicedData = {
                    'medina_mushaf_page_id': parseInt($('#medina_mushaf_page_id').val()),
                    'quran_text_id': parseInt($('#quran_text_id').val()),
                    'word_order': (currIdx + 1000),
                    'total_words': -1,
                    'start': start,
                    'finish': end,
                    'text': $curr.text()
                  };

              //if it is new sliced insert it into words table
              console.log('Adding new word...');
              $.ajax({
                url: '/words.json',
                type: 'POST',
                dataType: 'json',
                data: {
                  'word': slicedData
                },
                success: function(data) {
                  wordId = data.id;
                  $curr.attr('data-word-id', wordId);
                  console.log('Added word, ID = ' + wordId);
                },
                error: function() {
                  console.log('Failed to add word, index = ' + sliceIdx);
                },
                complete: function() {
                  callback();//continue next item (eachSeries)
                }
              });
            } else {
              //if it is existing sliced
              console.log('Exisitng word found...');
              console.log('Updating word with temp order...');
              $.ajax({
                url: '/words/' + wordId + '.json',
                type: 'PUT',
                dataType: 'json',
                data: {
                  'word': {'word_order': (currIdx + 1000)}
                },
                success: function(data) {
                  console.log('Updated word, ID = ' + wordId);
                },
                complete: function() {
                  callback();//continue next item (eachSeries)
                }
              });
            }
          }, function() {
            callback();//continue next step (waterfall)
          });
        } else {
          console.log('SKIP...');
          callback(); 
        }
      },

      //3. Add words translation
      function(callback) {
        console.log('STEP 3: Add words translation');
        //interate each sliced words and perform create or update request
        async.eachSeries($sliceds, function(slice, callback) {
          var $curr = $(slice),
              start = $curr.attr('data-char-start'),
              end = $curr.attr('data-char-end'),
              wordId = $curr.attr('data-word-id'),
              $inputContainer = $("#wci_" + start + "-" + end);

          if ($inputContainer.length > 0) {
            // console.log('Found input for word, ID = ' + wordId);
            var $inputs = $inputContainer.find("input[type='text']");

            //interate through each inputs item
            async.eachSeries($inputs, function(input, callback) {
              var $currInput = $(input),
                  $currParent = $currInput.parent().parent(),
                  transId = $currParent.attr('data-translation-id'),
                  transLangId = $currParent.attr('data-language-id'),
                  transVal = $.trim($currInput.val());

              if (transId.length > 0) {
                //exisitng
                $.ajax({
                  url: '/word_translations/' + transId + '.json',
                  type: 'PUT',
                  dataType: 'json',
                  data: {
                    'word_translation': {
                      'text': transVal,
                      'word_id': wordId,
                      'language_id': transLangId
                    }
                  },
                  success: function(data) {
                    console.log('Updated exisiting translations for word, ID = ' + wordId);
                  },
                  complete: function() {
                    callback();//continue next item ($inputs) (eachSeries)
                  }
                });
              } else {
                //new
                $.ajax({
                  url: '/word_translations.json',
                  type: 'POST',
                  dataType: 'json',
                  data: {
                    'word_translation': {
                      'text': transVal,
                      'word_id': wordId,
                      'language_id': transLangId
                    }
                  },
                  success: function(data) {
                    console.log('Added new translations for word, ID = ' + wordId);
                    transId = data.id;
                    $currParent.attr('data-translation-id', transId);
                  },
                  complete: function() {
                    callback();//continue next item ($inputs) (eachSeries)
                  }
                });
              }
            }, function() {
              callback();//continue next item ($sliceds) (eachSeries)
            });
          } else {
            callback();//continue next item ($sliceds) (eachSeries)
          }
        }, function() {
          callback();//continue next step (waterfall)
        });
      },

      //4. Add words categories if any
      function(callback) {
        console.log('STEP 4: Add words categories if any');
        
        if (ENABLE_EDIT) {
          async.eachSeries($sliceds, function(slice, callback) {
            var $curr = $(slice),
                start = $curr.attr('data-char-start'),
                end = $curr.attr('data-char-end'),
                wordId = $curr.attr('data-word-id'),
                $inputContainer = $("#wci_" + start + "-" + end);

            //only rebuild word relationships when dirty flag was found
            if ($inputContainer.length > 0 && $inputContainer.hasClass('dirty')) {
              console.log('Found input for word, ID = ' + wordId);
              //delete all row in word_relationships that refer to it

              console.log('Deleting all exisitng word_relationships that refer to it');
              $.ajax({
                url: '/word_relationships/custom_destroy/' + wordId + '.json',
                type: 'DELETE',
                dataType: 'json',
                success: function() {
                  console.log('Deleted word_relationships for word, ID = ' + wordId);
                },
                complete: function() {
                  //insert the input into word_relationships table
                  var $inputs = $inputContainer.find("input[type!='text']");

                  console.log('Travel through each input...');
                  async.eachSeries($inputs, function(input, callback) {
                    var $currInput = $(input),
                        isChecked = $currInput.get(0).checked,
                        wordCategoryId = ((isChecked) ? parseInt($currInput.val()) : -1);

                    if (isChecked) {
                      console.log('Adding new categories...');
                      $.ajax({
                        url: '/word_relationships.json',
                        type: 'POST',
                        dataType: 'json',
                        data: {
                          'word_relationship': {
                            'word_id': wordId,
                            'word_category_id': wordCategoryId
                          }
                        },
                        success: function(data) {
                          console.log('Added new categories for word, ID = ' + wordId);
                        },
                        complete: function() {
                          callback();//continue next item ($inputs) (eachSeries)
                        }
                      });
                    } else {
                      callback();//continue next item ($inputs) (eachSeries)
                    }
                  }, function() {
                    callback();//continue next item ($sliceds) (eachSeries)
                  });
                }
              });
            } else {
              callback();//continue next item ($sliceds) (eachSeries)
            }
          }, function() {
            callback();//continue next step (waterfall)
          });
        } else {
          console.log('SKIP...');
          callback(); 
        }
      },

      //5. Reorder words index
      function(callback) {
        console.log('STEP 5: Reorder words index');
        
        if (ENABLE_EDIT) {
          var sliceIdx = -1;

          async.eachSeries($sliceds, function(slice, callback) {
            var currIdx = ++sliceIdx;

            var $curr = $(slice),
                wordId = $curr.attr('data-word-id');

            console.log('Updating word order...');
            $.ajax({
              url: '/words/' + wordId + '.json',
              type: 'PUT',
              dataType: 'json',
              data: {
                'word': {'word_order': (currIdx + 1)}
              },
              success: function(data) {
                console.log('Updated word order, ID = ' + wordId);
              },
              complete: function() {
                callback();//continue next item ($sliceds) (eachSeries)
              }
            });
          }, function() {
            callback();//continue next step (waterfall)
          });
        } else {
          console.log('SKIP...');
          callback(); 
        }
      }
    ], function(error) {
      callback(JSON.stringify(_extractSlicedPos()));//save function callback
    });
  }

  function _onWaitComplete(callback) {
    if (_waitCount === 0) {
      // console.log('Wait complete. Calling CALLBACK...');
      callback(JSON.stringify(_extractSlicedPos()));
    } else {
      setTimeout(function() {
        _onWaitComplete(callback);
      }, 1000);
    }
  }

  function _onLoadQuestionCheck($currInputContainer, totalRelationships, timeout, callback) {
    // console.log('Waiting for load question to complete...');
    //never been started
    if (_loadQuestionTimeout === null) {
      _loadQuestionTimeout = setTimeout(function() {
        _onLoadQuestionCheck($currInputContainer, totalRelationships, timeout, callback);
      }, timeout);
    //already started
    } else {
      //get total selected radio and checkbox
      var totalSelectedRadio = $currInputContainer.find("input[type='radio']:checked").length,
          totalSelectedCheckbox = $currInputContainer.find("input[type='checkbox']:checked").length,
          totalSelectedInput = totalSelectedRadio + totalSelectedCheckbox;

      //total selection equal total relationships mean all being loaded
      if (totalSelectedInput === totalRelationships) {
        _loadQuestionTimeout = null;
        setTimeout(function() {
          callback();
        }, 500);
      //still loading question and apply existing selection
      } else {
        _loadQuestionTimeout = setTimeout(function() {
          _onLoadQuestionCheck($currInputContainer, totalRelationships, timeout, callback);
        }, timeout);
      }
    }
  }

  //PUBLIC
  return {
    init: function(containerId, options, callback) {
      _$container = $(containerId);

      if (options !== undefined) {
        _options.mode = options.mode || _defaultOptions.mode;
        _options.lineWrapWidth = options.lineWrapWidth || _defaultOptions.lineWrapWidth;
        //can only reassign aya wrapper and sliced events in non-edit mode
        _options.wrapAya = (_options.mode !== "edit") ? (options.wrapAya || "") : (_defaultOptions.wrapAya);
        _options.loadingGif = options.loadingGif || _defaultOptions.loadingGif;
        _options.slicedClick = (_options.mode !== "edit") ? (options.slicedClick || function() { return false; }) : (_defaultOptions.slicedClick);
        _options.slicedDblClick = (_options.mode !== "edit") ? (options.slicedDblClick || function() { return false; }) : (_defaultOptions.slicedDblClick);
        _options.slicedMouseEnter = (_options.mode !== "edit") ? (options.slicedMouseEnter || function() { return false; }) : (_defaultOptions.slicedMouseEnter);
        _options.slicedMouseLeave = (_options.mode !== "edit") ? (options.slicedMouseLeave || function() { return false; }) : (_defaultOptions.slicedMouseLeave);
      } else {
        _options = _defaultOptions;
      }

      _startSelecting = false;

      if(_$container.length > 0) {
        _preprocess(function() {
          if(_options.mode === "edit") {
            _bindArabicCharEvent();
            _bindTextCursorEvent();
          }

          if (callback !== undefined) {
            console.log('CALLBACK()');//idz
            callback();
          }
        });

        return true;
      } else {
        return false;
      }
    },
    lineWrap: function(callback) {
      _lineWrapProcessing(callback);
    },
    get: function() {
      return JSON.stringify(_extractSlicedPos());
    },
    set: function(slicesJson) {
      if(slicesJson !== undefined && slicesJson.length > 0) {
        var slices = JSON.parse(slicesJson);
        _markSlicedChars(slices);
        return true;
      } else {
        return false;
      }
    },
    //callback is a function with 1 parameter that return latest sliced json
    save: function(callback) {
      //_save(callback);
      _save(function(slicingData) {
        //once save is done remove all dirty flag
        $('.dirty').removeClass('dirty');
        callback(slicingData);
      });
    }
  };
} ());