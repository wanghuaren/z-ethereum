package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructPrizeMsgDbInfoItem2
    /** 
    *物品信息
    */
    public class StructPrizeMsgDbInfoItems implements ISerializable
    {
        /** 
        *物品信息列表
        */
        public var arrItemitems:Vector.<StructPrizeMsgDbInfoItem2> = new Vector.<StructPrizeMsgDbInfoItem2>();
        /** 
        *奖励信息
        */
        public var msg:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemitems.length);
            for each (var itemsitem:Object in arrItemitems)
            {
                var objitems:ISerializable = itemsitem as ISerializable;
                if (null!=objitems)
                {
                    objitems.Serialize(ar);
                }
            }
            PacketFactory.Instance.WriteString(ar, msg, 256);
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemitems= new  Vector.<StructPrizeMsgDbInfoItem2>();
            var itemsLength:int = ar.readInt();
            for (var iitems:int=0;iitems<itemsLength; ++iitems)
            {
                var objPrizeMsgDbInfoItem:StructPrizeMsgDbInfoItem2 = new StructPrizeMsgDbInfoItem2();
                objPrizeMsgDbInfoItem.Deserialize(ar);
                arrItemitems.push(objPrizeMsgDbInfoItem);
            }
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
