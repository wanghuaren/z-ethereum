package ui.component
{
	import engine.load.GamelibS;
	import engine.utils.Debug;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.*;


	public class XHTree extends Sprite
	{
		private var _container:Sprite;
		private var _data:Array;

		public static const NODE_ICON:String="node_icon";
		public static const NODE_TITLE:String="node_title";

		public var NODE_TITLE_DATA_PROPERTY_NAME:String;

		public var _openItems:Array;

		private var sp:Sprite;

		public function XHTree(sp_:DisplayObject=null)
		{
			//
			_container=new Sprite();
			sp=sp_ == null ? null : (sp_ as Sprite);
			//
			this.addChild(_container);
			if (sp != null)
			{
				this.addChild(sp);
				sp.mouseEnabled=false;
				sp.visible=false;
			}
		}

		/**
		 *  {mission_txt:s2Arr[j],
								  cycle:array[i].cycle,
								  king_level:array[i].king_level,
								  npc:array[i].npc,
								  result:array[i].result,
								  ring:array[i].ring,
								  task_id:array[i].task_id,
								  task_sort:array[i].task_sort,
								  task_status:array[i].task_status,
								  task_title:array[i].task_title,
								  fly_shoe_visible:fly_shoe_visible
							};
							 *
				parentNodeCanClick为true，则父级菜单需要有数据
		 */
		public function dataProvider(value:Array, TreeNodeItemRenderClassName:String, titlePropertyName:String, parentNodeCanClick:Boolean=false):void
		{
			if (null == titlePropertyName)
			{
				throw new Error("titlePropertyName can not be null");
			}

			if ("" == titlePropertyName)
			{
				Debug.instance.traceMsg("warnning: titlePropertyName be empty");
			}

			NODE_TITLE_DATA_PROPERTY_NAME=titlePropertyName; // "mission_txt";			

			var i:int;
			var len:int;
			var k:int;

			//
			_data=value.concat();

			//
			len=_data.length;

			//以fly_shoe_visible判定root结点
			k=0;
			var pn:String;
			for (i=0; i < len; i++)
			{
				//项目转换 	var treeNodeClass:Class=ResTool.getAppCls(TreeNodeItemRenderClassName);
				var treeNodeClass:Class=GamelibS.getswflinkClass("game_index", TreeNodeItemRenderClassName);

				//(this.parent as testTreeAS3).ld.contentLoaderInfo.applicationDomain.getDefinition(TreeNodeItemRenderClassName) as Class;

				var treeRes:Sprite=new treeNodeClass();
				treeRes["data"]=_data[i];
				_container.addChild(treeRes);

				treeRes.y=k * treeRes.height;
				treeRes.name="item_" + i.toString();
				_data[i]["nodeVisible"]=treeRes.visible;
				if (i == 1 && sp != null)
				{
					sp.visible=true;
					treeRes.addChild(sp);
					sp.y=-3
				}
				//				
				var title:String=_data[i][NODE_TITLE_DATA_PROPERTY_NAME];

				//<font color='#00ff00'>
				(treeRes[NODE_TITLE] as TextField).htmlText=title;

				//根据fly_shoe_判定结点
				if (_data[i]["parentNode"])
				{
					(treeRes[NODE_ICON] as MovieClip).gotoAndStop(2);
					(treeRes[NODE_ICON] as MovieClip).visible=true;
					_data[i]["expand"]=true;
					_data[i]["parentNode"]="";
					(treeRes[NODE_ICON] as MovieClip).addEventListener(MouseEvent.CLICK, NODE_ICON_CLICK);

					//没有子结点的父级，不显示+-图标
					if ((i + 1) < len)
					{
						if (_data[(i + 1)]["parentNode"])
						{
							(treeRes[NODE_ICON] as MovieClip).visible=false;
						}
					}

					if ((i + 1) == len)
					{
						(treeRes[NODE_ICON] as MovieClip).visible=false;
					}

					//父级菜单也可点
					if (parentNodeCanClick)
					{
						(treeRes[NODE_TITLE] as TextField).addEventListener(MouseEvent.CLICK, NODE_TEXTFIELD_CLICK);
					}
					//
					pn=treeRes.name;
				}
				else
				{
					_data[i]["parentNode"]=pn;
					(treeRes[NODE_ICON] as MovieClip).visible=false;
					treeRes.addEventListener(MouseEvent.CLICK, NODE_TITLE_CLICK);
					treeRes.mouseChildren=false;
					treeRes.buttonMode=true;

						//treeRes["fly_shoe"].visible = false;
				}

				k++;
			} //end for


		}

		public function NODE_TEXTFIELD_CLICK(event:MouseEvent):void
		{
			if (sp != null)
			{
				event.target.parent.addChild(sp);
				sp.y=-3;
				sp.visible=true;
			}
			dispatchEvent(new XHTreeEvent(XHTreeEvent.ITEM_CLICK, event.target.parent));

		}

		public function NODE_TITLE_CLICK(event:MouseEvent):void
		{
//			var nodeName:String = event.target.parent.name;
//			
//			var nodeIndex:int = nodeName.split("_")[1];
			if (sp != null)
			{
				event.target.addChild(sp);
				sp.y=-3;
				sp.visible=true;
			}
			dispatchEvent(new XHTreeEvent(XHTreeEvent.ITEM_CLICK, event.target));

		}

		public function NODE_ICON_CLICK(event:MouseEvent):void
		{
			//
			var nodeName:String=event.target.parent.parent.name;

			var nodeIndex:int=nodeName.split("_")[1];

			//
			var pn:String=this._container.getChildAt(nodeIndex).name;

			if (pn != nodeName)
			{
				throw new Error("getChildAt(nodeIndex) can not equal name");
			}

			//
			var pnTree:DisplayObject=this._container.getChildAt(nodeIndex);

			if (_data[nodeIndex]["expand"])
			{
				_data[nodeIndex]["expand"]=false;
				(pnTree[NODE_ICON] as MovieClip).gotoAndStop(1);

			}
			else
			{
				_data[nodeIndex]["expand"]=true;
				(pnTree[NODE_ICON] as MovieClip).gotoAndStop(2);
			}

			var i:int;
			var len:int;


			var nv:Boolean=_data[nodeIndex]["expand"];


			len=this._data.length;
			for (i=0; i < len; i++)
			{
				if (_data[i]["parentNode"] == pn)
				{
					this._container.getChildAt(i).visible=nv;

				} //end if 
			}


			//set y 
			var k:int;

			k=0;
			for (i=0; i < len; i++)
			{
				var cnTree:DisplayObject=this._container.getChildAt(i);
				if (cnTree.visible)
				{
					cnTree.y=k * pnTree.height;
					k++;
				}
				else
				{
					//nothing
				}
			}

		}

		/**
		 * true 展开所有
		 * false 折叠所有
		 */
		public function set expandAll(value:Boolean):void
		{
			if (null == this._data)
			{
				throw new Error("you need set data property");
			}

			var dataLen:int;
			var pnTree:DisplayObject;
			var pn:String;

			//收起
			//-----------------------------------------------------------------

			dataLen=this._data.length;

			for (var nodeIndex:int=0; nodeIndex < dataLen; nodeIndex++)
			{
				pnTree=this._container.getChildAt(nodeIndex);
				pn=pnTree.name;

				//****************
				if (!value)
				{
					if (_data[nodeIndex]["expand"])
					{
						_data[nodeIndex]["expand"]=false;
						(pnTree[NODE_ICON] as MovieClip).gotoAndStop(1);

					}
					//
					sp.visible=false;


				}

				if (value)
				{
					if (!_data[nodeIndex]["expand"])
					{
						_data[nodeIndex]["expand"]=true;
						(pnTree[NODE_ICON] as MovieClip).gotoAndStop(2);
					}
				}
				//****************

				//
				var nv:Boolean=_data[nodeIndex]["expand"];
				var i:int;
				var len:int=this._data.length;

				for (i=0; i < len; i++)
				{
					if (_data[i]["parentNode"] == pn)
					{
						this._container.getChildAt(i).visible=nv;

					} //end if 
				} //end for


			} //end for

			//set y
			var k:int;

			k=0;

			for (i=0; i < len; i++)
			{
				var cnTree:DisplayObject=this._container.getChildAt(i);
				if (cnTree.visible)
				{
					cnTree.y=k * pnTree.height;
					k++;
				}
				else
				{
					//nothing
				}
			}
			//--------------------------------------------------------------------				
		}






	}
}