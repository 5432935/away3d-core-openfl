package openfl.display3D;

import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.utils.Float32Array;
import openfl.utils.ByteArray;

class VertexBuffer3D 
{
    public var data32PerVertex:Int;
    public var glBuffer:GLBuffer;
    public var numVertices:Int;

    public function new(glBuffer:GLBuffer, numVertices:Int, data32PerVertex:Int) 
    {
        this.glBuffer = glBuffer;
        this.numVertices = numVertices;
        this.data32PerVertex = data32PerVertex;
    }

    public function dispose():Void 
    {
        GL.deleteBuffer(glBuffer);
    }

    public function uploadFromFloat32Array(float32Array:Float32Array, startOffset:Int, count:Int):Void 
    {
        // for (i in 0...176) {
        //     trace("i:"+i+" = "+float32Array[i]);
        // }
        var s = Lib.getTimer();
        GL.bindBuffer(GL.ARRAY_BUFFER, glBuffer);         
        GL.bufferData(GL.ARRAY_BUFFER, float32Array, GL.STATIC_DRAW);
        trace("Time="+(s-Lib.getTimer()));
    }

    public function uploadFromByteArray(byteArray:ByteArray, byteArrayOffset:Int, startOffset:Int, count:Int):Void 
    {
        var bytesPerVertex = data32PerVertex * 4;
        GL.bindBuffer(GL.ARRAY_BUFFER, glBuffer);
        var length : Int = count * bytesPerVertex;
        var offset : Int = byteArrayOffset + startOffset * bytesPerVertex;
        var float32Array : Float32Array;
        
        #if html5
        float32Array = new Float32Array(length);
        byteArray.position = offset;
        var i:Int = 0;
        while (byteArray.position < length + offset) {
            float32Array[i] = byteArray.readUnsignedByte();
            i++;
        }
        #else
        float32Array = new Float32Array(byteArray, offset, length);
        #end
        
        GL.bufferData(GL.ARRAY_BUFFER, float32Array, GL.STATIC_DRAW);
    }

    public function uploadFromVector(data:Array<Float>, startVertex:Int, numVertices:Int):Void 
    {
        var bytesPerVertex = data32PerVertex * 4;
        GL.bindBuffer(GL.ARRAY_BUFFER, glBuffer);
        var length : Int = numVertices * data32PerVertex;
        var offset : Int = startVertex;
        var float32Array : Float32Array = new Float32Array(data, offset, length);
        GL.bufferData(GL.ARRAY_BUFFER, float32Array, GL.STATIC_DRAW);
        float32Array = null;
   }
}
