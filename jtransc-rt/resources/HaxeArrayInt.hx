import haxe.io.Int32Array;
import haxe.io.Bytes;

class HaxeArrayInt extends HaxeArrayBase {
    public var data:Int32Array = null;

    public function new(length:Int) {
        super();
        this.data = new Int32Array(length);
        this.length = length;
        this.desc = "[I";
    }

    static public function fromArray(items:Array<Dynamic>) {
        if (items == null) return null;
        var out = new HaxeArrayInt(items.length);
        for (n in 0 ... items.length) out.set(n, items[n]);
        return out;
    }

    public function getBytes() return data.view.buffer;

    static public function fromBytes(bytes:Bytes) {
        if (bytes == null) return null;
        var out = new HaxeArrayInt(0);
        out.length = Std.int(bytes.length / 4);
        out.data = Int32Array.fromBytes(bytes); // @TODO: check copy! Must be copied!
        return out;
    }

    inline public function get(index:Int):Int return this.data[checkBounds(index)];
    inline public function set(index:Int, value:Int):Void this.data[checkBounds(index)] = value;
	override public function getDynamic(index:Int):Dynamic return get(index);
	override public function setDynamic(index:Int, value:Dynamic) set(index, value);

    public function join(separator:String) {
        var out = '';
        for (n in 0 ... length) {
            if (n != 0) out += separator;
            out += get(n);
        }
        return out;
    }

    public override function clone() {
        var out = new HaxeArrayInt(length);
        copy(this, out, 0, 0, length);
        return out;
    }

    static public function copy(from:HaxeArrayInt, to:HaxeArrayInt, fromPos:Int, toPos:Int, length:Int) {
        for (n in 0 ... length) to.set(toPos + n, from.get(fromPos + n));
    }
}