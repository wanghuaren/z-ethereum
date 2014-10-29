package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructBagCell2
    /** 
    *交易查看
    */
    public class PacketSCTradeItemNote implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8661;
        /** 
        *物品信息
        */
        public var roleid:int;
        /** 
        *物品信息
        */
        public var arrItemitems:Vector.<StructBagCell2> = new Vector.<StructBagCell2>();
        /** 
        *元宝
        */
        public var coin3:int;
        /** 
        *是否确认
        */
        public var comfirm:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(roleid);
            ar.writeInt(arrItemitems.length);
            for each (var itemsitem:Object in arrItemitems)
            {
                var objitems:ISerializable = itemsitem as ISerializable;
                if (null!=objitems)
                {
                    objitems.Serialize(ar);
                }
            }
            ar.writeInt(coin3);
            ar.writeInt(comfirm);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleid = ar.readInt();
            arrItemitems= new  Vector.<StructBagCell2>();
            var itemsLength:int = ar.readInt();
            for (var iitems:int=0;iitems<itemsLength; ++iitems)
            {
                var objBagCell:StructBagCell2 = new StructBagCell2();
                objBagCell.Deserialize(ar);
                arrItemitems.push(objBagCell);
            }
            coin3 = ar.readInt();
            comfirm = ar.readInt();
        }
    }
}
