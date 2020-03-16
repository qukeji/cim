/**********************************************************
XWebMenu Class v2.1

Browsers Supported:
MSIE 6+
Mozilla 1.5+
FireFox .9+

Online Documentation: http://www.wdonline.com/dhtml/xwebmenu/
(c) 2004   Jeremy McPeak  jwmcpeak@gmail.com
**********************************************************/
var XWebMenu = {
    Handlers    : {
	    System		: {
		    Count : 0, All : {}, GetId : function () { return "XWeb_MenuBar_" + this.Count++; }
	    },
	    MenuBarItem	: {
		    Count : 0, All : {}, GetId : function () { return "XWeb_MenuBarItem_" + this.Count++; }
	    },
	    Menu: {
		    Count : 0, All : {}, GetId : function () { return "XWeb_MenuMenu_" + this.Count++; }
	    },
	    MenuItem	: {
		    Count : 0, All : {}, GetId : function () { return "XWeb_MenuMenuItem_" + this.Count++; }
	    },
	    All : {}
	},
	//Classes
	XWebMenu : function (name) {
	    this.Id			= XWebMenu.Handlers.System.GetId();
	    this.Name		= (name)?name:this.Id;
	    this.Items		= [];
	    this.Behavior   = "standard";
	    this.ShownMenu	= null;
	    this.Type		= "XWebMenu_Class";
	    this.Layer = document.createElement("DIV");
	    this.Layer.id = this.Id;
	    this.Layer.className = "cls-xweb-menu-bar";
	    document.body.appendChild(this.Layer);
	
    	XWebMenu.Handlers.System.All[this.Name] = this;
    	XWebMenu.Handlers.All[this.Name] = this;
	
    	if (!XWebMenu.Settings[this.Name])
	        XWebMenu.Settings[this.Name] = XWebMenu.Settings["Global"];
	
    	if (this.Id != this.Name) {
		    XWebMenu.Handlers.System.All[this.Id] = this;
		    XWebMenu.Handlers.All[this.Id] = this;
    	}
    	//Methods
    	this.Add = function (text,click,subMenu) {
	        var num = this.Items.length;
	        this.Items[num] = new XWebMenu.MenuBarItem(this,text,click,subMenu);
	        this.Items[this.Items[num].Id] = this.Items[num];
	        return this.Items[num].Menu;
        };
        
        this.Delete = function () {
            if (this.Items.length > 0) {
                for ( var i = 0; i < this.Items.length; i++ ) {
                    this.Items[i].Delete();
                    delete this.Items[i];
                }
            }
            document.body.removeChild(this.Layer);
        };

        this.MoveTo = function (x,y) {
            this.Layer.style.left = x + "px";            this.Layer.style.top = y + "px";        };
		
    	if (name) {
            XWebMenu.AutoSetup(this);
	    }
    },
    MenuBarItem : function (parent,text,click,subMenu) {
        this.Parent	= parent;
	    this.Name	= this.Parent.Name;
	    this.Id		= XWebMenu.Handlers.MenuBarItem.GetId();
	    this.Menu	= null;
	    this.Type	= "XWebMenu_BarItem";
	    this.IsJs	= false;
	    this.Click	= click;
	    this.Target = null;
	        
    	this.Layer = document.createElement("SPAN");
    	this.Layer.id = this.Id
    	this.Layer.className = "cls-xweb-menu-baritem";
    	
    	if (XWebMenu.User.Ie) {
    	    this.Dummy = document.createElement("SPAN");
    	    this.Dummy.appendChild(document.createTextNode(" "));
    	    this.Dummy.className = "cls-xweb-menu-ie-dummy";
    	    this.Layer.appendChild(this.Dummy);
    	    this.Dummy.style.left = "0px";
    	    this.Dummy.style.visibility = "hidden";
    	    this.Dummy.style.position = "absolute";
    	    this.Dummy.style.width = "1px";
    	    this.Dummy.style.height = "1px";
    	    this.Dummy.style.fontSize = "0px";
    	}
    	
    	XWebMenu.Handlers.MenuBarItem.All[this.Id] = this;
    	XWebMenu.Handlers.All[this.Id] = this;
    	
    	var arg = XWebMenu.MenuBarItem.arguments[3];
    	if ((typeof arg == "boolean") || (typeof arg == "undefined") || (typeof arg == "number")) {
		    if (arg || (typeof arg == "undefined")) {}
		    else this.IsJs = true;
	    } else if  (typeof arg == "string") this.Menu = this.Parent[subMenu] = new XWebMenu.Menu(this.Parent,this);
    	
    	this.Layer.appendChild(document.createTextNode(text));
    	this.Parent.Layer.appendChild(this.Layer);
    	//Methods
    	this.MouseOver = function () {
	        var clsName = this.Layer.className;
	        if (this.Parent.Behavior == "mouse") {
        	    this.Layer.className = "cls-xweb-menu-baritem-click";
	            if (this.Parent.ShownMenu && this.Parent.ShownMenu != this.Menu) 
            	    this.Parent.ShownMenu.Item.MouseOut();
    	        if (this.Menu) this.MouseClick();
            } else {
                if (this.Parent.ShownMenu && this.Parent.ShownMenu != this.Menu) {
    	            this.Parent.ShownMenu.Item.MouseOut();
    	            if (this.Menu) this.MouseClick();
    	            else this.Layer.className = "cls-xweb-menu-baritem-over";
    	        } else
                    if (clsName != "cls-xweb-menu-baritem-click") this.Layer.className = "cls-xweb-menu-baritem-over";
            }
            if (!this.IsJs && !this.Menu) self.status = this.Click;
        };
    
        this.MouseOut = function (override) {
    	    if (override) {
    	        if (!this.Menu) this.Layer.className = "cls-xweb-menu-baritem";
	            if (!this.Parent.ShownMenu) this.Layer.className = "cls-xweb-menu-baritem";
	        }
	        if (this.Menu && !override) {
        	    this.Menu.Hide();
	            this.Layer.className = "cls-xweb-menu-baritem";
    	    }
	        self.status = "";
        };

        this.MouseClick = function () {
            var behavior = this.Parent.Behavior;
    	    if (this.Menu) {
    	        if (!this.Menu.Shown) {
    	            XWebMenu.CloseMenus(true);
	                this.Menu.Show();
	                this.Layer.className = "cls-xweb-menu-baritem-click";
	                if (this.Dummy) {
	                    this.Dummy.style.visibility = "visible";
	                    this.Dummy.style.top = this.Layer.offsetHeight - 1 + "px";
	                    this.Dummy.style.backgroundColor = this.Layer.currentStyle["borderLeftColor"];
	                }
	            } else {
        	        if (this.Parent.Behavior != "mouse") {
	                    this.Menu.Hide();
	                    this.Layer.className = "cls-xweb-menu-baritem-over";
	                }
	            }
	        } else {
                if (this.IsJs) eval(this.Click);
	            else window.location = this.Click;
		        XWebMenu.CloseMenus(true);
            }
        };

        this.Delete = function () {
            if (this.Menu) {
                this.Menu.Delete();
                delete this.Menu;
            }
            this.Parent.Layer.removeChild(this.Layer);
        };    
    },
    Menu : function (parent,menuItem) {
        if (!parent) return;
	    this.Item           = menuItem;
	    this.Parent			= parent;
	    this.Name			= this.Parent.Name;
	    this.Items			= [];
	    this.Shown			= false;
	    this.Id				= XWebMenu.Handlers.Menu.GetId();
	    this.Type			= "XWebMenu_Menu";
	    this.ShownMenu	    = null;
	    
	    this.Layer = document.createElement("DIV");
	    this.Layer.className = "cls-xweb-menu-outer-div";
	    
	    this.ShadowLayer = document.createElement("DIV");
	    this.ShadowLayer.className = "cls-xweb-menu-shadow-div";
	    
    	this.MenuLayer = document.createElement("DIV");	
    	this.MenuLayer.className = "cls-xweb-menu-menu-div";
    	this.MenuLayer.id = this.Id;
    	this.Container = document.createElement("DIV");
    	this.Container.className = "cls-xweb-menu-menu-tablecontainer";
    	this.Table = document.createElement("TABLE");
    	this.Table.className = "cls-xweb-menu-menu-table";
    	this.Table.border = 0;
    	this.Table.cellSpacing = 0;
    	this.Table.cellPadding = 0;
    	this.TBody = document.createElement("TBODY");
    	this.Table.appendChild(this.TBody);
    	this.Container.appendChild(this.Table);
	    this.MenuLayer.appendChild(this.Container);
	    this.Layer.appendChild(this.ShadowLayer);
	    this.Layer.appendChild(this.MenuLayer);
	    
	    var system = XWebMenu.Handlers.System.All[this.Name];
	    var _parent = (system)?system.Layer:document.body;
	    _parent.appendChild(this.Layer);
	
	    XWebMenu.Handlers.Menu.All[this.Id] = this;
	    XWebMenu.Handlers.All[this.Id] = this;
    },
    Context : function (el,name) {
        this.Base = XWebMenu.Menu;
        this.Base(true,null);
    
        this.Behavior = "mouse";
        this.Name = (name)?name:this.Id;
        this.Type = "XWebMenu_Context";
    
        if (!XWebMenu.Settings[this.Name])
    	    XWebMenu.Settings[this.Name] = XWebMenu.Settings["Global"];
    	    
        if (name) {
            XWebMenu.AutoSetup(this);
	    }
	    if (el) {
	        el.XWebContextMenu = this;
	        el.oncontextmenu = this.Show;
	    }
    },
    MenuItem : function (parent,text,url,icon,subMenu) {
        var args = XWebMenu.MenuItem.arguments;
        var isSeparator = (args.length > 1)?false:true;
	
	    this.Parent		= parent;
	    this.Name		= this.Parent.Name;
	    this.Id			= XWebMenu.Handlers.MenuItem.GetId();
	    this.Icon		= null;
	    this.Menu	    = null;
	    this.Type		= (!isSeparator)?"XWebMenu_MenuItem":"XWebMenu_MenuItem_Separator";
	    this.IsJs		= false;
	    this.Click		= url;
	    this.Target     = null;
	
	    this.TableRow = document.createElement("TR");
	    this.TableRow.id = this.Id;
	    this.TableRow.className = "cls-xweb-menuitem-parent";
	
	    if (!isSeparator) {
    	    this.LeftCell = document.createElement("TD");
	        this.LeftCell.className = "cls-xweb-menu-left";
	        this.LeftCell.id = this.Id + "_left";
    	
	        this.MiddleCell = document.createElement("TD");
	        this.MiddleCell.className = "cls-xweb-menu-middle";
	        this.MiddleCell.appendChild(document.createTextNode(text));
	        this.MiddleCell.id = this.Id + "_middle";
    	
    	    this.RightCell = document.createElement("TD");
    	    this.RightCell.className = "cls-xweb-menu-right";
    	    this.RightCell.appendChild(document.createTextNode(" "));
    	    this.RightCell.id = this.Id + "_right";
    	
	        if (icon) {
        		this.Icon = document.createElement("IMG");
		        this.Icon.src = icon;
		        this.LeftCell.appendChild(this.Icon);
		        this.LeftCell.align = "left";
		        this.LeftCell.vAlign = "middle";
	        } else {
        		this.LeftCell.appendChild(document.createTextNode(" "));
    	    }
    	
	        this.TableRow.appendChild(this.LeftCell);
	        this.TableRow.appendChild(this.MiddleCell);
	        this.TableRow.appendChild(this.RightCell);
    	    
	        XWebMenu.Handlers.All[this.LeftCell.id] = this;
	        XWebMenu.Handlers.All[this.MiddleCell.id] = this;
	        XWebMenu.Handlers.All[this.RightCell.id] = this;
    	    
	        var arg = args[4];
	        if ((typeof arg == "boolean") || (typeof arg == "undefined") || (typeof arg == "number")) {
    		    if (arg || typeof arg == "undefined") {}
		        else this.IsJs = true;
	        } else if  (typeof arg == "string") {
		        this.RightCell.className = "cls-xweb-menu-right-arrow";
		        this.Menu = this.Parent[subMenu] = new XWebMenu.Menu(this.Parent,this);
	        }
	    } else {
    	    var sepCell = document.createElement("TD");
            sepCell.id = this.Id + "_sepCell";
	        sepCell.className = "cls-xweb-menu-td-separator";
	        sepCell.colSpan = 3;
	        var sepDiv = document.createElement("DIV");
	        sepDiv.id = this.Id + "_sepDiv";
	        sepDiv.className = "cls-xweb-menu-div-separator";
    
	        sepCell.appendChild(sepDiv);
	        this.TableRow.appendChild(sepCell);
	        XWebMenu.Handlers.All[sepCell.id] = this;
	        XWebMenu.Handlers.All[sepDiv.id] = this;
	    }
    
        this.Parent.TBody.appendChild(this.TableRow);
	
    	XWebMenu.Handlers.MenuItem.All[this.Id] = this;
    	XWebMenu.Handlers.All[this.Id] = this;
    	this.MouseOver = function () {
	        var rightClass = (this.RightCell.className.indexOf("arrow") > -1)?"cls-xweb-menu-right-arrow-highlight":"cls-xweb-menu-right-highlight";

	        this.LeftCell.className = "cls-xweb-menu-left-highlight"
	        this.MiddleCell.className = "cls-xweb-menu-middle-highlight";
	        this.RightCell.className = rightClass;
	        
	        if (this.Parent.ShownMenu && this.Parent.ShownMenu != this.Menu)
	            this.Parent.ShownMenu.Item.MouseOut();
    	
	        if (this.Menu) this.Menu.Show();
	        if (!this.IsJs && !this.Menu) self.status = this.Click;
        };

        this.MouseOut = function () {
            var rightClass = (this.RightCell.className.indexOf("arrow") > -1)?"cls-xweb-menu-right-arrow":"cls-xweb-menu-right";
	        this.LeftCell.className = "cls-xweb-menu-left"
	        this.MiddleCell.className = "cls-xweb-menu-middle";
	        this.RightCell.className = rightClass;
	        if (this.Menu) this.Menu.Hide();
	        self.status = "";
        };

        this.MouseClick = function () {
	        if (!this.Menu) {
	            if (this.IsJs) eval(this.Click);
	            else {
	                if (this.Target) window.open(this.Click);
	                else window.location = this.Click;
	            }
		        XWebMenu.CloseMenus(true);
            }
        };

        this.Delete = function () {
	        if (this.Menu) {
	            this.Menu.Delete();
	            delete this.Menu;
	        }
	        this.Parent.TBody.removeChild(this.TableRow);
        };
    },
    //Necessary Members
    AutoSetup : function (thisObject,thisNode) {
        if (!thisNode) {
            var doc = XWebMenu.Xml.Document;
            if (doc) {
                var systems = (thisObject.Type == "XWebMenu_Class")?doc.getElementsByTagName("system"):doc.getElementsByTagName("context");
                for ( var i = 0; i < systems.length; i++ ) {
                    if ( systems[i].getAttribute("name") == thisObject.Name ) {
                        thisNode = systems[i];
                        if (systems[i].getAttribute("behavior")) thisObject.Behavior = systems[i].getAttribute("behavior").toLowerCase();
                        break;
                    }
                    thisNode = null;
                }
                if (!thisNode) thisObject.Delete();
            } else {
                thisObject.Delete();
            }
        }
        if (thisNode != null) {
            switch (thisObject.Type) {
                case "XWebMenu_Class":
                    var menuBarItems = thisNode.getElementsByTagName("menuBarItem");
                    for ( var i = 0; i < menuBarItems.length; i++ ) {
                        var menuBarItem = menuBarItems[i];
                        var menu = menuBarItem.getElementsByTagName("menu")[0];
                        if (menu && menu.getAttribute("src")) {
                            var fragSrc = menu.getAttribute("src");
                            var frag;
                            try {
                                frag = new XWebMenu.XmlReader(fragSrc);
                                menu = frag.Document.cloneNode(true);
                                delete frag.Document;
                                frag = null;
                            } catch (e) {}
                        }
                        
                        var text = menuBarItem.getElementsByTagName("text")[0].text;
                        var clickNode = (!menu)?menuBarItem.getElementsByTagName("click")[0]:0;
                        
                        var click = (clickNode)?clickNode.text:0;
                        var clickJs = (menu)?XWebMenu.RandomName():(clickNode.getAttribute("type") == "script")?false:true;
                        var newWindow = false;
                        if ( clickJs && typeof clickJs == "boolean" ) {
                            if ( clickNode.getAttribute("target") && clickNode.getAttribute("target") == "_blank" ) newWindow = true;
                        }
                        var newMenu = thisObject.Add(text,click,clickJs);
                        thisObject.Items[thisObject.Items.length - 1].Target = newWindow;
                        if (newMenu) XWebMenu.AutoSetup(newMenu,menu);
                    }
                break;
                case "XWebMenu_Context":
                case "XWebMenu_Menu":
                    var menuItems = thisNode.getElementsByTagName("menuItem");
                    for ( var i = 0; i < menuItems.length; i++ ) {
                        var menuItem = menuItems[i];
                        if (menuItem.parentNode == thisNode) {
                            var attType = menuItem.getAttribute("type");
                            if (attType == "separator") {
                                thisObject.Add();
                            }
                            else if (!attType || attType == "normal") {
                                var subMenu = menuItem.getElementsByTagName("subMenu")[0];
                                if (subMenu && subMenu.getAttribute("src")) {
                                    var fragSrc = subMenu.getAttribute("src");
                                    var frag;
                                    try {
                                        frag = new XWebMenu.XmlReader(fragSrc);
                                        subMenu = frag.Document.cloneNode(true);
                                        delete frag.Document;
                                        frag = null;
                                    } catch (e) {}
                                }
                                var text = menuItem.getElementsByTagName("text")[0].text;
                                var clickNode = (!subMenu)?menuItem.getElementsByTagName("click")[0]:0;
                        
                                var icon = 0;
                                if (menuItem.getElementsByTagName("icon")[0] && menuItem.getElementsByTagName("icon")[0].parentNode == menuItem)
                                    icon = menuItem.getElementsByTagName("icon")[0].text
                                var click = (clickNode)?clickNode.text:0;
                                var clickJs = (subMenu)?XWebMenu.RandomName():(clickNode.getAttribute("type") == "script")?false:true;
                                
                                var newWindow = false;
                                
                                if ( clickJs && typeof clickJs == "boolean" ) {
                                    if ( clickNode.getAttribute("target") && clickNode.getAttribute("target") == "_blank" ) newWindow = true;
                                }
                                
                                var newSubMenu = thisObject.Add(text,click,icon,clickJs);
                                thisObject.Items[thisObject.Items.length - 1].Target = newWindow;
                        
                                if (newSubMenu) XWebMenu.AutoSetup(newSubMenu,subMenu);
                           }
                        }
                    }
                break;
            }
        }
    },
	CloseMenus : function (override) {
		clearTimeout(XWebMenu.Timer);
		for ( var i = 0; i < this.Handlers.System.Count; i++ ) {
			var menuSystem = this.Handlers.System.All["XWeb_MenuBar_" + i];
			if (menuSystem) {
		        if ((menuSystem.ShownMenu && this.Timer && menuSystem.Behavior == "mouse") || (menuSystem.ShownMenu && override)) 
				    menuSystem.ShownMenu.Item.MouseOut();
			}
		}
		
		for ( var i = 0; i < this.Handlers.Menu.Count; i++ ) {
		    var menu = this.Handlers.Menu.All["XWeb_MenuMenu_" + i];
		    if (menu) {
		        if ((menu.Shown && this.Timer && menu.Behavior == "mouse") || (menu.Shown && override)) {
		            menu.Hide();
		        }		    
		    }		
		}
		this.Timer = null;
		this.ShownObject = false;
	},
	RandomName : function () {
	    var str = "";
        for ( var randNum = 0; randNum < 10; randNum++ ) {
            str += ""+ Math.floor(Math.random() * 9) + "";
        }
	    return str;
	},
	GetSettingsFromXml : function (settingsNode) {
        this.MenuOffsetX = this.MenuOffsetY = this.SubMenuOffsetX = this.SubMenuOffsetY = 0;
        if (settingsNode) {
            for (var i = 0; i < settingsNode.childNodes.length; i++) {
    	        var thisNode = settingsNode.childNodes[i];
	            if (thisNode.nodeType == 1) {
        	        switch (thisNode.tagName.toLowerCase()) {
    	                case "menuoffset":
    	                    this.MenuOffsetX = thisNode.getAttribute("x");
    	                    this.MenuOffsetY = thisNode.getAttribute("y");
	                    break;
	                    case "submenuoffset":
	                        this.SubMenuOffsetX = thisNode.getAttribute("x");
    	                    this.SubMenuOffsetY = thisNode.getAttribute("y");
	                    break;
	                }
                }
	        }
	    }
    },
	Init : function () {
        XWebMenu.HasXml = (XWebMenu.Xml.Document)?true:false;
        var globalSettingsNode = (XWebMenu.HasXml)?XWebMenu.Xml.Document.getElementsByTagName("globalSettings")[0]:0;
        XWebMenu.Settings["Global"] = new this.GetSettingsFromXml(globalSettingsNode);
    
        if (XWebMenu.HasXml) {
            var systems = XWebMenu.Xml.Document.getElementsByTagName("system");
            for ( var i = 0; i < systems.length; i++ ) {
                if ( systems[i].getAttribute("name") ) {
                    XWebMenu.Settings[systems[i].getAttribute("name")] = (systems[i].getElementsByTagName("settings")[0])?new this.GetSettingsFromXml(systems[i].getElementsByTagName("settings")[0]):XWebMenu.Settings["Global"];
                }    
            }
        }
    
        this.Event.SetEvent(document,"mouseover",XWebMenu.Event.MouseHandler);
        this.Event.SetEvent(document,"mouseout",XWebMenu.Event.MouseHandler);
        this.Event.SetEvent(document,"click",XWebMenu.Event.MouseHandler);
        this.Event.SetEvent(window,"load",XWebMenu.Event.PageLoadInit);
    },
	//Xml Members
	XmlReader : function (fileName) {	    var xmlObj;

	    if ( document.implementation && document.implementation.createDocument )
		    xmlObj = document.implementation.createDocument( "", "", null );
	    else if ( window.ActiveXObject )
		    xmlObj = new ActiveXObject( "MSXML.DomDocument" );
	
	    xmlObj.async = false;
	    xmlObj.load( "xml/" + fileName );
		
	    this.Document = xmlObj.documentElement;    },
	Settings : {},
	Xml : null,
	HasXml : false,
	//Necessary Members
	ShownObject : false,
    Timer : null,
	//More Necessary Members
	UserAgent : function () {
	    this.v = navigator.userAgent.toLowerCase();
	    this.Dom = document.getElementById?1:0;	    this.Ie = (function(ua){	        if (ua.indexOf("msie") > -1) {
                var regex = new RegExp("msie ([0-9]{1,}[\.0-9]{0,})");
                if (regex.exec(ua) != null)
                var version = parseInt( RegExp.$1 );
                
                return (version >= 6);
            } else
                return false;        })(this.v);	    this.cssCompat = (this.Ie && document.compatMode == "CSS1Compat")?1:0;	    this.Gecko = (this.v.indexOf("gecko") > -1 && this.Dom)?1:0;	    this.Safari = (this.v.indexOf("safari") > -1 && this.Dom)?1:0;	    var geckoVersion = (this.Gecko)?parseInt(navigator.productSub):0;	    this.Moz = (geckoVersion > 20020512)?1:0;	    this.Dhtml = (this.Ie || this.Moz)?1:0;
	},
	PageObj : function () {    	this.X = (XWebMenu.User.Moz)?innerWidth:(XWebMenu.User.cssCompat)?document.documentElement.clientWidth:document.body.clientWidth;    	this.Y = (XWebMenu.User.Moz)?innerHeight:(XWebMenu.User.cssCompat)?document.documentElement.clientHeight:document.body.clientHeight;    	this.X2 = this.x / 2; this.Y2 = this.y / 2;    },
	Page    : null,
	User    : null,
	Event   : {
	    SetEvent : function (oName,sEvent,fn) {        	if (XWebMenu.User.Ie) {		        sEvent = "on" + sEvent;		        oName.attachEvent(sEvent,fn);            }	        if (XWebMenu.User.Moz || XWebMenu.User.Safari) {        		if (sEvent == "mouseenter") sEvent = "mouseover";		        if (sEvent == "mouseleave") sEvent = "mouseout";		        oName.addEventListener(sEvent,fn,false);	        }        },        ReleaseEvent : function (oName,sEvent,fn) {        	if (XWebMenu.User.Ie) {		        var sEvent = "on" + sEvent;		        oName.detachEvent(sEvent,fn);	        }	        if (XWebMenu.User.Moz || XWebMenu.User.Safari) {        		if (sEvent == "mouseenter") sEvent = "mouseover";		        if (sEvent == "mouseleave") sEvent = "mouseout";		        oName.removeEventListener(sEvent,fn,false);	        }        },
        PageLoadInit : function () {
            XWebMenu.Page = new XWebMenu.PageObj();
        },
        MouseHandler : function (event) {
	        var eSrc = (XWebMenu.User.Moz)?event.target:window.event.srcElement;
	        eSrc = (eSrc.className)?eSrc:eSrc.parentNode;
	        eSrc = (!eSrc.tagName || eSrc.tagName == "HTML" || eSrc.tagName == "BODY")?0:eSrc;
	        var item;
    
	        if (XWebMenu.Handlers.All[eSrc.id]) item = XWebMenu.Handlers.All[eSrc.id];
	        switch (event.type) {
		        case "mouseover":
			        if (item) {
				        XWebMenu.ShownObject = true;
				        clearTimeout(XWebMenu.Timer);
				        XWebMenu.Timer = null;
				        if (item.Type == "XWebMenu_BarItem" || item.Type == "XWebMenu_MenuItem") item.MouseOver();
			        } else {
				        if (XWebMenu.ShownObject) XWebMenu.Timer = setTimeout("XWebMenu.CloseMenus()",1000);
			        }
		        break;
		        case"mouseout":
			        if (item) {
				        if (item.Type == "XWebMenu_BarItem") item.MouseOut(true);					
				        if (item.Type == "XWebMenu_MenuItem") if (!item.Menu) item.MouseOut();
        				
			        }
		        break;
		        case "click":
			        if (item) {
				        if (item.Type == "XWebMenu_BarItem" || item.Type == "XWebMenu_MenuItem") item.MouseClick();			
			        } else 
			            XWebMenu.CloseMenus(true);
	            break;
	        }
        }
    }
};

XWebMenu.User = new XWebMenu.UserAgent();XWebMenu.Xml = new XWebMenu.XmlReader("xwebmenu.xml");
/* Menu Methods (For Inheritance) */
XWebMenu.Menu.prototype.Add = function (text,url,icon,subMenu) {
    var isSeparator = (XWebMenu.Menu.prototype.Add.arguments.length > 0)?false:true;
	var num = this.Items.length;
	this.Items[num] = (!isSeparator)?new XWebMenu.MenuItem(this,text,url,icon,subMenu):new XWebMenu.MenuItem(this);
	return this.Items[num].Menu;
};

XWebMenu.Menu.prototype.Delete = function () {
    if (this.Items.length > 0) {
        for ( var i = 0; i < this.Items.length; i++ ) {
            this.Items[i].Delete();
            delete this.Items[i];
        }
    }
    var system = XWebMenu.Handlers.System.All[this.Name];
	var _parent = (system)?system.Layer:document.body;
	_parent.removeChild(this.Layer);
};

XWebMenu.Menu.prototype.Show = function () {
    var isSubMenu = (this.Parent.Type == "XWebMenu_Class")?false:true;
    var x, y;
    var offsetX = (isSubMenu)?parseInt(XWebMenu.Settings[this.Name].SubMenuOffsetX):parseInt(XWebMenu.Settings[this.Name].MenuOffsetX);
    var offsetY = (isSubMenu)?parseInt(XWebMenu.Settings[this.Name].SubMenuOffsetY):parseInt(XWebMenu.Settings[this.Name].MenuOffsetY);
	this.ShadowLayer.style.width = this.MenuLayer.offsetWidth + "px";
	this.ShadowLayer.style.height = this.MenuLayer.offsetHeight + "px";
	if (!isSubMenu) {
	    y = this.Parent.Layer.offsetHeight + offsetY;
	    x = this.Item.Layer.offsetLeft;	    
	    x = ((x + this.MenuLayer.offsetWidth) > XWebMenu.Page.X)?XWebMenu.Page.X - this.MenuLayer.offsetWidth:x + offsetX;
    } else {
        var parentLength = this.Parent.Layer.offsetLeft + this.Parent.MenuLayer.offsetWidth;
	    y = this.Item.TableRow.offsetTop + this.Parent.Layer.offsetTop + offsetY;
	    y = (XWebMenu.User.Moz)?y-1:y;   
	    x = ((parentLength + this.MenuLayer.offsetWidth) > XWebMenu.Page.X)?this.Parent.Layer.offsetLeft - this.MenuLayer.offsetWidth + 2:parentLength - 3 + offsetX;
    }
    this.MoveTo(x,y);
    this.Layer.style.visibility = "visible";	    
	this.Shown = true;
	this.Parent.ShownMenu = this;
};

XWebMenu.Menu.prototype.Hide = function() {
    if (this.ShownMenu) this.ShownMenu.Item.MouseOut();
    if (this.Item.Dummy) this.Item.Dummy.style.visibility = "hidden";
	this.Layer.style.visibility = "hidden";
	this.Shown = false;
	this.Parent.ShownMenu = null;
};

XWebMenu.Menu.prototype.MoveTo = function (x,y) {
    this.Layer.style.left = x + "px";    this.Layer.style.top = y + "px";};

/* Context Methods */
XWebMenu.Context.prototype = new XWebMenu.Menu();
XWebMenu.Context.prototype.Show = function (e) {
    var e = (XWebMenu.User.Moz)?e:event;
    var x, y;
    var mouseX = x = e.clientX;
    var mouseY = y = e.clientY;

    var menu = this.XWebContextMenu;
    
    if (mouseX + menu.Layer.offsetWidth > XWebMenu.Page.X)
        x = mouseX - menu.Layer.offsetWidth;
    if (mouseY + menu.Layer.offsetHeight > XWebMenu.Page.Y)
        y = mouseY - menu.Layer.offsetHeight;
    
    y += document.documentElement.scrollTop;
    e.cancelBubble = true;
    menu.MoveTo(x,y);
    XWebMenu.CloseMenus(true);
    menu.ShadowLayer.style.width = menu.MenuLayer.offsetWidth + "px";
	menu.ShadowLayer.style.height = menu.MenuLayer.offsetHeight + "px";

    menu.Layer.style.visibility = "visible";
    menu.Shown = true;
    return false;
};

XWebMenu.Context.prototype.Hide = function () {
    if (this.ShownMenu) this.ShownMenu.Item.MouseOut();
	this.Layer.style.visibility = "hidden";
	this.Shown = false;
	this.Parent.ShownMenu = null;
};

XWebMenu.Context.prototype.Attach = function (el) {
    el.XWebContextMenu = this;
	el.oncontextmenu = this.Show;
};

XWebMenu.Context.prototype.Detach = function (el) {
    el.XWebContextMenu = null;
	el.oncontextmenu = null;
};
        
/* Extending Mozilla */if (XWebMenu.User.Moz) {    //Thanks to Erik for the text property    Text.prototype.__defineGetter__( "text", function () {
		    //return this.nodeValue; //Temp fix for Firecrap 1.0.3
	    }
    );
	
    Node.prototype.__defineGetter__( "text", function () {
	    var cs = this.childNodes;
	    var l = cs.length;
	    var sb = new Array( l );
	    for ( var i = 0; i < l; i++ )
	        sb[i] = cs[i].nodeValue;
	    return sb.join("");
	    }
    );
}

XWebMenu.Init();