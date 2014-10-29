package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家历史任务列表返回
    */
    public class PacketSCHistoryTaskList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 6029;
        /** 
        *任务列表
        */
        public var arrItemtasklist:Vector.<int> = new Vector.<int>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemtasklist.length);
            for each (var tasklistitem:int in arrItemtasklist)
            {
                ar.writeInt(tasklistitem);
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemtasklist= new  Vector.<int>();
            var tasklistLength:int = ar.readInt();
            for (var itasklist:int=0;itasklist<tasklistLength; ++itasklist)
            {
                arrItemtasklist.push(ar.readInt());
            }
        }
    }
}
