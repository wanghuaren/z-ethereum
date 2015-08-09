package ui.frame {
	//颜色滤镜类
	//setColor(n:1=正常颜色,2=去掉颜色,3正常高亮,4=去色高亮,5=描边发光)
	import com.bellaxu.def.FilterDef;
	
	import flash.display.MovieClip;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;

	public class UIColor {
		private var _array:Array=[];

		public function UIColor():void {
		}

		public function setColor(mc:Object,n:uint):void {
			if (mc is MovieClip) {
				if (mc["filters_n"]==2||mc["filters_n"]==4) {
					n=n==1?2:4;
				}
				mc["filters_n"]=n;
			}
			_array=[];
			if (n==1) {
				//正常颜色
				_array=[1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
			}
			if (n==2) {
				//去掉颜色
				_array=[0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0];
			}
			if (n==3) {
				//正常高亮
				_array=[2,0,0,0,-63.5,0,2,0,0,-63.5,0,0,2,0,-63.5,0,0,0,1,0];
			}
			if (n==4) {
				//去色高亮
				_array=[0.6172,1.2188,0.164,0,-63.5,0.6172,1.2188,0.164,0,-63.5,0.6172,1.2188,0.164,0,-63.5,0,0,0,1,0];
			}
			if (n==5) {
				//描边发光
				var BitmapFilters:BitmapFilter=getBitmapFilter();
				_array.push(BitmapFilters);
				mc.filters=_array;
				return;
			}
			mc.filters=[new ColorMatrixFilter(_array)];
		}

		public function clearColor(mc:Object):void {
			//清除滤镜
			if (mc is MovieClip) {
				mc["filters_n"]=1;
			}
			_array=[];
			_array=[1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
			mc.filters=[new ColorMatrixFilter(_array)];
		}

		private function getBitmapFilter():BitmapFilter {
//			return FilterDef.UI_COLOR_FILTER;
			return 0;
		}
	}
}