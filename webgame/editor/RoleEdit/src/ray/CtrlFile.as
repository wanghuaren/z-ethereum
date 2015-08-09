package ray
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.graphics.codec.PNGEncoder;
	
	import spark.components.TextArea;

	public final class CtrlFile
	{
		private var imgLib:Dictionary=null;

		private static var _instance:CtrlFile=null;

		private var txt:TextArea=null;

		private var g_count:int=0;

		private var g_cur:int=0;

		private var timer:Timer=new Timer(1);

		private var xml:String="";
		private var middleInfo:Array=[];
		public const ACTION:int=13;
		public const DIRECT:int=5;
		public var main_win:GameEditorR

		public static function get instance():CtrlFile
		{
			if (_instance == null)
			{
				_instance=new CtrlFile();
			}
			return _instance;
		}

		public function CtrlFile()
		{
			imgLib=new Dictionary();
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}

		public function dispose(textArea:TextArea):void
		{
			txt=textArea;
			var file:File=new File();
			file.addEventListener(Event.SELECT, fileSelectHandler);
			file.browseForDirectory("打开已经准备好图片的文件夹:");
		}

		private function fileSelectHandler(e:Event):void
		{
			g_count=0;
			var file:File=e.currentTarget as File;
			file.removeEventListener(Event.SELECT, fileSelectHandler);
			var array:Array=file.getDirectoryListing();
			var sName:String="";
			var mark:String="";
			var f:File=null;
			var len:int=array.length;
			var len1:int=0;
			for (var i:int=0; i < len; i++)
			{
				sName=array[i].name;
				if (array[i].isDirectory && sName.indexOf("D") == 0)
				{
					mark=sName;
					var arr:Array=array[i].getDirectoryListing();
					len1=arr.length;
					for (var n:int=0; n < len1; n++)
					{
						f=arr[n];
						sName=f.name;
						if (f.isDirectory && sName.indexOf("F") == 0)
						{
							imgLib[mark + sName]=f;
							g_count+=f.getDirectoryListing().length;
						}
						else
						{
							f.deleteFile();
						}
					}
				}
				else
				{
					array[i].deleteDirectory(true);
				}
			}
			return;
			g_count=0;
			var file:File=e.currentTarget as File;
			file.removeEventListener(Event.SELECT, fileSelectHandler);
			var array:Array=file.getDirectoryListing();
			var sName:String="";
			var mark:String="";
			var f:File=null;
			var len:int=array.length;
			var len1:int=0;
			for (var i:int=0; i < len; i++)
			{
				sName=array[i].name;
				if (array[i].isDirectory && sName.indexOf("D") == 0)
				{
					mark=sName;
					var arr:Array=array[i].getDirectoryListing();
					len1=arr.length;
					for (var n:int=0; n < len1; n++)
					{
						f=arr[n];
						sName=f.name;
						if (f.isDirectory && sName.indexOf("F") == 0)
						{
							imgLib[mark + sName]=f;
							g_count+=f.getDirectoryListing().length;
						}
						else
						{
							f.deleteFile();
						}
					}
				}
				else
				{
					array[i].deleteDirectory(true);
				}
			}
		}

		public function startSave(algin:Array):void
		{
			stackName="";
			len=0;
			middleInfo=algin;
			g_cur=0;
			txt.parent.mouseChildren=false;
			xml="";
			arrayAllFrame=[];
			timer.start();
		}

		public function stop():void
		{
			imgLib=new Dictionary();
			txt.parent.mouseChildren=true;
			timer.stop();
		}

		private var _array:Array=[];

		private var str_mark:String=null;

		private var g_path:Array=null;
		private var len:int=0;

		private function timerHandler(e:TimerEvent):void
		{
			timer.stop();
			if (_array.length == 0)
			{
				for (str_mark in imgLib)
				{
					_array=imgLib[str_mark].getDirectoryListing();
					delete imgLib[str_mark]
					if (_array.length > 0)
					{
						len=_array.length;
						break;
					}
				}
			}
			if (_array.length > 0)
			{
				cutting(_array.shift(), (len - _array.length) + "", str_mark);
			}
			else
			{

//				<?xml version="1.0" encoding="UTF-8"?>
//				<xml>
//					<!-- x1y1 翅膀 x2y2 头顶字 x3y3 脚下光环 -->
//					<act j="0" m="1" x1="0" y1="0" x2="0" y2="0" x3="0" y3="0">
//						<direct ox="226" oy="191" m="2">
//							<frame c="D1F2001_0_0"/>
//						</direct>
//					</act>
//				</xml>

//				xml="<?xml version=\"1.0\" encoding=\"UTF-8\"?><xml><!-- x1y1 翅膀 x2y2 头顶字 x3y3 脚下光环 -->" + xml + "</xml>";
				xml="<?xml version=\"1.0\" encoding=\"UTF-8\"?><xml><!-- x1 頭頂字 x2y2 腳下光環 x3y3 翅膀 -->";

				var m_len1:int=arrayAllFrame.length;
				for (var m_i1:int=0; m_i1 < m_len1; m_i1++)
				{
					if (arrayAllFrame[m_i1] != null)
					{
						xml+="<act j=\"" + middleInfo[ACTION * DIRECT + ACTION + 1 - m_i1] + "\" m=\"" + m_i1 + "\">";
						var m_len2:int=arrayAllFrame[m_i1].length;
						for (var m_i2:int=0; m_i2 < m_len2; m_i2++)
						{
							if (arrayAllFrame[m_i1][m_i2] != null)
							{
								var directInfo:Array=middleInfo[m_i1 + m_i2 * ACTION];
								xml+="<direct m=\"" + (m_i2 + 1) + "\" ox=\"" + arrayAllFrame[m_i1][m_i2][0].ox + "\" oy=\"" + arrayAllFrame[m_i1][m_i2][0].oy + "\" x1=\"" + directInfo[0] + "\" x2=\"" + directInfo[1] + "\" y2=\"" + directInfo[2] + "\" x3=\"" + directInfo[3] + "\" y3=\"" + directInfo[4] + "\">";
								for (var m_item:String in arrayAllFrame[m_i1][m_i2])
								{
									xml+="<frame c=\"" + arrayAllFrame[m_i1][m_i2][m_item].name + "_" + arrayAllFrame[m_i1][m_i2][m_item].x + "_" + arrayAllFrame[m_i1][m_i2][m_item].y + "\"/>";
								}
								xml+="</direct>";
							}
						}
						xml+="</act>";
					}
				}
				xml+="</xml>";
				if (g_path != null)
				{
					var file:File=new File(g_path.join("\\") + "/已切割图片/pngOffset.xml")
					var fStream:FileStream=new FileStream();
					fStream.open(file, FileMode.WRITE);
					fStream.writeUTFBytes(xml);
					fStream.close();
				}
				txt.parent.mouseChildren=true;
			}
		}
		public var file:File;
		private var loadToFile:Dictionary=new Dictionary();

		private function cutting(file:File, fName:String, mark:String):void
		{
			while (fName.length < 3)
			{
				fName="0" + fName;
			}
			g_cur++;
			fName=mark + fName;
			txt.text="正在处理文件:" + fName + "\n";
			txt.appendText("整体进度:" + g_cur + "/" + g_count);
			var fs:FileStream=new FileStream();
			fs.open(file, FileMode.READ);
			var loader:Loader=new Loader();
			loadToFile[loader]={f: file, fn: fName, label: mark};
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadFileCompleteHandler);
			var ba:ByteArray=new ByteArray();
			fs.readBytes(ba);
			ba.position=0;
			loader.loadBytes(ba);
		}

		private function loadFileCompleteHandler(e:Event):void
		{
			var loader:Loader=e.currentTarget.loader as Loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadFileCompleteHandler);
			var obj:Object=loadToFile[loader];
			fineAlpha(loader, obj.f, obj.fn, obj.label);
		}

		private var stackName:String="";

		private var stackX:int=0;

		private var stackY:int=0;

//		private var middlePoint:Point=null;

		private function fineAlpha(loader:Loader, fileSource:File, fileName:String, label:String):void
		{
			var rect:Rectangle=new Rectangle(0, 0, loader.width, loader.height);
			var bmp:Bitmap=loader.content as Bitmap;
			var bmpd:BitmapData=bmp.bitmapData;
			var ba:ByteArray=bmpd.getPixels(rect);
			var offset:Point=new Point();
			var tempCutLenY:int=0;
			var alp:int=1;
			ba.position=0;
			var count:int=0;
			while (ba.bytesAvailable)
			{
				if (ba.readUnsignedByte() >= alp)
				{
					offset.y=int(count / rect.width);
					break;
				}
				ba.position+=3;
				count++;
			}
			count=0;
			ba.position=ba.length - 4;
			while (ba.bytesAvailable < ba.length)
			{
				if (ba.readUnsignedByte() >= alp)
				{
					tempCutLenY=rect.height - int(count / rect.width);
					break;
				}
				ba.position-=5;
				count++;
			}
			var lx:int=0, ly:int=0;
			for (lx=0; lx < rect.width; lx++)
			{
				for (ly=0; ly < rect.height; ly++)
				{
					ba.position=4 * ly * rect.width + 4 * lx;
					if (ba.readUnsignedByte() >= alp)
					{
						offset.x=lx;
						lx=rect.width;
						break;
					}
				}
			}
			for (lx=rect.width - 1; lx >= 0; lx--)
			{
				for (ly=rect.height - 1; ly >= 0; ly--)
				{
					ba.position=4 * ly * rect.width + 4 * lx;
					if (ba.readUnsignedByte() >= alp)
					{
						rect.width=lx;
						rect.height=tempCutLenY;
						lx=-1;
						break;
					}
				}
			}

			if (stackName.indexOf(label) < 0 || (stackX == 0 && stackY == 0))
			{
				var fp:int=label.indexOf("F");
				d=int(label.substring(1, fp));
				f=int(label.substring(fp + 1)) - 1;
				if (middleInfo[d * (f + 1)] == undefined)
				{
					stop();
					Alert.show("编号:" + label + " 没有找到了对应的输入信息,请检查", "错误提示");
					return;
				}
//				middlePoint=new Point(middleInfo[d][f], 0);

				if (arrayAllFrame[d] == undefined)
				{
					arrayFrame=new Array();
				}
				else
				{
					arrayFrame=arrayAllFrame[d];
				}
				if (arrayFrame[f] == undefined)
				{
					arrayFrame[f]=[];
				}
				arrayAllFrame[d]=arrayFrame;

				stackName=label;
				stackX=offset.x;
				stackY=offset.y;
			}

			var rectW:int=rect.width - offset.x;
			var rectH:int=rect.height - offset.y;
//			 rect = new Rectangle(offset.x, offset.y, rectW % 2 == 0 ? rectW : rectW + 1, rectH % 2 == 0 ? rectH : rectH + 1);
			rect=new Rectangle(offset.x, offset.y, rectW, rectH);

			offset.x-=stackX;
			offset.y-=stackY;

			ba=bmpd.getPixels(rect);
			bmpd.dispose();
			var png:PNGEncoder=new PNGEncoder();
			g_path=fileSource.nativePath.split("\\");
			g_path.pop();
			g_path.pop();
			g_path.pop();
			saveFile.nativePath=g_path.join("\\") + "/已切割图片/" + fileName + "_" + offset.x + "_" + offset.y + ".png"
			fStream.open(saveFile, FileMode.WRITE);
			ba=png.encodeByteArray(ba, rect.width, rect.height);
			ba.position=0;
			fStream.writeBytes(ba);
			fStream.close();
			ba.clear();
//			xml+="<file name=\"" + fileName + "_" + offset.x + "_" + offset.y + "\" x=\"" + middlePoint.x + "\" originX=\"" + stackX + "\" originY=\"" + stackY + "\" mark=\"" + label + "\" />";
			dicFrame=new Dictionary();
			dicFrame["name"]=fileName;
			dicFrame["x"]=offset.x;
			dicFrame["y"]=offset.y;
			dicFrame["ox"]=stackX;
			dicFrame["oy"]=stackY;
			dicFrame["m"]=label;
			arrayFrame[f].push(dicFrame);
			timer.start();
		}
		private var fStream:FileStream=new FileStream();
		private var saveFile:File=new File();

		private var arrayAllFrame:Array;
		private var arrayFrame:Array;
		private var dicFrame:Dictionary;
		private var d:int=0, f:int=0;
	}
}
