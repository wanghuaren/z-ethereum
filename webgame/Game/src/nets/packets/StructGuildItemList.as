package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGuildItemInfo2
    /** 
    *工会珍宝研发信息
    */
    public class StructGuildItemList implements ISerializable
    {
        /** 
        *珍宝列表
        */
        public var arrItemlist:Vector.<StructGuildItemInfo2> = new Vector.<StructGuildItemInfo2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemlist.length);
            for each (var listitem:Object in arrItemlist)
            {
                var objlist:ISerializable = listitem as ISerializable;
                if (null!=objlist)
                {
                    objlist.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemlist= new  Vector.<StructGuildItemInfo2>();
            var listLength:int = ar.readInt();
            for (var ilist:int=0;ilist<listLength; ++ilist)
            {
                var objGuildItemInfo:StructGuildItemInfo2 = new StructGuildItemInfo2();
                objGuildItemInfo.Deserialize(ar);
                arrItemlist.push(objGuildItemInfo);
            }
        }
    }
}
