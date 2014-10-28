package engine.utils.compress {
	public class ArrDCode {
		public static function DCode(newstr:String,reArray:Boolean=false):* {
			newstr=KeyCode.getCode(newstr,false);
			var levelA:String=",";
			var levelB:String="|";
			var levelC:String=levelA;
			var strarr:Array=[];
			var newcode:String="";
			var arr:Array=newstr.split(levelB);
			for (var s:* in arr) {
				var strz:Array=arr[s].split(levelC);
				for (var z:* in strz) {
					var sa:String=strz[z].substr(0,1);
					var sb:String=strz[z].substr(1,strz[z].length);
					sb=strz[z].length==1?1+"":sb;
					for (var len:int=0; len<int(sb); len++) {
						newcode+=sa+levelA;
					}
				}
				newcode+=levelB;
			}
			newcode=newcode.split(levelA+levelB).join(levelB);
			newcode=(newcode.lastIndexOf(levelB)==newcode.length-1)?newcode.substr(0,newcode.length-1):newcode;
			if (reArray) {
				strarr=newcode.split(levelB);
				for (var h:* in strarr) {
					strarr[h]=strarr[h].split(levelA);
				}
				return strarr;
			} else {
				return newcode;
			}
		}
	}
}