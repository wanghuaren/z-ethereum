
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_Shop_IbResModel  implements IResModel
	{
		private var _id:int=0;//索引
		private var _GoodsID:int=0;//商品编号
		private var _ItemID:int=0;//物品编号
		private var _num:int=0;//道具数量
		private var _ItemName:String="";//物品名称
		private var _ItemRuler:String="";//绑定类型
		private var _Type:int=0;//物品类型
		private var _is_show:int=0;//是否展示
		private var _show_id:int=0;//展示资源
		private var _SubType:int=0;//物品子类型
		private var _Sign:int=0;//物品标记
		private var _MoneyType:int=0;//货币类型
		private var _IB:int=0;//物品原价
		private var _IBS:int=0;//打折后价格
		private var _Switch:int=0;//物品上架开关
		private var _ShowType:int=0;//上架时间类型
		private var _OnSaleDate:int=0;//上架时间
		private var _OffSaleDate:int=0;//下架时间
		private var _Icon:int=0;//图标
		
	
		public function Pub_Shop_IbResModel(
args:Array
		)
		{
			_id = args[0];
			_GoodsID = args[1];
			_ItemID = args[2];
			_num = args[3];
			_ItemName = args[4];
			_ItemRuler = args[5];
			_Type = args[6];
			_is_show = args[7];
			_show_id = args[8];
			_SubType = args[9];
			_Sign = args[10];
			_MoneyType = args[11];
			_IB = args[12];
			_IBS = args[13];
			_Switch = args[14];
			_ShowType = args[15];
			_OnSaleDate = args[16];
			_OffSaleDate = args[17];
			_Icon = args[18];
			
		}
																																																											
                public function get id():int
                {
	                return _id;
                }

                public function get GoodsID():int
                {
	                return _GoodsID;
                }

                public function get ItemID():int
                {
	                return _ItemID;
                }

                public function get num():int
                {
	                return _num;
                }

                public function get ItemName():String
                {
	                return _ItemName;
                }

                public function get ItemRuler():String
                {
	                return _ItemRuler;
                }

                public function get Type():int
                {
	                return _Type;
                }

                public function get is_show():int
                {
	                return _is_show;
                }

                public function get show_id():int
                {
	                return _show_id;
                }

                public function get SubType():int
                {
	                return _SubType;
                }

                public function get Sign():int
                {
	                return _Sign;
                }

                public function get MoneyType():int
                {
	                return _MoneyType;
                }

                public function get IB():int
                {
	                return _IB;
                }

                public function get IBS():int
                {
	                return _IBS;
                }

                public function get Switch():int
                {
	                return _Switch;
                }

                public function get ShowType():int
                {
	                return _ShowType;
                }

                public function get OnSaleDate():int
                {
	                return _OnSaleDate;
                }

                public function get OffSaleDate():int
                {
	                return _OffSaleDate;
                }

                public function get Icon():int
                {
	                return _Icon;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            id:this.id.toString(),
				GoodsID:this.GoodsID.toString(),
				ItemID:this.ItemID.toString(),
				num:this.num.toString(),
				ItemName:this.ItemName.toString(),
				ItemRuler:this.ItemRuler.toString(),
				Type:this.Type.toString(),
				is_show:this.is_show.toString(),
				show_id:this.show_id.toString(),
				SubType:this.SubType.toString(),
				Sign:this.Sign.toString(),
				MoneyType:this.MoneyType.toString(),
				IB:this.IB.toString(),
				IBS:this.IBS.toString(),
				Switch:this.Switch.toString(),
				ShowType:this.ShowType.toString(),
				OnSaleDate:this.OnSaleDate.toString(),
				OffSaleDate:this.OffSaleDate.toString(),
				Icon:this.Icon.toString()
	            };			
	            return o;
			
            }
	}
 }