package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructQQTaskInfo2
    /** 
    *任务集市
    */
    public class StructQQTaskList implements ISerializable
    {
        /** 
        *
        */
        public var arrItemitems:Vector.<StructQQTaskInfo2> = new Vector.<StructQQTaskInfo2>();

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
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemitems= new  Vector.<StructQQTaskInfo2>();
            var itemsLength:int = ar.readInt();
            for (var iitems:int=0;iitems<itemsLength; ++iitems)
            {
                var objQQTaskInfo:StructQQTaskInfo2 = new StructQQTaskInfo2();
                objQQTaskInfo.Deserialize(ar);
                arrItemitems.push(objQQTaskInfo);
            }
        }
    }
}
