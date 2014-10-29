package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructTaskState2
    /** 
    *任务列表
    */
    public class StructTaskList implements ISerializable
    {
        /** 
        *任务编号
        */
        public var taskid:int;
        /** 
        *任务状态(1可接受2未完成3未提交4不可接5失败)
        */
        public var status:int;
        /** 
        *当前状态1.杀怪的数量2.物品的数量3.地图是否探查
        */
        public var arrItemstate:Vector.<StructTaskState2> = new Vector.<StructTaskState2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(taskid);
            ar.writeInt(status);
            ar.writeInt(arrItemstate.length);
            for each (var stateitem:Object in arrItemstate)
            {
                var objstate:ISerializable = stateitem as ISerializable;
                if (null!=objstate)
                {
                    objstate.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            taskid = ar.readInt();
            status = ar.readInt();
            arrItemstate= new  Vector.<StructTaskState2>();
            var stateLength:int = ar.readInt();
            for (var istate:int=0;istate<stateLength; ++istate)
            {
                var objTaskState:StructTaskState2 = new StructTaskState2();
                objTaskState.Deserialize(ar);
                arrItemstate.push(objTaskState);
            }
        }
    }
}
