function ue_ready()
{   
	afterEditorInit()
   // UE.getEditor('editor').setHeight(600)
    setContent(currcontent,false);

    ue.addListener("selectionchange", function() {
		
		// var _selection = window.getSelection && window.getSelection();
		// console.log(_selection.rangeCount)
		// if(_selection && _selection.rangeCount > 0){
		// 	var _range  =  _selection.getRangeAt(0);
		// }
		
        //var e2 = ue.selection.getRange().getClosedNode();
        pop.clearToolBorder(this);
        window.console.info(this);

		var e = this.selection.getRange().getClosedNode();
		if(e && "IMG" == e.tagName) return void pop.popups[ue.uid].hide();
		for(var t = ue.selection.getStartElementPath(), n = -1, r = 0; r < t.length; r++) {
			var o = t[r];
			if("SECTION" === o.nodeName && "_wxbEditor" === o.className) {
				var i = document.createElement("section");
				i.setAttribute("class", "tool-border"), o.insertBefore(i, o.childNodes[0]), n = r;
				break
			}
		}
		window.console.info("n:"+n);
		if(n!=-1)
		{
			//(alert("a"),alert("b"));
			window.console.info(t);
			pop.popups[ue.uid].currentElement = t[n];
			editor_s(ue, pop.popups[ue.uid].currentElement);
		}
		//- 1 != n && (pop.popups[ue.uid].currentElement = t[n], s(ue, pop.popups[ue.uid].currentElement))
    });

	pop.init(ue);
    /*
    ue.addListener("click", function(t, evt) {
        evt = evt || window.event;
        var e1 = evt.target || evt.srcElement;
        //var e2 = ue.selection.getRange().getClosedNode();
        alert(e1.tagName);
        pop.clearToolBorder(this);
        window.console.info(this);
        if(e1 && "IMG" == e1.tagName) return void pop.popups[this.uid].hide();
    });*/

	//加载h5模板
	loadTemplateMenu();
	//loadImageVideo();
}

function r(e, t, n) {
	return t in e ? Object.defineProperty(e, t, {
		value: n,
		enumerable: !0,
		configurable: !0,
		writable: !0
	}) : e[t] = n, e
}

var pop = {
        getPopup: function(e) {
            return new window.UE.ui.Popup({
                editor: e,
                content: "",
                className: "edui-bubble popup-img popup-click",
                canClick: !0,
                _preblank: function() {
                    e.undoManger.save();
                    var t = document.createElement("p");
                    this.anchorEl.parentNode.insertBefore(t, this.anchorEl), e.fireEvent("contentChange")
                },
                _blank: function() {
                    e.undoManger.save();
                    var t = document.createElement("p");
                    this.anchorEl.parentNode.insertBefore(t, this.anchorEl.nextSibling), e.fireEvent("contentChange")
                },
                _remove: function() {
                    e.undoManger.save();
                    var t = this.anchorEl;
                    t.parentNode.removeChild(t), e.fireEvent("contentChange"), this.hide()
                },
                _clean: function() {
                    e.undoManger.save();
                    var t = this.anchorEl,
                        n = t.outerHTML,
                        r = n.match(/[^<]*>[^<]*</gi),
                        o = [];
                    r.forEach(function(e) {
                        var t = e.match(/>([^<]*)</),
                            n = e.match(/img.*src="([^"]*)"/);
                        t && t[1] && o.push("<p>" + t[1] + "</p>"), n && n[1] && o.push('<img alt="" src="' + n[1] + '" />')
                    }), t.outerHTML = o.join(""), e.fireEvent("contentChange"), this.hide()
                },
                _changeColor: function(t, n) {
                    var a = this,
                        s = this,
                        u = new i.ColorPicker({
                            element: this.getDom(),
                            hex: n,
                            onChange: function(i) {
                                e.undoManger.save();
                                var a = "rgb(" + i.rgb.r + ", " + i.rgb.g + ", " + i.rgb.b + ")";
                                u.changeCurrentColor(a), s.pickerTargetColor ? s.pickerTargetColor[n] = a : s.pickerTargetColor = r({}, n, a), t.style.backgroundColor = a, (0, o.setNodeColor)(null, a, n, s.colorNodeList), e.fireEvent("contentChange")
                            },
                            onClear: function() {
                                e.undoManger.save(), t.style.backgroundColor = n, (0, o.setNodeColor)(null, n, n, a.colorNodeList), e.fireEvent("contentChange")
                            }
                        });
                    u.clean(), u.open()
                },
                _removeColor: function(t, n) {
                    event.stopPropagation(), e.undoManger.save(), (0, o.setNodeColor)(null, "", n, this.colorNodeList), s(e, this.currentElement)
                }
            })
        },
        clearToolBorder: function(e) {
            var t = e.body.querySelectorAll("._wxbEditor .tool-border");
            try {
                t = Array.prototype.slice.call(t)
            } catch(e) {
                return
            }
            t && t.forEach(function(e) {
                return $(e).remove()
            })
            //alert("clear");
        },
        init: function(e) {
            pop.popups ? pop.popups[e.uid] = pop.getPopup(e) : pop.popups = r({}, e.uid, pop.getPopup(e)), pop.popups[e.uid].render(), pop.popups[e.uid].addListener("hide", function() {
                pop.clearToolBorder(e)
            })
			window.console.info(pop);
        }
    },
	editor_s = function(e, t) {
			//var n = (0, o.getNodeColor)(t);
			var n = (0, i_.getNodeColor)(t);
			window.console.info("n:"+n);

			var r = '<nobr class="wxb-editor-popup-tool"><span onclick="$$._preblank()">上空行</span><span onclick="$$._blank()">下空行</span><span class="split">|</span><span class="copy">复制</span><span class="cut">剪切</span><span onclick="$$._remove()">删除</span><span class="split">|</span><span onclick="$$._clean()">清除样式</span></nobr>';

			//(new i.ColorPicker).clean();
			n.colors.length && (r += '<div class="color-select-list"><div class="head">现有颜色：</div>' + n.colors.map(function(t) {
				return '<span class="color-bread" onclick="$$._changeColor(this, \'' + t + '\')" style="background-color: ' + t + ';" title="点击更换颜色">\n            ' + (e.options.canRemoveStylePickerColor ? '<i class="" onClick="$$._removeColor(this, \'' + t + '\')" title="移除改颜色">X</i>' : "") + "</span>"
			}).join("") + "</div>");
			pop.popups[e.uid].colorNodeList = n.colorNodeList;
			var s = pop.popups[e.uid].formatHtml(r);
			s ? (pop.popups[e.uid].getDom("content").innerHTML = s, pop.popups[e.uid].anchorEl = t, pop.popups[e.uid].showAnchor(pop.popups[e.uid].anchorEl, !0)) : pop.popups[e.uid].hide();
			var u = pop.popups[e.uid].getDom("content").querySelector(".copy"),
				l = pop.popups[e.uid].getDom("content").querySelector(".cut");
			if(window.ZeroClipboard) {
				var c = new window.ZeroClipboard(u);
				c.on("ready", function() {
					c.on("copy", function(t) {
						t.clipboardData.setData("text/html", pop.popups[e.uid].anchorEl.outerHTML)
					})
				});
				var f = new window.ZeroClipboard(l);
				return void f.on("ready", function() {
					f.on("copy", function(t) {
						t.clipboardData.setData("text/html", pop.popups[e.uid].anchorEl.outerHTML), pop.popups[e.uid].anchorEl.parentNode.removeChild(pop.popups[e.uid].anchorEl)
					})
				})
			}
			if(window.nw) {
				var p = window.nw.Clipboard.get();
				return u.addEventListener("click", function() {
					p.set(pop.popups[e.uid].anchorEl.outerHTML, "html"), pop.popups[e.uid].hide()
				}), void l.addEventListener("click", function() {
					p.set(pop.popups[e.uid].anchorEl.outerHTML, "html"), pop.popups[e.uid].anchorEl.parentNode.removeChild(pop.popups[e.uid].anchorEl), pop.popups[e.uid].hide()
				})
			}
			u.parentNode.removeChild(u), l.parentNode.removeChild(l)
		};

	var r_ = ["color", "backgroundColor", "borderColor", "borderLeftColor", "borderTopColor", "borderRightColor", "borderBottomColor"],
		o_ = ["inherit", "transparent", "initial"];
		var i_ = {
			getNodePosition: function(e) {
				for(var t = e.offsetTop, n = e.offsetLeft, r = e.offsetParent; null !== r;) t += r.offsetTop, n += r.offsetLeft, r = r.offsetParent;
				var o = 0,
					i = 0;
				return "BackCompat" == document.compatMode ? (o = document.body.scrollTop, i = document.body.scrollLeft) : o = document.documentElement.scrollTop, {
					top: t - o,
					left: n - i,
					width: e.offsetWidth,
					height: e.offsetHeight
				}
			},
			convertNode: function(e) {
				if("string" == typeof e) {
					var t = document.createElement("div");
					t.innerHTML = e, e = t.childNodes[0]
				}
				return e
			},
			getNodeColor: function(e) {
				e = i_.convertNode(e);
				for(var t = e.querySelectorAll("*"), n = [], a = {}, s = function(e) {
						var i = t[e];
						i_.style && r_.forEach(function(e) {
							i_.style[e] && -1 === i_.style[e].indexOf("transparent") && !o_.includes(i_.style[e]) && (n.includes(i_.style[e]) || n.push(i_.style[e]), a[i_.style[e]] ? a[i_.style[e]].push({
								type: e,
								node: i_
							}) : a[i_.style[e]] = [{
								type: e,
								node: i_
							}])
						})
					}, u = 0; u < t.length; u++) s(u);
				return {
					colors: n,
					colorNodeList: a
				}
			},
			setNodeColor: function(e, t, n, r) {
				if(e = i.convertNode(e), !n || !r) {
					var o = i.getNodeColor(e);
					r || (r = o.colorNodeList), n || (n = o.colors)
				}
				return "string" == typeof n && (n = [n]), n.forEach(function(e) {
					r[e].forEach(function(e) {
						e.node.style[e.type] = t
					})
				}), e ? e.outerHTML : null
			}
		};

//var o = n(444);

//获得内容
function getContent() {
    var content = ue.getContent() ;
    if(content==""){
        try{
            if(document.getElementById("h5editor1_Frame").contentWindow.WXBEditor){
                content = h5_getContent();
            }
        }catch(e){

        }
    }
    content = content.replace(/(<img class="tide_video_fake".*?)>/gi,"");
    content = content.replace(/(<img class="tide_photo_fake".*?)>/gi,"");
    return content;
}
//写入内容
function setContent(content,isAppendTo){
    var img = "<img class=\"tide_video_fake\" src=\"../editor/images/spacer.gif\" _fckfakelement=\"true\" _fckrealelement=\"1\">";
    var img1 = "<img class=\"tide_photo_fake\" src=\"../editor/images/spacer.gif\" _fckfakelement=\"true\" _fckrealelement=\"1\">";

    content = content.replace(/(<span id="tide_video">(.+?)<\/span>)/gi,"$1"+img);
    content = content.replace(/(<span id="tide_photo">(.+?)<\/span>)/gi,"$1"+img1);
    ue.setContent(content,isAppendTo);
}
//获得纯文本
function getContentTxt(){
    return ue.getContentTxt();
}
//返回当前编辑器对象
function getUE(){
    return ue;
}

