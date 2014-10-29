package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructTaskState2
    /** 
    *任务详细信息
    */
    public class PacketSCTaskDesc implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 6011;
        /** 
        *任务id
        */
        public var taskid:int;
        /** 
        *任务状态
        */
        public var status:int;
        /** 
        *分步状态
        */
        public var arrItemstep:Vector.<StructTaskState2> = new Vector.<StructTaskState2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(taskid);
            ar.writeInt(status);
            ar.writeInt(arrItemstep.length);
            for each (var stepitem:Object in arrItemstep)
            {
                var objstep:ISerializable = stepitem as ISerializable;
                if (null!=objstep)
                {
                    objstep.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            taskid = ar.readInt();
            status = ar.readInt();
            arrItemstep= new  Vector.<StructTaskState2>();
            var stepLength:int = ar.readInt();
            for (var istep:int=0;istep<stepLength; ++istep)
            {
                var objTaskState:StructTaskState2 = new StructTaskState2();
                objTaskState.Deserialize(ar);
                arrItemstep.push(objTaskState);
            }
        }
    }
}
