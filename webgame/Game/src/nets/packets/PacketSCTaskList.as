package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructTaskList2
    /** 
    *玩家已接任务列表
    */
    public class PacketSCTaskList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 6003;
        /** 
        *任务列表
        */
        public var arrItemtasklist:Vector.<StructTaskList2> = new Vector.<StructTaskList2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemtasklist.length);
            for each (var tasklistitem:Object in arrItemtasklist)
            {
                var objtasklist:ISerializable = tasklistitem as ISerializable;
                if (null!=objtasklist)
                {
                    objtasklist.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemtasklist= new  Vector.<StructTaskList2>();
            var tasklistLength:int = ar.readInt();
            for (var itasklist:int=0;itasklist<tasklistLength; ++itasklist)
            {
                var objTaskList:StructTaskList2 = new StructTaskList2();
                objTaskList.Deserialize(ar);
                arrItemtasklist.push(objTaskList);
            }
        }
    }
}
