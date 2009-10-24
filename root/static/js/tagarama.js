// PART OF YESH
// Tags allowed by default
var tags = new Object({
  'a':{'attr':["href","title","class"]
      ,'flow':"inline"
      }
  ,'acronym':{'attr':["title",]
         ,'flow':"inline"
         }
  ,'abbr':{'attr':["title",]
         ,'flow':"inline"
         }
  ,'b':{'attr':[]
      ,'flow':"inline"
      }
  ,'blockquote':{'attr':[]
      ,'flow':"block"
      }
  ,'br':{'attr':[]
         ,'flow':"inline"
         }
  ,'cite':{'attr':[]
          ,'flow':"inline"
          }
  ,'code':{'attr':[]
      ,'flow':"inline"
      }
  ,'dfn':{'attr':["title"]
         ,'flow':"inline"
         }
  ,'del':{'attr':[]
      ,'flow':"inline"
      }
  ,'div':{'attr':["class"]
      ,'flow':"block"
      }
  ,'hr':{'attr':[]
         ,'flow':"inline"
         }
  ,'i':{'attr':[]
      ,'flow':"inline"
      }
  ,'img':{'attr':["src","alt","longdesc","class"]
         ,'flow':"inline"
         }
  ,'ins':{'attr':[]
      ,'flow':"inline"
      }
  ,'tt':{'attr':[]
      ,'flow':"inline"
      }
  ,'var':{'attr':[]
      ,'flow':"inline"
      }
  ,'p':{'attr':["class"]
      ,'flow':"block"
      }
  ,'more':{'attr':["truncate"]
      ,'flow':"block"
      }
  ,'pre':{'attr':["class"]
         ,'flow':"block"
         }
  ,'ul':{'attr':[]
      ,'flow':"block"
      }
  ,'ol':{'attr':[]
      ,'flow':"block"
      }
  ,'li':{'attr':[]
      ,'flow':"inline"
      }
  ,'dl':{'attr':[]
      ,'flow':"block"
      }
  ,'di':{'attr':[]
      ,'flow':"block"
      }
  ,'dt':{'attr':[]
      ,'flow':"inline"
      }
  ,'dd':{'attr':[]
      ,'flow':"block"
      }
  ,'q':{'attr':[]
      ,'flow':"inline"
      }
  ,'h1':{'attr':[]
      ,'flow':"inline"
      }
  ,'h2':{'attr':[]
      ,'flow':"inline"
      }
  ,'h3':{'attr':[]
      ,'flow':"inline"
      }
  ,'h4':{'attr':[]
      ,'flow':"inline"
      }
  ,'sub':{'attr':[]
      ,'flow':"inline"
      }
  ,'sup':{'attr':[]
      ,'flow':"inline"
      }
  ,'span':{'attr':["class"]
      ,'flow':"inline"
      }
});

var aStyle = new Object({
  "border":"1px solid black"
  ,"margin":"2px 2px"
  ,"padding":"0 .3ex"
  ,"lineHeight":"120%"
  ,"textDecoration":"none"
  ,"fontSize":"9px"
//  ,"float":"left ! important"
//  ,"display":"block"
  ,"lineHeight":"13px"
  ,"fontWeight":"bold"
  ,"color":"black"
  ,"backgroundColor":"#ffa"
});

function tagBox (boxId, labelId) {
  if ( ! boxId ) boxId = "box";
  box = document.getElementById(boxId);
//  alert(box);
  var container = document.createElement("div");
  container.style.width = "100%";
  container.setAttribute('class', "mono");
//  $(container).addClass("mono");
  container.style.float = "left";
  container.style.clear = "both";
  var text = document.createTextNode("Autotags");
  container.appendChild(text);
  container.appendChild(document.createElement("br"));
  var boxLabel = document.getElementById(labelId);
  box.parentNode.insertBefore(container,boxLabel);

  for ( tag in tags ) {
    var item = document.createElement('a');
    item.setAttribute('href', 'javascript:void(0);');
    item.setAttribute('onclick', 'doTag("' + tag + '","' + boxId + '")');
    for ( var key in aStyle ) item.style[key] = aStyle[key];
    var text = document.createTextNode(tag);
    item.appendChild(text);
    container.appendChild(item);
    var space = document.createTextNode(' ');
    container.appendChild(space);
  }
  var item = document.createElement('a');
  item.setAttribute('href', 'javascript:void(0);');
  item.setAttribute('onclick', 'escapeSelected("' + boxId + '")');
  var text = document.createTextNode("esc");
  item.appendChild(text);
  container.appendChild(item);

  container.appendChild(document.createTextNode(" "));

  var item = document.createElement('a');
  item.setAttribute('href', 'javascript:void(0);');
  item.setAttribute('onclick', 'cpanLink("' + boxId + '")');
  var text = document.createTextNode("cpan");
  item.appendChild(text);
  container.appendChild(item);
}

function doTag (tagName, boxId) {
  box = document.getElementById(boxId);
  var cursorAt = box.selectionEnd;
  var preText  = box.value.substring(0, box.selectionStart);
  var selected = box.value.substring(box.selectionStart,box.selectionEnd);
  var postText = box.value.substring(box.selectionEnd, box.value.length);
  var scrollTop = box.scrollTop;

  var tag = document.createElement(tagName);
  // Fill attributes
  var attr = tags[tagName]["attr"];
  for ( var i = 0; i < attr.length; i++ ) {
    var action = attr[i];
    var value = prompt(tagName + ' ' + action + ':', '');
    if ( value ) tag.setAttribute( action, value );
  }

   tag.innerHTML = ( tags[tagName]["flow"] == "block" ) ?
       ( "\n" + selected + "\n" ) : selected;

// doesn't work   tag.removeAttribute('xmlns');

  var newXHTML = serializeXML(tag);

  box.value = preText + newXHTML + postText;
  box.value = box.value.replace(/\s+xmlns="[^"]+"/g, '');
  box.focus();
  var cursorAt = box.value.length;
  box.selectionStart = cursorAt;
  box.selectionEnd = cursorAt;
  box.scrollTop = scrollTop;

  box.focus();
}

function escapeSelected (boxId) {
  box = document.getElementById(boxId);
  var cursorAt = box.selectionEnd;
  var preText  = box.value.substring(0, box.selectionStart);
  var selected = box.value.substring(box.selectionStart,box.selectionEnd);
  var postText = box.value.substring(box.selectionEnd, box.value.length);
  var scrollTop = box.scrollTop;
  var newXHTML = selected.replace(/&/g, "&amp;");
  newXHTML = newXHTML.replace(/</g, "&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;");
  box.value = preText + newXHTML + postText;
  box.value = box.value.replace(/\s+xmlns="[^"]+"/g, '');
  box.focus();
  var cursorAt = box.value.length;
  box.selectionStart = cursorAt;
  box.selectionEnd = cursorAt;
  box.scrollTop = scrollTop;
  box.focus();
}


function cpanLink (boxId) {
  box = document.getElementById(boxId);
  var cursorAt = box.selectionEnd;
  var preText  = box.value.substring(0, box.selectionStart);
  var selected = box.value.substring(box.selectionStart,box.selectionEnd);
  var postText = box.value.substring(box.selectionEnd, box.value.length);
  var scrollTop = box.scrollTop;
  var dist = selected.replace(/::/g, "-");
  var mylink = document.createElement('a');

  mylink.setAttribute('href', "http://search.cpan.org/dist/" + dist);
  mylink.innerHTML = selected;
  var newXHTML = serializeXML(mylink);

  box.value = preText + newXHTML + postText;
  box.value = box.value.replace(/\s+xmlns="[^"]+"/g, '');
  box.focus();
  var cursorAt = box.value.length;
  box.selectionStart = cursorAt;
  box.selectionEnd = cursorAt;
  box.scrollTop = scrollTop;
  box.focus();
}

function serializeXML (xmlDocument) {
   var xmlSerializer;
   try {
      xmlSerializer = new XMLSerializer();
      return xmlSerializer.serializeToString(xmlDocument);
   }
   catch (e) {
      alert(err.description || "An unknown error was thrown");
      return '';
   }
}
