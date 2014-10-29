package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSaleBagCell2
    /** 
    *查看摊位
    */
    public class PacketSCBoothLook implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8605;
        /** 
        *卖家ID
        */
        public var seller_id:int;
        /** 
        *摊位名称
        */
        public var name:String = new String();
        /** 
        *物品信息
        */
        public var arrItemitems:Vector.<StructSaleBagCell2> = new Vector.<StructSaleBagCell2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(seller_id);
            PacketFactory.Instance.WriteString(ar, name, 20);
            ar.writeInt(arrItemitems.length);
            for each (var itemsitem:Object in arrItemitems)
            {
                var objitems:ISerializable = itemsitem as ISerializable;
                if (null!=objitems)
                {
                    objitems.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            seller_id = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            arrItemitems= new  Vector.<StructSaleBagCell2>();
            var itemsLength:int = ar.readInt();
            for (var iitems:int=0;iitems<itemsLength; ++iitems)
            {
                var objSaleBagCell:StructSaleBagCell2 = new StructSaleBagCell2();
                objSaleBagCell.Deserialize(ar);
                arrItemitems.push(objSaleBagCell);
            }
        }
    }
}
