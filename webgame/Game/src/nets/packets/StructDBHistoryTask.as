package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructHoistoryTask2
    /** 
    *
    */
    public class StructDBHistoryTask implements ISerializable
    {
        /** 
        *任务历史
        */
        public var arrItemhistory_list:Vector.<StructHoistoryTask2> = new Vector.<StructHoistoryTask2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemhistory_list.length);
            for each (var history_listitem:Object in arrItemhistory_list)
            {
                var objhistory_list:ISerializable = history_listitem as ISerializable;
                if (null!=objhistory_list)
                {
                    objhistory_list.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemhistory_list= new  Vector.<StructHoistoryTask2>();
            var history_listLength:int = ar.readInt();
            for (var ihistory_list:int=0;ihistory_list<history_listLength; ++ihistory_list)
            {
                var objHoistoryTask:StructHoistoryTask2 = new StructHoistoryTask2();
                objHoistoryTask.Deserialize(ar);
                arrItemhistory_list.push(objHoistoryTask);
            }
        }
    }
}
