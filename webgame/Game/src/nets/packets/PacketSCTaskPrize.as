package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructNpcFunc2
    /** 
    *任务奖励
    */
    public class PacketSCTaskPrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 6001;
        /** 
        *任务编号
        */
        public var taskid:int;
        /** 
        *NPC功能列表
        */
        public var arrItemfunclist:Vector.<StructNpcFunc2> = new Vector.<StructNpcFunc2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(taskid);
            ar.writeInt(arrItemfunclist.length);
            for each (var funclistitem:Object in arrItemfunclist)
            {
                var objfunclist:ISerializable = funclistitem as ISerializable;
                if (null!=objfunclist)
                {
                    objfunclist.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            taskid = ar.readInt();
            arrItemfunclist= new  Vector.<StructNpcFunc2>();
            var funclistLength:int = ar.readInt();
            for (var ifunclist:int=0;ifunclist<funclistLength; ++ifunclist)
            {
                var objNpcFunc:StructNpcFunc2 = new StructNpcFunc2();
                objNpcFunc.Deserialize(ar);
                arrItemfunclist.push(objNpcFunc);
            }
        }
    }
}
