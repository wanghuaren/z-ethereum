package com.bellaxu.display
{
	import com.bellaxu.def.ResPathDef;
	import com.bellaxu.res.ResTool;
	import com.bellaxu.util.StageUtil;
	import com.greensock.TweenLite;
	
	import common.utils.CtrlFactory;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	import ui.base.mainStage.UI_index;

	public class FubenTips
	{
		private static var spr:Sprite;
		private static var t1:TextField;
		private static var t2:TextField;
		private static var t3:TextField;
		private static var tf:TextFormat=new TextFormat("STXingkai", 40, 0xF8F8A8);

		public static function show(x:int, str1:String="", str2:String="", str3:String=""):void
		{
//			var spr:Sprite = ResTool.getMc(ResPathDef.GAME_CORE, "Fuben_Tips_" + type);
			var str:String;

			spr=new Sprite();
			spr.mouseChildren=spr.mouseEnabled=false;
			var txt:TextField=new TextField();
			txt.name="t1";
			spr.addChild(txt);
			txt=new TextField();
			txt.name="t2";
			spr.addChild(txt);
			txt=new TextField();
			txt.name="t3";
			spr.addChild(txt);


			StageUtil.addChild(spr);
			t1=spr.getChildByName("t1") as TextField;
			t2=spr.getChildByName("t2") as TextField;
			t3=spr.getChildByName("t3") as TextField;
			if (str1 != "")
			{
				str="";
				for (var i:int=0; i < str1.length; i++)
				{
					str+=str1.charAt(i) + "\n";
				}
				t1.text=str;
				t1.setTextFormat(tf);
				CtrlFactory.getUIShow().setfilters(t1);
				t1.width=t1.textWidth;
				t1.height=t1.textHeight + 10;
			}
			if (str2 != "")
			{
				str="";
				for (i=0; i < str2.length; i++)
				{
					str+=str2.charAt(i) + "\n";
				}
				t2.text=str;
				t2.setTextFormat(tf);
				CtrlFactory.getUIShow().setfilters(t2);
				t2.width=t2.textWidth;
				t2.height=t2.textHeight + 10;
				t2.x=t1.width + 15;
				t2.y=40;
			}
			if (str3 != "")
			{
				str="";
				for (i=0; i < str3.length; i++)
				{
					str+=str3.charAt(i) + "\n";
				}
				t3.text=str;
				t3.setTextFormat(tf);
				CtrlFactory.getUIShow().setfilters(t3);
				t3.width=t3.textWidth;
				t3.height=t3.textHeight + 10;
				t3.x=t2.x + t2.width + 15;
				t3.y=70;
			}
			spr.x=x;
			spr.y=(UI_index.indexMC.stage.stageHeight - spr.height) / 2;

			var mask1:Sprite=new Sprite();
			mask1.graphics.beginFill(0xff0000, 1);
			mask1.graphics.drawRect(t1.x, t1.y, t1.width, t1.height);
			mask1.graphics.endFill();
			var mask2:Sprite=new Sprite();
			mask2.graphics.beginFill(0xff0000, 1);
			mask2.graphics.drawRect(t2.x, t2.y, t2.width, t2.height);
			mask2.graphics.endFill();
			var mask3:Sprite=new Sprite();
			mask3.graphics.beginFill(0xff0000, 1);
			mask3.graphics.drawRect(t3.x, t3.y, t3.width, t3.height);
			mask3.graphics.endFill();

			mask1.addChild(mask2);
			mask2.addChild(mask3);
			mask3.y=-20;
			spr.addChild(mask1);
			spr.mask=mask1;

			mask1.height=0;
			mask2.height=0;
			mask3.height=0;
			TweenLite.to(mask1, 2, {height: t1.height, onComplete: function():void
			{
				TweenLite.to(mask2, 3, {height: t2.y + t2.height, onComplete: function():void
				{
					TweenLite.to(mask3, 4, {height: t3.y + t3.height, onComplete: function():void
					{
						setTimeout(function():void
						{
							TweenLite.to(spr, 2, {alpha: 0, onComplete: function():void
							{
								StageUtil.removeChild(spr);
							}});
						}, 15000);
					}});
				}});
			}});
		}
	}
}
