package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructAwardTaskList2
    /** 
    *悬赏任务列表
    */
    public class PacketSCTaskAwardList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 6021;
        /** 
        *任务列表
        */
        public var arrItemtasklist:Vector.<StructAwardTaskList2> = new Vector.<StructAwardTaskList2>();
        /** 
        *今天元宝购买剩余次数
        */
        public var cantimes:int;
        /** 
        *距离1970年1月1日秒数
        */
        public var begintime:int;
        /** 
        *今天已接次数
        */
        public var curAcceptTimes:int;
        /** 
        *今天最大可接次数
        */
        public var maxAcceptTimes:int;

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
            ar.writeInt(cantimes);
            ar.writeInt(begintime);
            ar.writeInt(curAcceptTimes);
            ar.writeInt(maxAcceptTimes);
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemtasklist= new  Vector.<StructAwardTaskList2>();
            var tasklistLength:int = ar.readInt();
            for (var itasklist:int=0;itasklist<tasklistLength; ++itasklist)
            {
                var objAwardTaskList:StructAwardTaskList2 = new StructAwardTaskList2();
                objAwardTaskList.Deserialize(ar);
                arrItemtasklist.push(objAwardTaskList);
            }
            cantimes = ar.readInt();
            begintime = ar.readInt();
            curAcceptTimes = ar.readInt();
            maxAcceptTimes = ar.readInt();
        }
    }
}
