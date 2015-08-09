package scene.kingname
{
	import __AS3__.vec.Vector;
	
	import com.bellaxu.def.FilterDef;
	import com.bellaxu.def.LibDef;
	import com.bellaxu.model.lib.Lib;
	import com.bellaxu.res.ResTool;
	
	import common.config.xmlres.XmlManager;
	import common.managers.Lang;
	
	import engine.load.GamelibS;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	
	import world.WorldFactory;

	public class KingChatHead extends Sprite
	{
		private var _v:MovieClip;

		//private var _message:String;

		private var _v_TE:Sprite;

		public function KingChatHead()
		{
//			this.cacheAsBitmap=true
			this.mouseChildren=this.mouseEnabled=false;
		}

		public function init():void
		{			

			if (null != v && !this.contains(v))
			{
				this.addChild(v);
			}

			if (null != v)v.gotoAndStop(1);

			//			
			initTxt();

			this.x=0;
			this.y=0;
			
			//
			this.removeEventListener(Event.REMOVED_FROM_STAGE, 
				WorldFactory.CHAT_HEAD_REMOVED_FROM_STAGE);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, 
				WorldFactory.CHAT_HEAD_REMOVED_FROM_STAGE);
		}

		public function gotoAndStop(frame:Object):void
		{
			if (null != v)
			{
				v.gotoAndStop(frame);
			}
		}

		public function gotoAndPlay(frame:Object):void
		{
			if (null != v)
			{
				v.gotoAndPlay(frame);
			}
		}

		public function initTxt():void
		{
			//txt.autoSize = TextFieldAutoSize.LEFT;
			//txt.multiline = true;
			//txt.width = 110;
			//txt.wordWrap = true;

			//
			//txt.text =_message = "";
			if (null != v)
			{
				this.v.addChild(this.v_TE);
			}
		}

		//public function processMessage(message:String):String
		public function parseMessage(message:String):void
		{

			if (null == message)
			{
				//return "";
				return;
			}

			if ("" == message)
			{
				//return "";
				return;
			}

			parse(message);

			//return message.replace(/<.*?>|{.*?}/g, "  ");
		}

		/**
		 * 1122{F030}33
		 * 我不是黄营中石油中石油{F040}
		 * {F034}{F033}{F021}
		 *
		 * {11310201:2}{F020}
		 */
		private function parse(s:String):void
		{
			//test
			//s = "{11310201:2}{F020}";

			/*var elementFormat:ElementFormat = new ElementFormat();
			elementFormat.fontSize = 12;
			elementFormat.color = 0xFFFFFF;*/

			var sLen:int=s.length;

			var textSentenceBegin:int;
			var textSentenceEnd:int;
			var textSentence:String="";

			var graphSentenceBegin:int;
			var graphSentenceEnd:int;
			var graphSentence:String="";

			var hasGraph:Boolean=false;
			//道具
			if(s.indexOf("{T")>=0){
				var temp:String=s.substring(s.indexOf("{T@"),(s.indexOf("}")+1));
				var temp2:String=temp.split("@")[1];
				s=s.replace(temp,temp2);
			}
			while (s.length > 0)
			{
				if (s.indexOf("{") > -1)
				{
					textSentenceBegin=0;
					textSentenceEnd=s.indexOf("{");
					textSentence="";

					if (textSentenceEnd > 0)
					{
						textSentence=s.substr(textSentenceBegin, textSentenceEnd);
						TEContent.push(new TextElement(textSentence, eleFrmt));
						s=s.substr(textSentenceEnd, s.length);

					}

					//
					graphSentenceBegin=s.indexOf("{");
					graphSentenceEnd=0;
					graphSentence="";

					if (s.indexOf("}") > -1)
					{
						graphSentenceEnd=s.indexOf("}") + 1; //把}也包括进去		

						graphSentence=s.substr(graphSentenceBegin, graphSentenceEnd);

						hasGraph=parseGraph(graphSentence);

						s=s.substr(graphSentenceEnd, s.length);
					}
					else
					{
						//无法找到闭合标签
						//throw new Error("无法找到闭合标签:" + s);
						break;
					}


				} //end if
				else
				{
					textSentenceBegin=0;
					textSentenceEnd=s.length;
					textSentence=s.substr(textSentenceBegin, textSentenceEnd);
					TEContent.push(new TextElement(textSentence, eleFrmt));
					s=s.substr(textSentenceEnd, s.length);
				}

			} //end while


			//
			var _textBlock:TextBlock=new TextBlock(new GroupElement(TEContent));

			//28
			if (sLen > 18)
			{
				//v.gotoAndStop(2);

				v_TE.x=-122;
				//v_TE.y = 14;//28;//12;
				if (hasGraph)
				{
					v_TE.y=24; //图片的高度，以免图片高出聊天背景框

				}
				else
				{
					v_TE.y=14;


				}

				displayTextBlock(_textBlock, this.v_TE, 175);

				if (hasGraph)
				{
					//
					if (null != bg)
					{
						bg.width=190;
						bg.height=this.v_TE.height + 40;
					}

				}
				else
				{
					//
					if (null != bg)
					{
						bg.width=190;
						bg.height=this.v_TE.height + 30;
					}
				}

				//
				if (null != bg)
				{
					bg.x=-134;
				}

			}
			else
			{
				//v.gotoAndStop(1);

				v_TE.x=-50;
				//v_TE.y = 14;//28;//12;
				if (hasGraph)
				{
					v_TE.y=24; //图片的高度，以免图片高出聊天背景框
				}
				else
				{
					v_TE.y=14;
				}

				displayTextBlock(_textBlock, this.v_TE, 98);

				//bg.height = this.v_TE.height + 40;	
				if (null != bg)
				{
					bg.width=116;
					bg.height=this.v_TE.height + 30;

					bg.x=-60;
				}
			}




			//默认宽度是98
			//displayTextBlock(_textBlock,this.v_TE,98);


		}

		/**
		 * 有可能不是图形元素
		 * {11310201:2}{F020}
		 */
		private function parseGraph(sg:String):Boolean
		{
			//f = face
			var f:MovieClip;
			var d:DisplayObject;

			var libName:String=sg.replace("{", "");
			libName=libName.replace("}", "");

			var hasGraph:Boolean=false;

			//表情
			if (libName.indexOf(":") == -1 && libName.indexOf("F") == 0)
			{
				d=WorldFactory.createFace(libName);

				if (null == d)
				{
					return hasGraph;
				}

				f=d as MovieClip;

				//表情默认宽高28
				//var graphicElement:GraphicElement = new GraphicElement(f,28,28, eleFrmt);
				var graphicElement:GraphicElement=new GraphicElement(f, 24, 24, eleFrmt);
				TEContent.push(graphicElement);

				hasGraph=true;

				return hasGraph;
			}

			//道具
			var itemName:String;

			if (libName.indexOf(":") > -1)
			{
				var arr_:Array=libName.split(":");
		//项目转换		itemName="[" + Pub_ToolsResModel(Lib.getObj(LibDef.PUB_TOOLS, String(arr_[0]))).tool_name + "]";
itemName="[" + XmlManager.localres.getToolsXml.getResPath(arr_[0])["tool_name"] + "]";
				TEContent.push(new TextElement(itemName, eleFrmt));

				return hasGraph;
			}

			//道具2
	//项目转换		if (null != Lib.getObj(LibDef.PUB_TOOLS, libName))
			if (null != XmlManager.localres.getToolsXml.getResPath(parseInt(libName)))
			{
	//项目转换			itemName="[" + Pub_ToolsResModel(Lib.getObj(LibDef.PUB_TOOLS, libName)).tool_name + "]";
				itemName="[" + XmlManager.localres.getToolsXml.getResPath(parseInt(libName))["tool_name"] + "]";

				TEContent.push(new TextElement(itemName, eleFrmt));

				return hasGraph;
			}

			return hasGraph;
		}

		//
		private function displayTextBlock(textBlock:TextBlock, container:Sprite, width:Number):void
		{
			// clear the old lines if any
			while (container.numChildren)
				container.removeChildAt(0);

			var textLine:TextLine;
			var prevLine:TextLine;
			for (; ; )
			{
				textLine=textBlock.createTextLine(prevLine, width);
				if (!textLine)
					break;
				//textLine.y = prevLine ? prevLine.y + textLine.height : textLine.ascent;
				//行距8
				textLine.y=prevLine ? prevLine.y + textLine.height + 8 : textLine.ascent;
				container.addChild(textLine);
				prevLine=textLine;
			}
			
			//
			textBlock.releaseLineCreationData();

						
		}


		//get 

		public function get v():MovieClip
		{
			if (null == _v)
			{
				//项目转换 _v = ResTool.getAppMc("ChatHead") as MovieClip;
				_v=GamelibS.getswflink("game_index","ChatHead") as MovieClip;

				if (null != _v)
				{
					_v.mouseChildren=_v.mouseEnabled=false;
				}

				this.mouseChildren=this.mouseEnabled=false;
			}

			return _v;
		}

		public function get v_TE():Sprite
		{
			if (null == _v_TE)
			{
				_v_TE=new Sprite();
				_v_TE.mouseChildren=_v_TE.mouseEnabled=false;
				//_v_TE.filters
				//_v_TE.x = -50;
				//_v_TE.y = 14;//28;//12;

				//_v_TE.filters = new Array(new GlowFilter(0,1,2,2,4,1,false,false));
				_v_TE.filters=new Array(FilterDef.CHAT_HEAD_FILTER);
			}

			return _v_TE;

		}


		public function get bg():MovieClip
		{
			if (null == v)
			{
				return null;
			}

			return v["chatBg"] as MovieClip;
		}

		/*public function get msg():String
		{
			return _message;
		}*/

		public function set msg(message:String):void
		{
			//_message = processMessage(message);

			//txt.text = _message;

			//40是bg比txt多出的原始高度
			//bg.height = txt.textHeight + 40;

			clearTEContent();

			parseMessage(message);


		}

		public function clearTEContent():void
		{
			_content=null;


			if (null == this.v_TE.parent)
			{
				if (null != v)
				{
					this.v.addChild(this.v_TE);
				}
			}

			while (v_TE.numChildren)
				v_TE.removeChildAt(0);
		}

		/**
		 *
		 */
		private var _content:Vector.<ContentElement>;

		public function get TEContent():Vector.<ContentElement>
		{
			if (null == _content)
			{
				_content=new Vector.<ContentElement>();
			}

			return _content;
		}

		/**
		 *
		 */
		private var _eleFrmt:ElementFormat;

		public function get eleFrmt():ElementFormat
		{
			if (null == _eleFrmt)
			{
				//"NSimSun"
				//var fd:FontDescription = new FontDescription("NSimSun");
				var fd:FontDescription=new FontDescription(Lang.getLabel("pub_font"));
				_eleFrmt=new ElementFormat(fd);
				_eleFrmt.fontSize=12;
				//_eleFrmt.color = 0xFFFFFF;
				_eleFrmt.color=0x000000;

					
			}

			return _eleFrmt;
		}



	}
}
