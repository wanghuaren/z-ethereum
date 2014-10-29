package scene.human
{
	import com.bellaxu.def.DepthDef;
	import com.bellaxu.def.MusicDef;
	import com.bellaxu.res.ResMc;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;

	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.utils.CtrlFactory;
	import common.utils.res.ResCtrl;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import netc.Data;

	import scene.action.Action;
	import scene.event.KingActionEnum;
	import scene.king.IGameKing;
	import scene.king.SkinBySkill;
	import scene.king.TargetInfo;
	import scene.manager.SceneManager;
	import scene.utils.MapCl;

	import world.FileManager;
	import world.IWorld;
	import world.WorldFactory;
	import world.graph.WorldSprite;

	public class GameDrop extends WorldSprite implements IWorld
	{

		private var tf_name:TextField=new TextField();


		public function GameDrop()
		{

		}


		public function DelHitArea():void
		{
			//
		}

		public function UpdHitArea():void
		{
			//
		}
		private var txtFormat:TextFormat;

		public function init():void
		{
			this.x=0;
			this.y=0;

			//
			tf_name.text="        ";

			// 测试缓存效果
			tf_name.cacheAsBitmap=true

			this.addChild(tf_name);

			//
			this.mouseChildren=false;

			//
			this.depthPri=DepthDef.TOP;

			//test

			this.graphics.clear();
			this.graphics.beginFill(0x001100);
			this.graphics.drawRect(0, 0, 32, 32);
			this.graphics.endFill();
		}
		public var currIndex:int=0;
		public var currObj:int=0;

		public function setData(_itemID:int, resDate:Pub_ToolsResModel, tipParam:Array, num:int):void
		{
			if (resDate == null)
				return;
			if (txtFormat == null)
			{
				txtFormat=new TextFormat();
				txtFormat.color=0xfff5d2;
				txtFormat.size=12;
				txtFormat.font="SimSun";
			}
			txtFormat.color="0x" + ResCtrl.instance().arrColor[resDate.tool_color];
			tf_name.defaultTextFormat=txtFormat;
			if ((_itemID + "").substr(0, 3) == "113")
			{
				//				txt.htmlText="<b>" + ResCtrl.instance().arrTitle[resDate.tool_color ] + "·" + tipParam[0] + (num > 1 ? " × " + num : "") + "</b>";
				tf_name.htmlText="<b>" + (num > 1 ? num+" ": "") + tipParam[0] + "</b>";
			}
			else
			{
				tf_name.htmlText=(num > 1 ?num+" " : "")+tipParam[0];
			}
			tf_name.width=tf_name.textWidth + 10;
			tf_name.height=tf_name.textHeight + 3;

			tf_name.y=-tf_name.height - 10;
			CtrlFactory.getUIShow().setColor(tf_name, 5, 0x000000);

		}
	}
}
