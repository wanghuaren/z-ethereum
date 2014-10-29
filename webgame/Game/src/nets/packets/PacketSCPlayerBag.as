package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructBagCell2
    /** 
    *玩家背包列表返回
    */
    public class PacketSCPlayerBag implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8001;
        /** 
        *物品列表
        */
        public var arrItemitem_list:Vector.<StructBagCell2> = new Vector.<StructBagCell2>();
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
            version = ar.readInt();
        }
    }
}
