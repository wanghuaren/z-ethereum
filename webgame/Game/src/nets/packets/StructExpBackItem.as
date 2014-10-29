package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *经验找回
    */
    public class StructExpBackItem implements ISerializable
    {
        /** 
        *活动id
        */
        public var actionid:int;
        /** 
        *状态
        */
        public var arrItemstates:Vector.<int> = new Vector.<int>();
        /** 
        *日期
        */
        public var date:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(actionid);
            ar.writeInt(arrItemstates.length);
            for each (var statesitem:int in arrItemstates)
            {
                ar.writeInt(statesitem);
            }
            ar.writeInt(date);
        }
        public function Deserialize(ar:ByteArray):void
        {
            actionid = ar.readInt();
            arrItemstates= new  Vector.<int>();
            var statesLength:int = ar.readInt();
            for (var istates:int=0;istates<statesLength; ++istates)
            {
                arrItemstates.push(ar.readInt());
            }
            date = ar.readInt();
        }
    }
}
