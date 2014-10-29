package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructNextList2
    /** 
    *玩家可接任务列表
    */
    public class PacketSCTaskNextList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 6005;
        /** 
        *任务列表
        */
        public var arrItemtasklist:Vector.<StructNextList2> = new Vector.<StructNextList2>();

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
            arrItemtasklist= new  Vector.<StructNextList2>();
            var tasklistLength:int = ar.readInt();
            for (var itasklist:int=0;itasklist<tasklistLength; ++itasklist)
            {
                var objNextList:StructNextList2 = new StructNextList2();
                objNextList.Deserialize(ar);
                arrItemtasklist.push(objNextList);
            }
        }
    }
}
