package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructBagCell2
    /** 
    *物品数量变化
    */
    public class PacketSCCellChange implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8002;
        /** 
        *变化物品列表
        */
        public var arrItemitem_list:Vector.<StructBagCell2> = new Vector.<StructBagCell2>();
        /** 
        *是否有新的物品加入1.有新的物品0.没有新的物品
        */
        public var newitem:int;
        /** 
        *版本号
        */
        public var version:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemitem_list.length);
            for each (var item_listitem:Object in arrItemitem_list)
            {
                var objitem_list:ISerializable = item_listitem as ISerializable;
                if (null!=objitem_list)
                {
                    objitem_list.Serialize(ar);
                }
            }
            ar.writeInt(newitem);
            ar.writeInt(version);
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemitem_list= new  Vector.<StructBagCell2>();
            var item_listLength:int = ar.readInt();
            for (var iitem_list:int=0;iitem_list<item_listLength; ++iitem_list)
            {
                var objBagCell:StructBagCell2 = new StructBagCell2();
                objBagCell.Deserialize(ar);
                arrItemitem_list.push(objBagCell);
            }
            newitem = ar.readInt();
            version = ar.readInt();
        }
    }
}
