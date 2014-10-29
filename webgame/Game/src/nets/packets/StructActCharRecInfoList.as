package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructActCharRecInfo2
    /** 
    *活动得分日志列表
    */
    public class StructActCharRecInfoList implements ISerializable
    {
        /** 
        *活动得分日志列表
        */
        public var arrItemlist:Vector.<StructActCharRecInfo2> = new Vector.<StructActCharRecInfo2>();

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
            arrItemlist= new  Vector.<StructActCharRecInfo2>();
            var listLength:int = ar.readInt();
            for (var ilist:int=0;ilist<listLength; ++ilist)
            {
                var objActCharRecInfo:StructActCharRecInfo2 = new StructActCharRecInfo2();
                objActCharRecInfo.Deserialize(ar);
                arrItemlist.push(objActCharRecInfo);
            }
        }
    }
}
